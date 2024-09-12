function [ESCORT_mission] = generate_ESCORT_mission(r_air)
% Description: 
% 
% This function is to calculate the different parameters 
% (TSFC, range, flight velocity) needed for the ESCORT_mission 
% fuel fraction calculation (in ESCORT_fuel_fraction_calc.m). Each paramter
% is calculated according to the mission segment (takeoff, climb, dash,
% escort, cruise, decent, reserve) that correspond with the ESCORT mission
% description in the RFP.
%
% INPUTS:
% --------------------------------------------
%    r_air - the universal gas constant for air
%
% OUTPUTS:
% --------------------------------------------
%    ESCORT_mission - will update ESCORT_mission struct to store values
%    for parameters relevant to the aircraft's state at each segment of the
%    mission.
% 
% See also: ESCORT_fuel_fraction_calc.m for details in how the fuel
% fraction is calculated
%
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/11/2024
% Engine start and takeoff segment
ESCORT_mission.start_takeoff.ff = 0.970; % [unitless]
% Climb segment - 35,000 ft
ESCORT_mission.climb.ff = 0.985; % [unitless]
% Dash segment
ESCORT_mission.dash.range = 370400; % [m] Assumed 200 nm dash distsnce to match other intercept mission (PDI)
ESCORT_mission.dash.altitude = 10668; % [m]
ESCORT_mission.dash.mach = 1.8; % [unitless]
ESCORT_mission.dash.t_amb = 219.05; % [k]
ESCORT_mission.dash.rho = 0.37960; % [kg/m^3]
ESCORT_mission.dash.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
ESCORT_mission.dash.flight_velocity = velocity_from_flight_cond(ESCORT_mission.dash.mach,ESCORT_mission.dash.t_amb,r_air); % [m/s]
% Escort segment
ESCORT_mission.escort.range = 555600; % [m]
ESCORT_mission.escort.altitude = 10668; % [m]
ESCORT_mission.escort.mach = 0.7; % [unitless] Assumed from lowest F14 speed found in assignment 1
ESCORT_mission.escort.t_amb = 219.05; % [k]
ESCORT_mission.escort.rho = 0.37960; % [kg/m^3]
ESCORT_mission.escort.tsfc = 0.8 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
ESCORT_mission.escort.flight_velocity = velocity_from_flight_cond(ESCORT_mission.escort.mach,ESCORT_mission.escort.t_amb,r_air); % [m/s]
% "climb/accelerate to optimal speed and altitude" - assuming this remains
% 35,000ft (until we can better assess the optimal altitude for out craft)
% Cruise in segment
ESCORT_mission.cruise_in.range = 926000; % [m] Assume 500 nm cruise back distance due to assumed 200 nm dash and 300 nm escort
ESCORT_mission.cruise_in.altitude = 10668; % [m]
ESCORT_mission.cruise_in.mach = 0.95; % [unitless]
ESCORT_mission.cruise_in.t_amb = 219.05; % [k]
ESCORT_mission.cruise_in.rho = 0.37960; % [kg/m^3]
ESCORT_mission.cruise_in.tsfc = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
ESCORT_mission.cruise_in.flight_velocity = velocity_from_flight_cond(ESCORT_mission.cruise_in.mach,ESCORT_mission.cruise_in.t_amb,r_air); % [m/s]
% Descent segment
ESCORT_mission.descent.ff = 0.990; % [unitless]
% Reserve segment
ESCORT_mission.reserve.endurance = 1800; % [s]
ESCORT_mission.reserve.altitude = 0; % [m]
ESCORT_mission.reserve.mach = 0.16; % [unitless]
ESCORT_mission.reserve.t_amb = 288.15; % [k]
ESCORT_mission.reserve.rho = 1.225; % [kg/m^3]
ESCORT_mission.reserve.tsfc = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
ESCORT_mission.reserve.flight_velocity = velocity_from_flight_cond(ESCORT_mission.reserve.mach,ESCORT_mission.reserve.t_amb,r_air); % [m/s]
end