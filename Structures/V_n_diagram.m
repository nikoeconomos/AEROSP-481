

W = ; % Maximum takeoff weight (kgs)
n_limit = 7; % Positive limit load factor
n_negative = -3; % Negative limit load factor
VD = ; % Dive speed (KEAS)
VC = ; % Cruise speed (KEAS)
V_MO = ; % Maximum operating speed (KEAS)
VA = sqrt(n_limit) * VS; % Maneuvering speed 
VB = ; % Gust penetration speed (KEAS)
VS = ; % Stall speed (KEAS)
CL_max = 1.5; % Maximum lift coefficient
rho = 0.002377; % Air density at sea level 
S = ; % Wing area (m^2)


WS = W / S; % Wing loading

% Positive and negative maneuver load factors
n_maneuver_positive = @(V) min(n_limit, (CL_max * rho * V^2 * S) / 2 * W);
n_maneuver_negative = @(V) max(n_negative, -(CL_max * rho * V^2 * S) / 2 * W);

% Gust load factors (simplified for 50 fps gust intensity)
ug = 50; % Gust intensity (fps)
n_gust = @(V, ug) (ug * q(V) * S) / (W * 32.2); % 32.2 is g (ft/s^2)
n_gust_pos = @(V) n_gust(V, ug);
n_gust_neg = @(V) -n_gust(V, ug);


