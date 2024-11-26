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

%% Constants
Sref = aircraft.geometry.wing.S_ref;
rho_hot_day = 0.93;
V_stall = 93.6; % from Joon
togw = aircraft.weight.togw;
W_L = aircraft.weight.max_landing_weight; % calculatede in generate component weights
perf = aircraft.performance;
g = 9.81;
geometry = aircraft.geometry;
ad = aircraft.aerodynamics;
m_to = togw * 0.9985; % Where togw coefficient is equal to idle fuel fraction TODO parametrize
W_to = m_to * g;
Swet = geometry.S_wet_regression_calc(m_to);
%% Landing CL

aircraft.aerodynamics.CL.landing_flaps = 2 * W_L * g / (rho_hot_day * V_stall^2 * Sref)

%% Net Thrust

% Define rolling frictional resistance (using equation from NASA D-1376 technical note)
% % Place landing gear characteristics into landing gear sub-field within
% % aircraft.geometry
% geometry.lg.Pn_front = 315; % [PSI]
% geometry.lg.Pn_rear = 320; % [PSI]
% 
% mu_front = 0.93 - 0.0011 * geometry.lg.Pn_front;
% mu_rear = 0.93 - 0.0011 * geometry.lg.Pn_rear;

mu_rolling = 0.03; % from Joon

mu_tot = 4 * mu_rolling;

FF = mu_tot * W_to;

% Define takeoff thrust
T  = aircraft.propulsion.T_military; % aircraft must take off with military thrust

Tnet1 = T - FF;

%% Takeoff Speed & Time

tspan = linspace(0,90,300);

a = zeros(1,length(tspan)); % acceleration [m/s^2]
v = zeros(1,length(tspan)); % speed [m/s]
s = zeros(1,length(tspan)); % runway distance [m]

aircraft.mission.tofl = 2438.4; % [m]
tofl = floor(aircraft.mission.tofl);

a(1) = Tnet1/togw;
s(1) = 0.5 * a(1) * tspan(1)^2;

for i = 2:length(tspan)
    
    del_t = tspan(i)-tspan(i-1);
    
    v(i) = v(i-1) + a(i-1) * del_t;
    
    D = 0.5 * rho_hot_day * Swet * ad.CD.takeoff_flaps_gear * v(i)^2;
    
    Tnet = Tnet1 - D;
    
    a(i) = Tnet / togw;
    
    s(i) = s(i-1) + v(i) * del_t - 0.5 * a(i) * del_t^2;

    if s(i) >= tofl
        break
    end

end

perf.to_speed = v(i) % [m/s]
perf.to_time  = tspan(i) % [s]

%% Calculate Wing CL

aircraft.aerodynamics.CL.takeoff_flaps = 2 * 12000 * g / (rho_hot_day * Sref * 70^2);

aircraft.performance = perf;

%% Plot Results to Verify

figure()
plot(s,v);
xlabel("Distance (m)")
ylabel("Velocity (m/s)")
title("Velocity Over Runway")

figure()
plot(s,a);
xlabel("Distance (m)")
ylabel("Acceleration (m/s^2)")
title("Acceleration Over Runway")

figure()
plot(tspan,s);
xlabel("Time (s)")
ylabel("Distance (m)")
title("Runway Traveled Over Time")
end