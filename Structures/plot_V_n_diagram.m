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
[~, ~, rho_cruise, a_cruise] = standard_atmosphere_calc(10668); % Altitude of 35,000 ft (10668 m)
g = 9.81; % (m/s^2)

TAS_to_EAS = @(V_tas, rho) V_tas * sqrt(rho / rho_SL); % TAS to EAS conversion

ff  = aircraft.weight.ff;
W_S_min          = ((aircraft.weight.togw * g) / aircraft.geometry.wing.S_ref) * (1 - (ff - 0.05)); % Wing loading at 5% fuel weight remaining (N/m^2)
W_S_min_imp_mass = W_S_min / g * 0.204816; % kg/m2 to lb/ft2

W_S_max          = ((aircraft.weight.togw * g) / aircraft.geometry.wing.S_ref) * (1 - ff + (ff * 0.96)); % Wing loading at takeoff weight (N/m^2)
W_S_max_imp_mass = W_S_max / g * 0.204816;

c_bar = aircraft.geometry.wing.S_ref / aircraft.geometry.wing.b; % Mean geometric chord (m)

CL_max    = aircraft.aerodynamics.CL.cruise;
C_L_alpha = 3.0562; % parameter on different branch TODO DEFINE FOR 

n_limit    = aircraft.performance.load_factor.upper_limit; % Positive limit load factor
n_negative = aircraft.performance.load_factor.lower_limit; % Negative limit load factor

%% Gust velocity interpolation

% Define altitude points, metabook 11.1
table_altitudes = [20000, 50000]; % ft

% Define gust speeds at the two altitudes
VB = [66, 38]; % Rough air gust (ft/s)
VC = [50, 25]; % Gust at max design speed (ft/s)
VD = [25, 12.5]; % Gust at max dive speed (ft/s)

% Target altitude
cruise_altitude = 35000; % ft

% Perform linear interpolation
U_e_VB = interp1(table_altitudes, VB, cruise_altitude); % ft/s
U_e_VC = interp1(table_altitudes, VC, cruise_altitude); % ft/s
U_e_VD = interp1(table_altitudes, VD, cruise_altitude); % ft/s

% mu for gust 
mu = (2 * W_S) / (rho_cruise * c_bar * C_L_alpha * g);
disp(mu)

% Gust alleviation factor (K_g)
K_g = (0.88 * mu) / (5.3 + mu);

%% Velocities

% Cruise conditions
VC_TAS = aircraft.performance.mach.cruise * a_cruise; % Cruise TAS 
VC_EAS = TAS_to_EAS(VC_TAS, rho_cruise); % Cruise EAS m/s
VC_EAS_kts = VC_EAS*1.94384; % Cruise EAS 

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

% Maneuvering speed (VA)
VA_EAS = sqrt(n_limit) * VS_EAS; % Maneuvering speed in EAS 
VA_EAS_kts = VA_EAS*1.94384;

% Gust penetration speed (VB)
VB_EAS = sqrt((2 * W_S * (n_limit - 1)) / (rho_SL * CL_max)); % VB EAS in m/s
VB_EAS_kts = VB_EAS*1.94384;

% Velocity Range
V = linspace(0, VD_EAS, 700); % EAS range m/s
V_kts = V.*1.94384; % EAS range in knots

%% Load limit factors

% Positive and negative maneuver load factors
n_maneuver_positive = min(n_limit,     (rho_SL * V.^2 * CL_max) / (2 * W_S));
n_maneuver_negative = max(n_negative, -(rho_SL * V.^2 * CL_max) / (2 * W_S)); % CL min?

