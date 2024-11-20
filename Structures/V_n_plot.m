function [aircraft] = V_n_plot(aircraft)

[~, ~, rho_SL, ~] = standard_atmosphere_calc(0); % Sea-level conditions
TAS_to_EAS = @(V_tas, rho) V_tas * sqrt(rho / rho_SL); % TAS to EAS conversion


W = aircraft.weight.togw; % Takeoff weight (kg)
S = aircraft.geometry.wing.S_ref; % Wing area (m^2)
W_S = aircraft.performance.WS_design; % Wing loading (N/m^2)
CL_max = 0.8091; % Maximum lift coefficient
c = 3.044; % Mean aerodynamic chord (m)
C_L_alpha = 1.2; % Lift curve slope
g = 9.8; % Gravitational acceleration (m/s^2)


n_limit = aircraft.performance.load_factor.upper_limit; % Positive limit load factor
n_negative = aircraft.performance.load_factor.lower_limit; % Negative limit load factor
U_e_VC = 20.1168; % Gust velocity at VC (20,000 ft in m/s)
U_e_VD = 7.62; % Gust velocity at VD (20,000 ft in m/s)


[~, ~, rho_VC, a_VC] = standard_atmosphere_calc(aircraft.performance.cruise_alt); 
[~, ~, rho_VMO, a_VMO] = standard_atmosphere_calc(aircraft.performance.max_alt); 

% Cruise conditions
VC_TAS = aircraft.performance.mach.cruise * a_VC; % Cruise TAS 
VC_EAS = TAS_to_EAS(VC_TAS, rho_VC); % Cruise EAS 

% Maximum operating speed (VMO)
VMO_TAS = aircraft.performance.mach.max_alt * a_VMO; % VMO TAS
VMO_EAS = TAS_to_EAS(VMO_TAS, rho_VMO); % VMO EAS 

% Dive speed (VD)
VD_EAS = 1.25 * VMO_EAS; % Dive speed EAS 

% Stall speed (VS)
VS_EAS = sqrt((2 * W) / (rho_SL * S * CL_max)); % Stall speed in EAS 

% Maneuvering speed (VA)
VA_EAS = sqrt(n_limit) * VS_EAS; % Maneuvering speed in EAS 

% Air density at 20,000 ft for gust lines
[~, ~, rho_20k, ~] = standard_atmosphere_calc(6096); % Altitude of 20,000 ft (6096 m)

% mu for gust 
mu = (2 * W_S) / (rho_20k * c * C_L_alpha * g);

% gust K_g value
K_g = (0.88 * mu) / (5.3 + mu);

% Gust penetration speed (VB)
VB_EAS = (498 * W_S / (K_g * C_L_alpha * U_e_VC)) * (n_limit - 1); % Gust penetration speed in EAS

% Velocity Range
V = linspace(0, VD_EAS, 500); % EAS range

% Gust load factors
n_gust_pos_VC =  1 + (K_g * C_L_alpha * U_e_VC .* V) / (498 * W_S);
n_gust_neg_VC = @(V) 1 - (K_g * C_L_alpha * U_e_VC .* V) / (498 * W_S);

n_gust_VD = @(V) 1 + (K_g * C_L_alpha * U_e_VD .* V) / (498 * W_S);
n_gust_neg_VD = @(V) 1 - (K_g * C_L_alpha * U_e_VD .* V) / (498 * W_S);


% Positive and negative maneuver load factors
n_maneuver_positive = @(V) min(n_limit, (rho_SL * V.^2 * CL_max) / (2 * W_S));
n_maneuver_negative = @(V) max(n_negative, -(rho_SL * V.^2 * CL_max) / (2 * W_S));


% Plot the V-n diagram
figure;
hold on;

% Maneuver envelope
plot(V, n_maneuver_positive(V), 'b-', 'LineWidth', 2, 'DisplayName', 'Positive Maneuver Envelope');
plot(V, n_maneuver_negative(V), 'b-', 'LineWidth', 2, 'HandleVisibility', 'off');

% Gust lines at VC
plot(V, n_gust_pos_VC(V), 'g--', 'LineWidth', 1.5, 'DisplayName', 'VC Gust Line (Positive)');
plot(V, n_gust_neg_VC(V), 'g--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Gust lines at VD
plot(V, n_gust_VD(V), 'r--', 'LineWidth', 1.5, 'DisplayName', 'VD Gust Line (Positive)');
plot(V, n_gust_neg_VD(V), 'r--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Highlight critical speeds
plot(VA_EAS, n_limit, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Maneuver Speed (VA)');
plot(VC_EAS, n_limit, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Cruise Speed (VC)');
plot(VD_EAS, n_limit, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'Dive Speed (VD)');
plot(VS_EAS, 1, 'mo', 'MarkerFaceColor', 'm', 'DisplayName', 'Stall Speed (VS)');
plot(VB_EAS, n_limit, 'co', 'MarkerFaceColor', 'c', 'DisplayName', 'Gust Penetration Speed (VB)');

% Annotate critical speeds
text(VS_EAS, 1.1, 'V_S', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VA_EAS, n_limit + 0.2, 'V_A', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VC_EAS, n_limit + 0.2, 'V_C', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VD_EAS, n_limit + 0.2, 'V_D', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(VB_EAS, n_limit + 0.2, 'V_B', 'HorizontalAlignment', 'center', 'FontSize', 10);

% Add labels, grid, and legend
title('V-n Diagram');
xlabel('Equivalent Airspeed (EAS, m/s)');
ylabel('Load Factor (n)');
grid on;
legend('Location', 'NorthEast');
xlim([0 VD_EAS + 50]);
ylim([n_negative - 1, n_limit + 1]);
hold off;

end