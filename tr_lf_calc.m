function[aircraft] = tr_lf_calc(aircraft)


% Constants
g = 9.81; % Gravitational acceleration (m/s^2)
[~, ~, rho_SL, a_SL] = standard_atmosphere_calc(0); % Sea-level conditions
[~, ~, rho_15k, a_15k] = standard_atmosphere_calc(4572); % conditions at 15,000 ft (4572 m)

W = aircraft.weight.togw * g; % Aircraft weight (N) (example)
C_Lmax = 0.8091; % Maximum lift coefficient

% Inputs
M = 0.9; % Mach number
turn_rate = 60.96; % Desired turn rate (m/s)

% Convert turn rate to radians per second
turn_rate_rads = turn_rate / 3.281;

% Calculate True Airspeed (TAS)
V_TAS = M * a_SL; % TAS in m/s

% Required Load Factor (n)
n = (turn_rate_rads * V_TAS) / g;

% Check sustained load factor
q = 0.5 * rho_SL * V_TAS^2; % Dynamic pressure at sea level
L = q * C_Lmax; % Lift force
n_sustained = L / W; % Sustained load factor

% Display Results
disp(['Turn Rate: ', num2str(turn_rate), ' ft/s']);
disp(['Load Factor (n): ', num2str(n)]);
disp(['Sustained Load Factor: ', num2str(n_sustained)]);
