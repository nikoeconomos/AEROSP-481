function [aircraft] = generate_target_CL_values(aircraft)
%Description:
% Extracts necessary wing CL at takeoff and landing from takeoff speed and
% stall speed fro takeoff. Calculates takeoff speed  and time based on T-S space point and
% balanced takeoff field length.
%
% Extracts horzontal tail CL solving for necessary value to set trim attitutde point
% with AOA that gives takeoff lift
%
% INPUTS:
% --------------------------------------------
%    aircraft struct
%
% OUTPUTS:
% --------------------------------------------
%    aircraft struct updated with appropriate CL values
%
% 
% Author:                          Juan
% Version history revision notes:
%                                  v1: 11/15/2024
% Calculate stall speed in m/s 

%% Net Thrust

% Define rolling frictional resistance (using equation from NASA D-1376 technical note)
W_to = aircraft.weight.togw * 0.9985 * g; % Where togw coefficient is equal to idle fuel fraction
m_to = aircraft.weight.togw * 0.9985;
g = aircraft.geometry;
grav = 9.81;

% Place landing gear characteristics into landing gear sub-field within
% aircraft.geometry
g.lg.Pn_front = 315; % [PSI]
g.lg.Pn_rear = 320; % [PSI]

mu_front = 0.93 - 0.0011 * g.lg.Pn_front;
mu_rear = 0.93 - 0.0011 * g.lg.Pn_rear;

mu_tot = 2* mu_front + 2*mu_rear;

FF = mu_tot * W_to;

% Define takeoff thrust
T  = aircraft.propulsion.T_military; % aircraft must take off with military thrust

T_net = T - FF;

%% Takeoff Speed & Time

perf = aircraft.performance;

perf.to_acc = T_net / m_to

aircraft.mission.tofl = 2438.4; % [m]
tofl = aircraft.mission.tofl;

perf.to_speed = sqrt(2 * tofl * perf.to_acc) % [m/s]
perf.to_time = perf.to_speed / perf.to_acc % [s]

%% Wing CL

aircraft.aerodynamics.wing_CL_to = 2 * W_to / ...
    ( aircraft.environment.rho_SL_30C * aircraft.geometry.wing.S_wet * perf.to_speed^2 ); % Using density for hottest day at sea level, change to hot day at denver airport

end