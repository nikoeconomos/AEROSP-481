function [DCA_mission] = generate_DCA_mission(r_air)
% Description: 
% Function parameteizes aircraft and environment states for Direct
% Counter-Air Patrol (DCA) mission and stores them in a struct following
% the sequence Mission.Mission_Segment.Parameter. Struct will be indexed
% into for fuel fraction calculations.
% 
% INPUTS:
% --------------------------------------------
%    r_air - Gas constant for air defined universally on main script.
%
% OUTPUTS:
% --------------------------------------------
%    ESCORT_mission - 3 layer struct.
%    Stores values for parameters relevant to the aircraft's state at each segment of the
%    mission.
% 
% See also: DCA_fuel_fraction_calc() for calculation of these parammeters
% using, loiter_fuel_fraction_calc(), cruise_fuel_fraction_calc()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024


% Engine start and takeoff segment
DCA_mission.start_takeoff.ff = 0.970; % [unitless]

% Climb segment
DCA_mission.climb.ff = 0.985; % [unitless]

% Cruise out segment
DCA_mission.cruise_out.range = 555600; % [m]
DCA_mission.cruise_out.altitude = 10668; % [m]
DCA_mission.cruise_out.mach = 0.95; % [unitless]
DCA_mission.cruise_out.t_amb = 219.05; % [k]
DCA_mission.cruise_out.rho = 0.37960; % [kg/m^3]
DCA_mission.cruise_out.tsfc = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.cruise_out.flight_velocity = velocity_from_flight_cond(DCA_mission.cruise_out.mach,DCA_mission.cruise_out.t_amb,DCA_mission.cruise_out.rho,r_air); % [m/s]

% Loiter segment
DCA_mission.loiter.endurance = 14400; % [s]
DCA_mission.loiter.altitude = 10668; % [m]
DCA_mission.loiter.mach = 0.95; % [unitless]
DCA_mission.loiter.t_amb = 219.05; % [k]
DCA_mission.loiter.rho = 0.37960; % [kg/m^3]
DCA_mission.loiter.tsfc = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.loiter.flight_velocity = velocity_from_flight_cond(DCA_mission.loiter.mach,DCA_mission.loiter.t_amb,DCA_mission.loiter.rho,r_air); % [m/s]

% Dash segment
DCA_mission.dash.range = 185200; % [m]
DCA_mission.dash.altitude = 10668; % [m]
DCA_mission.dash.mach = 1.8; % [unitless]
DCA_mission.dash.t_amb = 219.05; % [k]
DCA_mission.dash.rho = 0.37960; % [kg/m^3]
DCA_mission.dash.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.dash.flight_velocity = velocity_from_flight_cond(DCA_mission.dash.mach,DCA_mission.dash.t_amb,DCA_mission.dash.rho,r_air); % [m/s]

%Combat segment 1
DCA_mission.combat1.altitude = 10668; % [m]
DCA_mission.combat1.mach = 1.2; % [unitless]
DCA_mission.combat1.bank_ang = 89; % [degrees]
DCA_mission.combat1.t_amb = 219.05; % [k]
DCA_mission.combat1.rho = 0.37960; % [kg/m^3]
DCA_mission.combat1.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to kgm/s*kgf
DCA_mission.combat1.flight_velocity = velocity_from_flight_cond(DCA_mission.combat1.mach,DCA_mission.combat1.t_amb,DCA_mission.combat1.rho,r_air); % [m/s]
DCA_mission.combat1.range = basic_360_turn_distance(DCA_mission.combat1.flight_velocity,DCA_mission.combat1.bank_ang); % [m]

% Combat segment 2
DCA_mission.combat2.altitude = 10668; % [m]
DCA_mission.combat2.mach = 0.9; % [unitless]
DCA_mission.combat2.bank_ang = 89; % [degrees]
DCA_mission.combat2.t_amb = 219.05; % [k]
DCA_mission.combat2.rho = 0.37960; % [kg/m^3]
DCA_mission.combat2.tsfc = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.combat2.flight_velocity = velocity_from_flight_cond(DCA_mission.combat2.mach,DCA_mission.combat2.t_amb,DCA_mission.combat2.rho,r_air); % [m/s]
DCA_mission.combat2.range = basic_360_turn_distance(DCA_mission.combat2.flight_velocity,DCA_mission.combat2.bank_ang); % [m]

% Cruise in segment
DCA_mission.cruise_in.range = 740800; % [m]
DCA_mission.cruise_in.altitude = 10668; % [m]
DCA_mission.cruise_in.mach = 0.95; % [unitless]
DCA_mission.cruise_in.t_amb = 219.05; % [k]
DCA_mission.cruise_in.rho = 0.37960; % [kg/m^3]
DCA_mission.cruise_in.tsfc = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.cruise_in.flight_velocity = velocity_from_flight_cond(DCA_mission.cruise_in.mach,DCA_mission.cruise_in.t_amb,DCA_mission.cruise_in.rho,r_air); % [m/s]

% Descent segment
DCA_mission.descent.ff = 0.990; % [unitless]

% Reserve segment
DCA_mission.reserve.endurance = 1800; % [s]
DCA_mission.reserve.altitude = 0; % [m]
DCA_mission.reserve.mach = 0.16; % [unitless]
DCA_mission.reserve.t_amb = 288.15; % [k]
DCA_mission.reserve.rho = 1.225; % [kg/m^3]
DCA_mission.reserve.tsfc = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
DCA_mission.reserve.flight_velocity = velocity_from_flight_cond(DCA_mission.reserve.mach,DCA_mission.reserve.t_amb,DCA_mission.reserve.rho,r_air); % [m/s]

end