% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_F35_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% sizing the aircraft
% 
% 
% INPUTS:
% --------------------------------------------
%    None
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - struct containing all parameters for the aircraft
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/13/2024
%                                  v1.1: 9/15/2024 - Added parameters based
%                                  on the F135 engine. (Joon)



aircraft.name = 'F-35';

%% WEIGHTS %%
%%---------%%

% Average weight of crew member and carry on luggage given by the metabook. No checked baggage included in this.
aircraft.weight.components.crew = 82; % [kg] 1 member

% Weight of the payload
aircraft.weight.components.payload = 8164.6627; %[kg]

% MTOW
aircraft.weight.mtow_actual = 29899.902; %[kg]

% Guess for our estimation purposes, same as actual
aircraft.weight.guess = 22470.966; % [kg]

% TOGW
aircraft.weight.togw_actual = 22470.966; % [kg]

% Empty weight
aircraft.weight.empty_actual = 13290.256; % [kg]

% Fuel weight
aircraft.weight.fuel_actual = 8278.0608; % [kg]

aircraft.weight.ff = aircraft.weight.fuel_actual/aircraft.weight.togw_actual;


%% PERFORMANCE %%
%%-------------%%

% range
aircraft.performance.range = 2778000; %[m]

% range in combat
aircraft.performance.range_combat = 1296000; %[m]

% max mach number at altitude
aircraft.performance.mach.max_alt = 1.6; %[Mach number]

% max mach number at sea level
aircraft.performance.mach.max_SL = 1.06; %[Mach number]

% Cruise mach
aircraft.performance.mach.cruise = 0.86; % mach number taken from an average in our historical dataset
aircraft.performance.mach.endurance = 0.85; % mach number taken from an average in our historical dataset
aircraft.performance.mach.dash = 1.6; % from online

% g force limit
aircraft.performance.g_force_upper_limit = 9; % [g's]

%% GEOMETRY %%
%%----------%%

% wing reference area
aircraft.geometry.wing.S_ref = 42.7354; %[m^2]
aircraft.geometry.wing.b = 10.668; % [m]
aircraft.geometry.wing.AR = 2.66;

%% AERODYNAMICS %%
%%--------------%%

aircraft.aerodynamics.CL.takeoff_flaps = 1.82;
aircraft.aerodynamics.CL.landing_flaps = 0.81;

aircraft.aerodynamics.LD.max = 10; % next to eq 2.15 in metabook
aircraft.aerodynamics.LD.dash = 0.93 * aircraft.aerodynamics.LD.max_cruise; 


%% PROPULSION %%
%%------------%%

% max thrust
aircraft.propulsion.T_max = 191273.53; %[N]

% military thrust
aircraft.propulsion.T_military = 124550.2; %[N]

%% DESIGN POINTS %%

aircraft.performance.WS_design = (aircraft.weight.mtow_actual)/(aircraft.geometry.wing.S_ref);
aircraft.performance.TW_design = aircraft.propulsion.T_max/(aircraft.weight.mtow_actual*9.81);
aircraft.performance.TW_design_military = aircraft.propulsion.T_military/(aircraft.weight.mtow_actual*9.81);


end