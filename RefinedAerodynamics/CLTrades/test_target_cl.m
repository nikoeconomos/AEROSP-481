clear
close all
clc

%% Constants

rho_min = aircraft.environment.rho_4000ft_30C; % Density caluclated for hot 40 C day at denver aiport altitude of 1656 m
S_ref = 24.5; % [m^2]
togw = 1.700844196235701e+04;
T_mil = 76300;
tofl = 2438.4; % [m]
g = 9.81;

% Landing gear tire pressures:
Pn_front = 315; % [PSI]
Pn_rear = 320; % [PSI]

%% Net Thrust

% Define rolling frictional resistance (using equation from NASA D-1376 technical note)
W_to = togw * g * 0.9985; % Where togw coefficient is equal to idle fuel fraction
m_to = togw * 0.9985;

mu_front = 0.93 - 0.0011 * Pn_front;
mu_rear = 0.93 - 0.0011 * Pn_rear;

mu_tot = 2* mu_front + 2*mu_rear;

FF = 0.03 * W_to;

% Define takeoff thrust
T  = T_mil; % aircraft must take off with military thrust

T_net = T - FF;

%% Takeoff Speed & Time

to_acc = T_net / m_to

to_speed = sqrt(2 * tofl * to_acc) % [m/s]
to_time = to_speed / to_acc % [s]

%% Wing CL

wing_CL_to = 2 * W_to / ( rho_min * S_ref * to_speed^2 ) % Using density for hottest day at sea level, change to hot day at denver airport
