function [PDI_mission] = generate_PDI_mission(r_air)

% **Commenting TBD**

% Description:
%
% INPUTS:
% --------------------------------------------
% r_air -
%
% OUTPUTS:
% --------------------------------------------
% PDI_mission -
%
% See also:
% Author: shay
% Version history revision notes:
% v1: 9/11/2024


% Engine start and takeoff segment
PDI_mission.start_takeoff.ff = 0.970; % [unitless]

% Climb segment (from SL to 35,000 ft)
PDI_mission.climb.ff = 0.985; % [unitless]

% Dash segment
PDI_mission.dash.range = 370400; % [m]
PDI_mission.dash.altitude = 10668; % [m]
PDI_mission.dash.mach = 1.8; % [unitless]
PDI_mission.dash.t_amb = 219.05; % [k]
PDI_mission.dash.rho = 0.37960; % [kg/m^3]
PDI_mission.dash.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.dash.flight_velocity = velocity_from_flight_cond(PDI_mission.dash.mach,PDI_mission.dash.t_amb,r_air); % [m/s]

% combat segment 1 - 360 turn at mach 1.2
PDI_mission.combat1.altitude = 10668; % [m]
PDI_mission.combat1.mach = 1.2; % [unitless]
PDI_mission.combat1.t_amb = 219.05; % [k]
PDI_mission.combat1.rho = 0.37960; % [kg/m^3]
PDI_mission.combat1.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.combat1.flight_velocity = velocity_from_flight_cond(PDI_mission.combat1.mach,PDI_mission.combat1.t_amb,r_air); % [m/s]
PDI_mission.combat1.range = basic_360_turn_distance(PDI_mission.combat1.flight_velocity); % [m] want to double chk this!!

% combat segment 2 - 360 turn at mach .9
PDI_mission.combat2.altitude = 10668; % [m]
PDI_mission.combat2.mach = 0.9; % [unitless]
PDI_mission.combat2.t_amb = 219.05; % [k]
PDI_mission.combat2.rho = 0.37960; % [kg/m^3]
PDI_mission.combat2.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.combat2.flight_velocity = velocity_from_flight_cond(PDI_mission.combat2.mach,PDI_mission.combat2.t_amb,r_air); % [m/s]
PDI_mission.combat2.range = basic_360_turn_distance(PDI_mission.combat2.flight_velocity); % [m] want to double chk this!!
% at the end of this segment we release all missles

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
PDI_mission.cruise_in.flight_velocity = velocity_from_flight_cond(PDI_mission.cruise_in.mach,PDI_mission.cruise_in.t_amb,r_air); % [m/s]

% Descent segment (no fuel used)
PDI_mission.descent.ff = 0.990; % [unitless]

% Reserve segment
PDI_mission.reserve.endurance = 1800; % [s]
PDI_mission.reserve.altitude = 0; % [m]
PDI_mission.reserve.mach = 0.16; % [unitless]
PDI_mission.reserve.t_amb = 288.15; % [k]
PDI_mission.reserve.rho = 1.225; % [kg/m^3]
PDI_mission.reserve.tsfc = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
PDI_mission.reserve.flight_velocity = velocity_from_flight_cond(DCA_mission.reserve.mach,DCA_mission.reserve.t_amb,r_air); % [m/s]

end