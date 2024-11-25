function [aircraft] = dynamic_pressure_calc(aircraft)
% Constants

M = aircraft.performance.mach.max_sustained_turn; % Mach number
[~, ~, rho_SL, a_SL] = standard_atmosphere_calc(0); % Sea-level conditions
% Calculate True Airspeed (TAS)
V_TAS = M * a_SL; % TAS in m/s

% Dynamic Pressure (q)
q = 0.5 * rho_SL * V_TAS^2; % Dynamic pressure in Pascals
q_psf = q / 47.88; % Convert to psf

% Check against the limit
limit_q_psf = 2133; % psf
if q_psf <= limit_q_psf
    disp('Dynamic pressure requirement met.');
else
    disp('Dynamic pressure exceeds limit!');
end
disp(['Dynamic Pressure: ', num2str(q_psf), ' psf']);
