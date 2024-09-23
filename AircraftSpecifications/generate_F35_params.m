% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_F35_params()
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



%% WEIGHTS %%
%%---------%%

% Average weight of crew member and carry on luggage given by the metabook. No checked baggage included in this.
aircraft.weight.crew_member = 82; % [kg]

% Number of crew members to include onboard [TODO update if remote piloting]
aircraft.weight.num_crew_members = 1; % [number]

% Total weight of crew members. Crew weight * num of crew members aboard
aircraft.weight.crew = aircraft.weight.num_crew_members*aircraft.weight.crew_member; % [kg]

% Weight of the payload
aircraft.weight.payload = 8164.6627; %[kg]

% MTOW
aircraft.weight.mtow = 29899.902; %[kg]

% Guess for our estimation purposes, same as actual
aircraft.weight.guess = 22470.966; % [kg]

% TOGW
aircraft.weight.togw = 22470.966; % [kg]

% Empty weight
aircraft.weight.empty = 13290.256; % [kg]

% Fuel weight
aircraft.weight.fuel = 8278.0608; % [kg]


%% PERFORMANCE %%
%%-------------%%

% range
aircraft.performance.range = 2778000; %[m]

% range in combat
aircraft.performance.range_combat = 1296000; %[m]

% max mach number at altitude
aircraft.performance.mach_max_alt = 1.6; %[Mach number]

% max mach number at sea level
aircraft.performance.mach_max_SL = 1.06; %[Mach number]

% g force limit
aircraft.performance.g_force_limit = 9; % [g's]

%% GEOMETRY %%
%%----------%%

% Aspect ratio
aircraft.geometry.AR = 2.66; %[Unitless]

% wing reference area
aircraft.geometry.S_ref = 42.7354; %[m^2]

% wingspan
aircraft.geometry.b = 10.668; % [m]
%% AERODYNAMICS %%
%%--------------%%

% maximum L/D
aircraft.aerodynamics.LD_max = 10; %[Unitless]

% CL max at takeoff
aircraft.aerodynamics.CL_max_takeoff = 1.82; %[Unitless]

% CL max at landing
aircraft.aerodynamics.CL_max_landing = 0.81; %[Unitless]

%Stall Speed 
aircraft.aerodynamics.W_S = wing_loading_calc((aircraft.weight.mtow),(aircraft.geometry.S_ref));
aircraft.aerodynamics.rho = 1.225; %[kg.m^3]

aircraft.aerodynamics.V_stall = stall_speed_calc(aircraft.aerodynamics.W_S,aircraft.aerodynamics.rho,aircraft.aerodynamics.CL_max_takeoff);



%% PROPULSION %%
%%------------%%

% number of engines
aircraft.propulsion.engine_count = 1;

% engine cost
aircraft.propulsion.engine_cost = aircraft.propulsion.engine_count*15000000; %[$]

% max thrust
aircraft.propulsion.T_max = aircraft.propulsion.engine_count*191273.53; %[N]

% military thrust
aircraft.propulsion.T_military = aircraft.propulsion.engine_count*124550.2; %[N]

%% Drag Polar and Parasite Drag Coefficent 

aircraft.aerodynamics.Cf_clean = 0.0040;  % Skin friction coefficient (from table 12.3)
aircraft.aerodynamics.c_coeff = -0.1289;   % Constant for Jet Fighter from reference table
aircraft.aerodynamics.d_coeff = 0.7506;    % Constant for Jet Fighter from reference table
aircraft.aerodynamics.Delta_C_D0_clean = 0;


% ----------- Clean Configuration (Cruise) -----------
% parasite drag coefficient (CD0) for clean configuration
aircraft.aerodynamics.CD0_clean = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, 0);

%total drag coefficient using drag polar for cruise
aircraft.aerodynamics.e_cruise = 0.825;
aircraft.aerodynamics.CL_cruise = 1.25;
aircraft.aerodynamics.CD_cruise = drag_polar_calc(aircraft.aerodynamics.CD0_clean, ...
    aircraft.aerodynamics.CL_cruise, aircraft.geometry.AR, aircraft.aerodynamics.e_cruise);

% ----------- Takeoff Configuration (Flaps Deployed) -----------
aircraft.aerodynamics.Delta_C_D0_takeoff = 0.015;  % Additional drag due to takeoff flaps

%parasite drag coefficient (CD0) for takeoff configuration
aircraft.aerodynamics.CD0_takeoff = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.Delta_C_D0_takeoff);

%total drag coefficient for takeoff using drag polar
aircraft.aerodynamics.e_takeoff = 0.775;
aircraft.aerodynamics.CL_takeoff = 1.6;
aircraft.aerodynamics.CD_takeoff = drag_polar_calc(aircraft.aerodynamics.CD0_takeoff, ...
    aircraft.aerodynamics.CL_takeoff, aircraft.geometry.AR, aircraft.aerodynamics.e_takeoff);

% ----------- Landing Configuration (Flaps) -----------
aircraft.aerodynamics.Delta_C_D0_landing_1 = 0.065;  % Additional drag due to landing flaps

%parasite drag coefficient (CD0) for landing configuration
aircraft.aerodynamics.CD0_landing_1 = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.Delta_C_D0_landing_1);

%total drag coefficient for landing using the drag polar equation
aircraft.aerodynamics.e_landing_1 = 0.725;
aircraft.aerodynamics.CL_landing_1 = 1.9;
aircraft.aerodynamics.CD_landing_1 = drag_polar_calc(aircraft.aerodynamics.CD0_landing_1, ...
    aircraft.aerodynamics.CL_landing_1, aircraft.geometry.AR, aircraft.aerodynamics.e_landing_1);

% ----------- Landing Configuration (Flaps and Gear Deployed) -----------
aircraft.aerodynamics.Delta_C_D0_landing_2 = 0.020;  % Additional drag due to landing flaps and gear

aircraft.aerodynamics.CD0_landing_2 = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.Delta_C_D0_landing_2);
%total drag coefficient for landing using the drag polar equation
aircraft.aerodynamics.e_landing_2 = 1;
aircraft.aerodynamics.CL_landing_2 = 2.0;
aircraft.aerodynamics.CD_landing_2 = drag_polar_calc(aircraft.aerodynamics.CD0_landing_2, ...
    aircraft.aerodynamics.CL_landing_2, aircraft.geometry.AR, aircraft.aerodynamics.e_landing_2);




%% %% %% %% UTILITY %% %% %% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% miscelaneous constants for fluids/ performance calculations
aircraft.constants = generate_constants();

end