% Gust load factors
n_gust_pos_VC = 1 + ((K_g * C_L_alpha * U_e_VC * V_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_VC = 1 - ((K_g * C_L_alpha * U_e_VC * V_kts) / (498 * W_S_min_imp_mass));

n_gust_pos_VD = 1 + ((K_g * C_L_alpha * U_e_VD * V_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_VD = 1 - ((K_g * C_L_alpha * U_e_VD * V_kts) / (498 * W_S_min_imp_mass));

n_gust_pos_VB = 1 + ((K_g * C_L_alpha * U_e_VB * V_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_VB = 1 - ((K_g * C_L_alpha * U_e_VB * V_kts) / (498 * W_S_min_imp_mass));

% Calculate the n-value of the 50 ft/s gust line at V_C
n_gust_pos_at_VC = 1 + ((K_g * C_L_alpha * U_e_VC * VC_EAS_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_at_VC = 1 - ((K_g * C_L_alpha * U_e_VC * VC_EAS_kts) / (498 * W_S_min_imp_mass));

% Calculate the n-value of the 25 ft/s gust line at V_D
n_gust_pos_at_VD = 1 + ((K_g * C_L_alpha * U_e_VD * VD_EAS_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_at_VD = 1 - ((K_g * C_L_alpha * U_e_VD * VD_EAS_kts) / (498 * W_S_min_imp_mass));

% Calculate the neg n-value of the 25 ft/s gust line at V_B
n_gust_pos_at_VB = 1 + ((K_g * C_L_alpha * U_e_VB * VB_EAS_kts) / (498 * W_S_min_imp_mass));
n_gust_neg_at_VB = 1 - ((K_g * C_L_alpha * U_e_VB * VB_EAS_kts) / (498 * W_S_min_imp_mass));

% Combined envelope (intersection of gust and maneuver lines)
n_combined_pos = n_maneuver_positive;
n_combined_neg = max(n_negative, n_gust_neg_at_VB);

n_manuever_pos_at_VS = 1 + ((K_g * C_L_alpha * U_e_VB * VS_EAS_kts) / (498 * W_S_min_imp_mass));
n_manuever_neg_at_VS = 1 -  (rho_SL * VS_EAS.^2 * CL_max) / (2 * W_S); % TODO FIX

%% Plotting %%

% Plot the V-n diagram
figure;
hold on;

% Maneuver envelope
plot(V, n_maneuver_positive, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Limit Maneuver Envelope');
plot(V, n_maneuver_negative, 'b--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Gust lines
plot(V, n_gust_pos_VC, 'g-.', 'LineWidth', 1.5, 'DisplayName', 'VC Gust Line');
plot(V, n_gust_neg_VC, 'g-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(V, n_gust_pos_VD, 'r-.', 'LineWidth', 1.5, 'DisplayName', 'VD Gust Line');
plot(V, n_gust_neg_VD, 'r-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(V, n_gust_pos_VB, 'c-.', 'LineWidth', 1.5, 'DisplayName', 'VB Gust Line');
plot(V, n_gust_neg_VB, 'c-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Combined envelope
plot(V, n_combined_pos, 'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');
plot(V, n_combined_neg, 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
plot([VS_EAS VS_EAS], [n_manuever_pos_at_VS n_manuever_neg_at_VS], 'm-', 'LineWidth', 2, 'DisplayName', 'Stall Speed');
plot([VD_EAS VD_EAS], [n_gust_pos_at_VD n_gust_neg_at_VD],'k-', 'LineWidth', 2, 'DisplayName', 'Limit Maneuver Envelope')

% Critical speeds
plot(VA_EAS, n_limit, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Corner Speed');
plot(VS_EAS, 1, 'mo', 'MarkerFaceColor', 'm', 'DisplayName', 'Stall Speed (VS)');
plot(VB_EAS, n_pos_gust_at_VB, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'Gust Design Speed');

% Annotations
text(VA_EAS, n_limit + 0.5, 'V_A', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VS_EAS, 1.1, 'V_S', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VB_EAS, 3.5 + 0.5, 'V_B', 'HorizontalAlignment', 'center', 'FontSize', 10);

% Mark the point where the gust line intersects V_C
plot(VC_EAS, n_gust_at_VC, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Design Speed (pos lim)');
text(VC_EAS, n_gust_at_VC + 0.5, 'V_C', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VC_EAS, n_neg_gust_at_VC, 'ro', 'MarkerFaceColor', 'r','DisplayName', 'Design Speed (neg lim)');

% Mark the point where the gust line intersects V_D
plot(VD_EAS, n_gust_at_VD, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'Do Not Exceed Speed (pos lim)');
text(VD_EAS, n_gust_at_VD + 0.5, 'V_D', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VD_EAS, n_neg_gust_at_VD, 'go', 'MarkerFaceColor', 'g','DisplayName', 'Do Not Exceed Speed (neg lim)');

plot([VC_EAS VD_EAS], [n_gust_at_VC n_gust_at_VD], 'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');
plot([VC_EAS VD_EAS], [n_neg_gust_at_VC n_neg_gust_at_VD], 'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');

% Mark the point where the gust line intersects n_limit
text(VB_EAS, n_neg_gust_at_VB - 0.5, 'V_B', 'HorizontalAlignment', 'center', 'FontSize', 10);
plot(VB_EAS, n_neg_gust_at_VB, 'go', 'MarkerFaceColor', 'g','DisplayName', 'Do Not Exceed Speed (neg lim)');

plot ([VB_EAS VC_EAS], [n_pos_gust_at_VB n_gust_at_VC],  'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');
plot ([VB_EAS VC_EAS], [n_negative n_neg_gust_at_VC],  'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');

% Labels, grid, and legend
title('V-n Diagram');
xlabel('Equivalent Airspeed (EAS)');
ylabel('Load Factor (n)');
grid on;
legend('Location', 'NorthEast');
xlim([0 VD_EAS + 20]);
ylim([n_negative - 1, n_limit + 2]);
hold off;

end