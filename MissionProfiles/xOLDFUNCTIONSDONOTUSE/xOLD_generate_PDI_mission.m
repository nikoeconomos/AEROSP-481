function [PDI_mission] = generate_PDI_mission(r_air)
% Description:
% Function parameteizes aircraft and environment states for Point Defense Intercept 
% (PDI) mission and stores them in a struct following the sequence 
% Mission.Mission_Segment.Parameter. Struct will be indexed into for fuel fraction calculations.
%
% INPUTS:
% --------------------------------------------
% r_air - Gas constant for air defined universally on main script.
%
% OUTPUTS:
% --------------------------------------------
%    PDI_mission - 3 layer struct.
%    Stores values for parameters relevant to the aircraft's state at each segment of the
%    mission.
%
% See also: PDI_fuel_fraction_calc() for calculation of these parammeters
% using, loiter_fuel_fraction_calc(), cruise_fuel_fraction_calc()
% Author:                                           Shay
% Version history revision notes:
%                                           v1: 9/11/2024


% Engine start and takeoff segment
PDI_mission.start_takeoff.ff = 0.970; % [unitless]
PDI_mission.start_takeoff.time = .1; % averaged this from data online (~6 min)

% Climb segment (from SL to 35,000 ft)
PDI_mission.climb.ff = 0.985; % [unitless]
PDI_mission.climb.time = 1/60; % [hours] - overestimate from data online (~1 min)


% Dash segment
PDI_mission.dash.range = 370400; % [m]
PDI_mission.dash.altitude = 10668; % [m]
PDI_mission.dash.mach = 1.8; % [unitless]
PDI_mission.dash.t_amb = 219.05; % [k]
PDI_mission.dash.rho = 0.37960; % [kg/m^3]
PDI_mission.dash.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.dash.flight_velocity = velocity_from_flight_cond(PDI_mission.dash.mach,PDI_mission.dash.t_amb,PDI_mission.dash.rho,r_air); % [m/s]
PDI_mission.dash.time = (PDI_mission.dash.range / (PDI_mission.dash.mach*343)) / 3600; % time [s] = distance [m] / speed [m/s] - then convert to hours


% combat segment 1 - 360 turn at mach 1.2
PDI_mission.combat1.altitude = 10668; % [m]
PDI_mission.combat1.mach = 1.2; % [unitless]
PDI_mission.combat1.t_amb = 219.05; % [k]
PDI_mission.combat1.rho = 0.37960; % [kg/m^3]
PDI_mission.combat1.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.combat1.flight_velocity = velocity_from_flight_cond(PDI_mission.combat1.mach,PDI_mission.combat1.t_amb,PDI_mission.combat1.rho,r_air); % [m/s]
PDI_mission.combat1.range = basic_360_turn_distance(PDI_mission.combat1.flight_velocity, 89); % [m] want to double chk this!!
PDI_mission.combat1.time = (PDI_mission.combat1.range / (PDI_mission.combat1.mach*343)) / 3600; % time [s] = distance [m] / speed [m/s] - then convert to hours

% combat segment 2 - 360 turn at mach .9
PDI_mission.combat2.altitude = 10668; % [m]
PDI_mission.combat2.mach = 0.9; % [unitless]
PDI_mission.combat2.t_amb = 219.05; % [k]
PDI_mission.combat2.rho = 0.37960; % [kg/m^3]
PDI_mission.combat2.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.combat2.flight_velocity = velocity_from_flight_cond(PDI_mission.combat2.mach,PDI_mission.combat2.t_amb,PDI_mission.combat2.rho,r_air); % [m/s]
PDI_mission.combat2.range = basic_360_turn_distance(PDI_mission.combat2.flight_velocity, 89); % [m] want to double chk this!!
PDI_mission.combat2.time = (PDI_mission.combat2.range / (PDI_mission.combat2.mach*343)) / 3600; % time [s] = distance [m] / speed [m/s] - then convert to hours
% at the end of this segment we release all missles
PDI_mission.combat2.time = PDI_mission.combat2.time + .01;% adding buffer time to release all missles (approx 36 seconds)

% climb / accelerate to optimal speed / altitude
% for now, assuming that this will be 35,000 ft/ 10668 meters

% Cruise back (in) segment for 200nm at optimal speed and altitude
% for now, assuming that this will be 35,000 ft/ 10668 meters and mach .95
PDI_mission.cruise_in.range = 370400; % [m]
PDI_mission.cruise_in.altitude = 10668; % [m]
PDI_mission.cruise_in.mach = 0.95; % [unitless]
PDI_mission.cruise_in.t_amb = 219.05; % [k]
PDI_mission.cruise_in.rho = 0.37960; % [kg/m^3]
PDI_mission.cruise_in.tsfc = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.cruise_in.flight_velocity = velocity_from_flight_cond(PDI_mission.cruise_in.mach,PDI_mission.cruise_in.t_amb,PDI_mission.cruise_in.rho,r_air); % [m/s]
PDI_mission.cruise_in.time = (PDI_mission.cruise_in.range / (PDI_mission.cruise_in.mach*343)) / 3600; % time [s] = distance [m] / speed [m/s] - then convert to hours

% Descent segment (no fuel used)
PDI_mission.descent.ff = 0.990; % [unitless]
PDI_mission.descent.time = 4 / 60; % averaged historical data for decent time [hours]

% Reserve segment
PDI_mission.reserve.endurance = 1800; % [s]
PDI_mission.reserve.altitude = 0; % [m]
PDI_mission.reserve.mach = 0.16; % [unitless]
PDI_mission.reserve.t_amb = 288.15; % [k]
PDI_mission.reserve.rho = 1.225; % [kg/m^3]
PDI_mission.reserve.tsfc = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.reserve.flight_velocity = velocity_from_flight_cond(PDI_mission.reserve.mach,PDI_mission.reserve.t_amb,PDI_mission.reserve.rho,r_air); % [m/s]

end