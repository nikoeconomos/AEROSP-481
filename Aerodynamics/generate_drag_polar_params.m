% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_drag_polar_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the aerodynamics system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with drag polar
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/23/2024


%% Parasite Drag Coefficent & grabbing constants

Cf = aircraft.aerodynamics.Cf;  % Skin friction coefficient (metabook table 4.4)
S_wet = aircraft.geometry.S_wet;
S_ref = aircraft.geometry.S_ref;
AR = aircraft.geometry.AR;

%% ----------- Clean Configuration (Cruise) -----------
% parasite drag coefficient (CD0) for clean configuration
aircraft.aerodynamics.CD0_clean = CD0_calc(Cf, S_wet, S_ref);

aircraft.aerodynamics.e_cruise = 0.80; %from table 4.2 metabook
aircraft.aerodynamics.CL_cruise = 1.25; % from 06 Preliminary sizing presentation Slide 48
aircraft.aerodynamics.CD_cruise = CD_parabolic_drag_polar_calc(aircraft.aerodynamics.CD0_clean, aircraft.aerodynamics.CL_cruise,...
                                                               AR, aircraft.aerodynamics.e_cruise);

%% ----------- Takeoff Configuration 2 (Flaps Deployed, gear down ) -----------

aircraft.aerodynamics.e_takeoff_flaps = 0.75; % from table 4.2 metabook
aircraft.aerodynamics.CL_takeoff_flaps = 1.7; % from 06 Preliminary sizing presentation Slide 48

% calculate new parasitic drag
delta_CD0_takeoff_flaps = 0.010;  % Additional drag due to takeoff flaps, metabook table 4.2
aircraft.aerodynamics.CD0_takeoff_flaps = aircraft.aerodynamics.CD0_clean + delta_CD0_takeoff_flaps;

aircraft.aerodynamics.CD_takeoff_flaps_gear = CD_parabolic_drag_polar_calc(aircraft.aerodynamics.CD0_takeoff_flaps, aircraft.aerodynamics.CL_takeoff_flaps, ...
                                                                           AR, aircraft.aerodynamics.e_takeoff_flaps);
%% ----------- Takeoff Configuration 1 (Flaps deployed, gear up) -------------

delta_CD0_gear_down = 0.015;  % Additional drag due to LG, metabook table 4.2
aircraft.aerodynamics.CD0_takeoff_flaps_gear = aircraft.aerodynamics.CD0_clean + delta_CD0_takeoff_flaps + delta_CD0_gear_down;

aircraft.aerodynamics.CD_takeoff_flaps = CD_parabolic_drag_polar_calc(aircraft.aerodynamics.CD0_takeoff_flaps, aircraft.aerodynamics.CL_takeoff_flaps, ...
                                                                      AR, aircraft.aerodynamics.e_takeoff_flaps);


%% ----------- Landing Configuration 1 (Flaps, gear up) -----------
aircraft.aerodynamics.e_landing_flaps = 0.70; % from table 4.2 metabook
aircraft.aerodynamics.CL_landing_flaps = 2.0; % from 06 Preliminary sizing presentation Slide 48

% calculate new parasitic drag
delta_CD0_landing_flaps = 0.055;  % Additional drag due to landing flaps, metabook table 4.2
aircraft.aerodynamics.CD0_landing_flaps = aircraft.aerodynamics.CD0_clean + delta_CD0_landing_flaps;

aircraft.aerodynamics.CD_landing_flaps = CD_parabolic_drag_polar_calc(aircraft.aerodynamics.CD0_landing_flaps, aircraft.aerodynamics.CL_landing_flaps, ...
                                                                      AR, aircraft.aerodynamics.e_landing_flaps);

%% ----------- Landing Configuration 2 (Flaps and Gear Deployed) -----------

delta_CD0_gear_down = 0.015;  % Additional drag due to LG, metabook table 4.2
aircraft.aerodynamics.CD0_landing_flaps_gear = aircraft.aerodynamics.CD0_clean + delta_CD0_landing_flaps + delta_CD0_gear_down;

aircraft.aerodynamics.CD_landing_flaps_gear = CD_parabolic_drag_polar_calc(aircraft.aerodynamics.CD0_landing_flaps_gear, aircraft.aerodynamics.CL_landing_flaps,...
                                                                           AR, aircraft.aerodynamics.e_landing_flaps);


end