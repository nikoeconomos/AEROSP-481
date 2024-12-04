function [] = plot_V_n_diagram(aircraft)
% Description: This function generates a V-N diagram for the aircraft, 
% providing a graphical representation of structural and
% aerodynamic limits. It includes maneuvering and gust envelopes to evaluate 
% operational safety.
%
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs such as weight, 
%               wing area, and load factor limits.
%
% OUTPUTS:
% --------------------------------------------
%    v-n Diagram - struct containing calculated values for maneuvering and gust 
%                envelopes
%
% See also: sizing.m
% Author:                          Vienna
% Version history revision notes:
%                                  v1: 11/24/24

%% Aircraft parameters and constants

[~, ~, rho_SL, ~]  = standard_atmosphere_calc(0); % Sea-level conditions
rho_SL_metric = rho_SL;
rho_SL_engl = rho_SL * 0.0019403203; % convert to slugs/ft^3
[~, ~, rho_cruise, a_cruise] = standard_atmosphere_calc(10668); % Altitude of 35,000 ft (10668 m)
[~, ~, rho_2k, ~] = standard_atmosphere_calc(6096);
rho_2k_engl = rho_2k * 0.0019403203; % convert to slugs/ft^3
g = 9.81; % (m/s^2)


TAS_to_EAS = @(V_tas, rho) V_tas * sqrt(rho / rho_SL_metric); % TAS to EAS conversion

ff  = aircraft.weight.ff;
W_S_min          = ((aircraft.weight.togw * g) / aircraft.geometry.wing.S_ref) * (1 - (ff - 0.05)); % Wing loading at 5% fuel weight remaining (N/m^2)
W_S_min_imp_mass = W_S_min / g * 0.204816; % kg/m2 to lb/ft2

W_S_max          = ((aircraft.weight.togw * g) / aircraft.geometry.wing.S_ref) * (1 - ff + (ff * 0.96)); % Wing loading at takeoff weight (N/m^2)
W_S_max_imp_mass = W_S_max / g * 0.204816;

c_bar = aircraft.geometry.wing.S_ref / aircraft.geometry.wing.b; % Mean geometric chord (m)
c_bar_engl = c_bar * 3.281; % m to ft 

CL_max    = aircraft.aerodynamics.CL.cruise;
C_L_alpha = 6.69; % parameter on different branch TODO DEFINE FOR 

n_limit    = aircraft.performance.load_factor.limit_upper_limit; % Positive limit load factor
n_negative = aircraft.performance.load_factor.limit_lower_limit; % Negative limit load factor

%% Gust velocity

U_e_VB = 66;
U_e_VC = 50;
U_e_VD = 25;

% mu for gust 
W_S = W_S_max_imp_mass;
g_engl = g * 1.5;
mu = (2 * W_S) / (rho_2k_engl * c_bar_engl * C_L_alpha * g_engl) * g;
disp(mu)

% Gust alleviation factor (K_g)
K_g = (0.88 * mu) / (5.3 + mu);

%% Velocities

% Cruise conditions
VC_TAS = aircraft.performance.mach.cruise * a_cruise; % Cruise TAS 
VC_EAS = TAS_to_EAS(VC_TAS, rho_cruise); % Cruise EAS m/s
VC_EAS_kts = VC_EAS*1.94384; % Cruise EAS 
disp(VC_EAS_kts)

% Maximum operating speed (VMO)
VMO_TAS = aircraft.performance.mach.dash * a_cruise; % VMO TAS Cruise and Dash both at 35k
VMO_EAS = TAS_to_EAS(VMO_TAS, rho_cruise); % VMO EAS 
VMO_EAS_kts = VMO_EAS*1.94384;

% Dive speed (VD)
VD_EAS = 1.07 * VMO_EAS; % Dive speed EAS, page 108 metabook
VD_EAS_kts = VD_EAS*1.94384;

% Stall speed (VS)
VS_EAS = sqrt((2 * W_S) / (rho_SL * CL_max)); % Stall speed in EAS at cruise
VS_EAS_kts = VS_EAS*1.94384;
VS_EAS_ft_s = VS_EAS * 3.281;

% Maneuvering speed (VA)
VA_EAS = sqrt(n_limit) * VS_EAS; % Maneuvering speed in EAS 
VA_EAS_kts = VA_EAS*1.94384;

% Gust penetration speed (VB)
VB_EAS = sqrt((2 * W_S * (n_limit - 1)) / (rho_SL * CL_max)); % VB EAS in m/s
VB_EAS_kts = VB_EAS*1.94384;

% Velocity Range
V = linspace(0, VD_EAS_kts, 700); % EAS range m/s
V_ft_s = V.* 3.281; % EAS range in ft/s
V_kts = V .* 1.944; % EAS range in kts


%% Load limit factors

% Positive and negative maneuver load factors

n_maneuver_positive = min(n_limit,     (rho_SL_engl * (V_ft_s).^2 * CL_max) / (2 * W_S) * g);
n_maneuver_negative = max(n_negative, -(rho_SL_engl * (V_ft_s).^2 * CL_max) / (2 * W_S) * g); % CL min?

