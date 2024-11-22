function [aircraft] = V_n_plot(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the geometry of the aircraft.
% (Will edit later)^^
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with geometry
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024


[~, ~, rho_SL, ~] = standard_atmosphere_calc(0); % Sea-level conditions

TAS_to_EAS = @(V_tas, rho) V_tas * sqrt(rho / rho_SL); % TAS to EAS conversion

W_S = aircraft.performance.WS_design; % Wing loading (N/m^2)
CL_max = 0.8091; % might change 
C_L_alpha = 3.0562; % para,eter on different branch 
g = 9.81; % (m/s^2)
c = 3.044; % Mean chord (m) took from old CAD

n_limit = aircraft.performance.load_factor.upper_limit; % Positive limit load factor
n_negative = aircraft.performance.load_factor.lower_limit; % Negative limit load factor
U_e_VB = 20.1168; % Gust velocity at VB (66 ft/s in m/s)
U_e_VC = 15.24; % Gust velocity at VC (50 ft/s in m/s)
U_e_VD = 7.62; % Gust velocity at VD (25 ft/s in m/s)

[~, ~, rho_VC, a_VC] = standard_atmosphere_calc(aircraft.performance.cruise_alt); 
[~, ~, rho_VMO, a_VMO] = standard_atmosphere_calc(aircraft.performance.cruise_alt); 

% Cruise conditions
VC_TAS = aircraft.performance.mach.cruise * a_VC; % Cruise TAS 
VC_EAS = TAS_to_EAS(VC_TAS, rho_VC); % Cruise EAS 
VC_EAS = VC_EAS/0.514444;
disp(VC_EAS)

% Maximum operating speed (VMO)
VMO_TAS = aircraft.performance.mach.max_alt * a_VMO; % VMO TAS
VMO_EAS = TAS_to_EAS(VMO_TAS, rho_VMO); % VMO EAS 
disp(VMO_EAS)

% Dive speed (VD)
VD_EAS = 1.25 * VMO_EAS; % Dive speed EAS 
disp(VD_EAS)

% Stall speed (VS)
VS_EAS = sqrt((2 * W_S) / (rho_SL * CL_max)); % Stall speed in EAS 
disp(VS_EAS)

% Maneuvering speed (VA)
VA_EAS = sqrt(n_limit) * VS_EAS; % Maneuvering speed in EAS 
disp(VA_EAS)

% Air density at 20,000 ft for gust lines
[~, ~, rho_20k, ~] = standard_atmosphere_calc(6096); % Altitude of 20,000 ft (6096 m)

% mu for gust 
mu = (2 * W_S) / (rho_20k * c * C_L_alpha * g);
disp(mu)

% Gust alleviation factor (K_g)
K_g = (0.88 * mu) / (5.3 + mu);

% Gust penetration speed (VB)
VB_EAS = sqrt((2 * W_S * (n_limit - 1)) / (rho_SL * CL_max));
disp(VB_EAS)

% Velocity Range
V = linspace(0, VD_EAS, 700); % EAS range

% Positive and negative maneuver load factors
n_maneuver_positive = min(n_limit, (rho_SL * V.^2 * CL_max) / (2 * W_S));
n_maneuver_negative = max(n_negative, -(rho_SL * V.^2 * CL_max) / (2 * W_S));

% Gust load factors
n_gust_pos_VC = 1 + ((K_g * C_L_alpha * U_e_VC * V) / (2 * W_S));
n_gust_neg_VC = 1 - ((K_g * C_L_alpha * U_e_VC * V) / (2 * W_S));

n_gust_pos_VD = 1 + ((K_g * C_L_alpha * U_e_VD * V) / (2 * W_S));
n_gust_neg_VD = 1 - ((K_g * C_L_alpha * U_e_VD * V) / (2 * W_S));

n_gust_pos_VB = 1 + ((K_g * C_L_alpha * U_e_VB * V) / (2 * W_S));
n_gust_neg_VB = 1 - ((K_g * C_L_alpha * U_e_VB * V) / (2 * W_S));

% Calculate the n-value of the 50 ft/s gust line at V_C
n_gust_at_VC = 1 + ((K_g * C_L_alpha * U_e_VC * (VC_EAS)) / (2 * W_S));

% Combined envelope (intersection of gust and maneuver lines)
n_combined_pos = min(n_gust_at_VC, n_gust_pos_VC);
n_combined_neg = max(n_maneuver_negative, n_gust_neg_VC);
n_manuever_pos_at_VS = (rho_SL * VS_EAS.^2 * CL_max) / (2 * W_S);
n_manuever_neg_at_VS = -(rho_SL * VS_EAS.^2 * CL_max) / (2 * W_S);

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
plot(V, n_gust_pos_VB, 'r-.', 'LineWidth', 1.5, 'DisplayName', 'VB Gust Line');
plot(V, n_gust_neg_VB, 'r-.', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Combined envelope
plot(V, n_combined_pos, 'k-', 'LineWidth', 2, 'DisplayName', 'Limit Combined Envelope');
plot(V, n_combined_neg, 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
plot([VS_EAS VS_EAS], [n_manuever_pos_at_VS n_manuever_neg_at_VS], 'm-', 'LineWidth', 2, 'DisplayName', 'Stall Speed');


% Vertical line at stall speed (VS)
%xline(VS_EAS, '--m', 'V_S', 'LabelHorizontalAlignment', 'center','LabelVerticalAlignment', 'bottom', 'LineWidth', 1.5, 'DisplayName', 'Stall Speed');

% Critical speeds
plot(VA_EAS, n_limit, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Corner Speed');
plot(VD_EAS, n_limit, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'Do Not Exceed Speed')
plot(VS_EAS, 1, 'mo', 'MarkerFaceColor', 'm', 'DisplayName', 'Stall Speed (VS)');

% Annotations
text(VA_EAS, n_limit + 0.5, 'V_A', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VD_EAS, n_limit + 0.5, 'V_D', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VS_EAS, 1.1, 'V_S', 'HorizontalAlignment', 'center', 'FontSize', 10);

% Mark the point where the gust line intersects V_C
plot(VC_EAS, n_gust_at_VC, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Gust Line at V_C');
text(VC_EAS, n_gust_at_VC + 0.5, 'V_C', 'HorizontalAlignment', 'center', 'FontSize', 10);

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