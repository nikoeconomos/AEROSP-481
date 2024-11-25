function[aircraft] = tr_calc(aircraft)
% Constants
g = 9.81; % Gravitational acceleration (m/s^2)
[~, ~, rho_tr, a_tr] = standard_atmosphere_calc(aircraft.performance.cruise_alt); 
C_Lmax = 0.8091; % Maximum lift coefficient
W = aircraft.weight.togw; % Aircraft weight (N)

% Inputs
M = 1.6; % Mach number at 35,000 ft

% True Airspeed
V_TAS = M * a_tr; % TAS in m/s

% Dynamic Pressure
q = 0.5 * rho_tr * V_TAS^2;

% Lift Force
L = q * C_Lmax;

% Load Factor
n_max = L / W;

% Maximum Turn Rate
turn_rate_max = (g * sqrt(n_max^2 - 1)) / V_TAS; % radians per second
turn_rate_max_deg = turn_rate_max * (180 / pi); % degrees per second

% Display Results
disp(['Maximum Instantaneous Turn Rate: ', num2str(turn_rate_max_deg), ' deg/s']);