% Gust load factors
n_gust_pos_VC = 1 + (K_g * C_L_alpha * U_e_VC .* V_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_VC = 1 - (K_g * C_L_alpha * U_e_VC .* V_kts) / (498 * W_S_max_imp_mass )* g;

n_gust_pos_VD = 1 + (K_g * C_L_alpha * U_e_VD .* V_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_VD = 1 - (K_g * C_L_alpha * U_e_VD .* V_kts) / (498 * W_S_max_imp_mass) * g;

n_gust_pos_VB = 1 + (K_g * C_L_alpha * U_e_VB .* V_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_VB = 1 - (K_g * C_L_alpha * U_e_VB .* V_kts) / (498 * W_S_max_imp_mass) * g;

%Calculate the n-value of the 50 ft/s gust line at V_C
n_gust_pos_at_VC = 1 + (K_g * C_L_alpha * U_e_VC * VC_EAS_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_at_VC = 1 - (K_g * C_L_alpha * U_e_VC * VC_EAS_kts) / (498 * W_S_max_imp_mass) * g;

% Calculate the n-value of the 25 ft/s gust line at V_D
n_gust_pos_at_VD = 1 + (K_g * C_L_alpha * U_e_VD * VD_EAS_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_at_VD = 1 - (K_g * C_L_alpha * U_e_VD * VD_EAS_kts) / (498 * W_S_max_imp_mass) * g;
 
% Calculate the neg n-value of the 25 ft/s gust line at V_B
n_gust_pos_at_VB = 1 + (K_g * C_L_alpha * U_e_VB * VB_EAS_kts) / (498 * W_S_max_imp_mass) * g;
n_gust_neg_at_VB = 1 - (K_g * C_L_alpha * U_e_VB * VB_EAS_kts) / (498 * W_S_max_imp_mass) * g; 

n_gust_pos_at_VA = 1 + (K_g * C_L_alpha * U_e_VB * VA_EAS_kts) / (498 * W_S_max_imp_mass) * g;

% Combined envelope (intersection of gust and maneuver lines)
n_combined_pos = n_maneuver_positive;
n_combined_neg = max(n_negative, n_gust_neg_at_VB);

%% Plotting %%

% Plot the V-n diagram
figure;
hold on;

% Colors for autumn/winter feel
maneuver_color = '#8B3A3A'; % Muted Burgundy
gust_vc_color = '#D07B56'; % Muted Rust
gust_vd_color = '#C9A66B'; % Muted Gold
gust_vb_color = '#6D8B74'; % Muted Olive
stall_color = '#3C6478'; % Muted Slate
combined_color = '#000000'; % Black for Combined Envelope
critical_color = '#555555'; % Muted Gray
inst_turn_color = '#8B5E83'; % Muted Plum
sust_turn_09_color = '#7E947D'; % Muted Forest Green
sust_turn_12_color = '#B1A994'; % Muted Sandstone


% Maneuver envelope
plot(V, n_maneuver_positive, 'Color', maneuver_color, 'LineWidth', 1.5, 'DisplayName', 'Limit Maneuver Envelope');
plot(V, n_maneuver_negative, 'Color', maneuver_color, 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Gust lines
plot(V_kts, n_gust_pos_VC, 'Color', gust_vc_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'DisplayName', 'VC Gust Line');
plot(V_kts, n_gust_neg_VC, 'Color', gust_vc_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(V_kts, n_gust_pos_VD, 'Color', gust_vd_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'DisplayName', 'VD Gust Line');
plot(V_kts, n_gust_neg_VD, 'Color', gust_vd_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(V_kts, n_gust_pos_VB, 'Color', gust_vb_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'DisplayName', 'VB Gust Line');
plot(V_kts, n_gust_neg_VB, 'Color', gust_vb_color, 'LineStyle', '-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Combined envelope
plot(V, n_combined_pos, 'Color', combined_color, 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');
plot(V, n_combined_neg, 'Color', combined_color, 'LineStyle', '-', 'LineWidth', 2, 'HandleVisibility', 'off');

% Stall speed
plot([VS_EAS_ft_s VS_EAS_ft_s], [3 -3], 'Color',stall_color, 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Stall Speed');
plot([VD_EAS_kts VD_EAS_kts], [n_gust_pos_at_VD n_gust_neg_at_VD], 'Color', combined_color, 'LineStyle', '-', 'LineWidth', 2, 'HandleVisibility', 'off');

% Critical speeds
plot(VA_EAS_kts + 15, n_limit, 'o', 'MarkerFaceColor', '#34393F', 'MarkerEdgeColor', '#34393F', 'DisplayName', 'Corner Speed');
plot(VB_EAS_kts, n_gust_pos_at_VB, 'o', 'MarkerFaceColor', '#E8ECEF', 'MarkerEdgeColor', '#E8ECEF', 'DisplayName', 'Gust Design Speed');

% % % Annotations
text(VA_EAS_kts + 15, n_limit + .5, 'V_A', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VS_EAS_ft_s, 1.1, 'V_S', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VB_EAS_kts, 6 + 0.5, 'V_B', 'HorizontalAlignment', 'center', 'FontSize', 10);
% 
% % % Mark the point where the gust line intersects V_C
plot(VC_EAS_kts, n_gust_pos_at_VC, 'o', 'MarkerFaceColor', '#5D89A8', 'MarkerEdgeColor', '#5D89A8', 'DisplayName', 'Design Speed (pos lim)');
text(VC_EAS_kts, n_gust_pos_at_VC + 0.5, 'V_C', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VC_EAS_kts, n_gust_neg_at_VC,  'o', 'MarkerFaceColor', '#5D89A8', 'MarkerEdgeColor', '#5D89A8', 'HandleVisibility','off');
% % 
% % % Mark the point where the gust line intersects V_D
plot(VD_EAS_kts, n_gust_pos_at_VD, 'o', 'MarkerFaceColor', '#A85D5D', 'MarkerEdgeColor', '#A85D5D', 'DisplayName', 'Do Not Exceed Speed (pos lim)');
text(VD_EAS_kts, n_gust_pos_at_VD + 0.5, 'V_D', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VD_EAS_kts, n_gust_neg_at_VD, 'o', 'MarkerFaceColor', '#A85D5D', 'MarkerEdgeColor', '#A85D5D','HandleVisibility', 'off');
% 
plot([VC_EAS_kts VD_EAS_kts], [n_gust_pos_at_VC n_gust_pos_at_VD], 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
plot([VC_EAS_kts VD_EAS_kts], [n_gust_neg_at_VC n_gust_neg_at_VD], 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
% 
% % % Mark the point where the gust line intersects n_limit
text(VB_EAS_kts, n_gust_neg_at_VB - 0.5, 'V_B', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VB_EAS_kts, n_gust_neg_at_VB, 'o', 'MarkerFaceColor', '#E8ECEF', 'MarkerEdgeColor', '#E8ECEF', 'HandleVisibility','off');
% 
plot ([VA_EAS_kts + 15 VC_EAS_kts], [(n_gust_pos_at_VA)  n_gust_pos_at_VC],  'k-','LineWidth',2, 'HandleVisibility','off');
plot ([VB_EAS_kts VC_EAS_kts], [n_gust_neg_at_VB n_gust_neg_at_VC],  'k-', 'LineWidth',2, 'HandleVisibility','off');
plot ([0 VB_EAS_kts ], [1 n_gust_neg_at_VB],  'k-', 'LineWidth',2, 'HandleVisibility','off');

% Instantaneous Turn at Corner Speed (V_A)
n_inst_turn = 5.08; % Load factor for instantaneous turn
plot(VA_EAS_kts, n_inst_turn, 'o', 'MarkerFaceColor', inst_turn_color, 'MarkerEdgeColor', inst_turn_color, 'DisplayName', 'Instantaneous Turn');
text(VA_EAS_kts + 10, n_inst_turn + 0.5, 'Instantaneous Turn (V_A)', 'FontSize', 10, 'HorizontalAlignment', 'left');

% Sustained Turn at Mach 0.9
Mach_09 = 0.9;
V_Mach09_TAS = Mach_09 * a_cruise; % True Airspeed (TAS) at Mach 0.9
V_Mach09_EAS = TAS_to_EAS(V_Mach09_TAS, rho_cruise); % Convert to EAS
V_Mach09_EAS_kts = V_Mach09_EAS * 1.94384; % Convert to knots
n_sustained_Mach09 = 3; % Sustained load factor
plot(V_Mach09_EAS_kts, n_sustained_Mach09, 'o', 'MarkerFaceColor', sust_turn_09_color, 'MarkerEdgeColor', sust_turn_09_color, 'DisplayName', 'Sustained Turn Mach 0.9');
text(V_Mach09_EAS_kts + 10, n_sustained_Mach09 + 0.5, 'Sustained Turn (Mach 0.9)', 'FontSize', 10, 'HorizontalAlignment', 'left');

% Sustained Turn at Mach 1.2
Mach_12 = 1.2;
V_Mach12_TAS = Mach_12 * a_cruise; % True Airspeed (TAS) at Mach 1.2
V_Mach12_EAS = TAS_to_EAS(V_Mach12_TAS, rho_cruise); % Convert to EAS
V_Mach12_EAS_kts = V_Mach12_EAS * 1.94384; % Convert to knots
n_sustained_Mach12 = 3; % Sustained load factor
plot(V_Mach12_EAS_kts, n_sustained_Mach12, 'o', 'MarkerFaceColor', sust_turn_12_color, 'MarkerEdgeColor', sust_turn_12_color, 'DisplayName', 'Sustained Turn Mach 1.2');
text(V_Mach12_EAS_kts + 10, n_sustained_Mach12 - 0.5, 'Sustained Turn (Mach 1.2)', 'FontSize', 10, 'HorizontalAlignment', 'left');

%Labels, grid, and legend

title('V-n Diagram');
xlabel('Equivalent Airspeed (EAS)');
ylabel('Load Factor (n)');
grid on;
legend('Location', 'SouthEast');
xlim([0 VD_EAS + 200]);
ylim([n_negative - 5, n_limit + 5]);
hold off;

end