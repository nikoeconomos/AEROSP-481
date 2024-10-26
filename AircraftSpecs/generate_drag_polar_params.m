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

aero = aircraft.aerodynamics;

%% ----------- Clean Configuration (Cruise) -----------
% parasite drag coefficient (CD0) for clean configuration
aero.CD0.clean = 0.0236;

aero.e.cruise = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.clean, 0, 0.98);
aero.CL.cruise = 1.25; % from 06 Preliminary sizing presentation Slide 48
aero.CD.cruise = aero.CD_parabolic_drag_polar_calc(aero.CD0.clean, aero.CL.cruise, aero.e.cruise);

aero.LD.max_cruise = aero.LD_max_calc(aero.e.cruise, aero.CD0.clean);
aero.LD.cruise = aero.CL.cruise/aero.CD.cruise;

%% ----------- Takeoff Configuration 2 (Flaps Deployed, gear up ) -----------

aero.CL.takeoff_flaps = 1.7; % from 06 Preliminary sizing presentation Slide 48

% calculate new parasitic drag
delta_CD0_takeoff_flaps = 0.010;  % Additional drag due to takeoff flaps, metabook table 4.2
aero.CD0.takeoff_flaps = aero.CD0.clean + delta_CD0_takeoff_flaps;

%aero.e_takeoff_flaps = 0.75; % from table 4.2 metabook
aero.e.takeoff_flaps = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.takeoff_flaps, 0,  0.98);

aero.CD.takeoff_flaps = aero.CD_parabolic_drag_polar_calc(aero.CD0.takeoff_flaps, aero.CL.takeoff_flaps, aero.e.takeoff_flaps);

aero.LD.max_takeoff_flaps = aero.LD_max_calc(aero.e.takeoff_flaps, aero.CD0.takeoff_flaps);
aero.LD.takeoff_flaps = aero.CL.takeoff_flaps/aero.CD.takeoff_flaps;

%% ----------- Takeoff Configuration 1 (Flaps deployed, gear down) -------------

delta_CD0_gear_down = 0.015;  % Additional drag due to LG, metabook table 4.2
aero.CD0.takeoff_flaps_gear = aero.CD0.clean + delta_CD0_takeoff_flaps + delta_CD0_gear_down;

aero.CD.takeoff_flaps_gear = aero.CD_parabolic_drag_polar_calc(aero.CD0.takeoff_flaps_gear, aero.CL.takeoff_flaps, aero.e.takeoff_flaps);

aero.LD.max_takeoff_flaps_gear = aero.LD_max_calc(aero.e.takeoff_flaps, aero.CD0.takeoff_flaps_gear);
aero.LD.takeoff_flaps_gear = aero.CL.takeoff_flaps/aero.CD.takeoff_flaps_gear;

%% ----------- Landing Configuration 1 (Flaps, gear up) -----------

aero.CL.landing_flaps = 2; % from 06 Preliminary sizing presentation Slide 48

% calculate new parasitic drag
delta_CD0_landing_flaps = 0.055;  % Additional drag due to landing flaps, metabook table 4.2
aero.CD0.landing_flaps = aero.CD0.clean + delta_CD0_landing_flaps;

%aero.e_landing_flaps = 0.70; % from table 4.2 metabook
aero.e.landing_flaps = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.landing_flaps, 0,  0.98);
aero.CD.landing_flaps = aero.CD_parabolic_drag_polar_calc(aero.CD0.landing_flaps, aero.CL.landing_flaps, aero.e.landing_flaps);

aero.LD.max_landing_flaps = aero.LD_max_calc(aero.e.landing_flaps, aero.CD0.landing_flaps);
aero.LD.landing_flaps = aero.CL.landing_flaps/aero.CD.landing_flaps;

%% ----------- Landing Configuration 2 (Flaps and Gear Deployed) -----------

delta_CD0_gear_down = 0.015;  % Additional drag due to LG, metabook table 4.2
aero.CD0.landing_flaps_gear = aero.CD0.clean + delta_CD0_landing_flaps + delta_CD0_gear_down;

aero.CD.landing_flaps_gear = aero.CD_parabolic_drag_polar_calc(aero.CD0.landing_flaps_gear, aero.CL.landing_flaps, aero.e.landing_flaps);

aero.LD.max_landing_flaps_gear = aero.LD_max_calc(aero.e.landing_flaps, aero.CD0.landing_flaps_gear);
aero.LD.landing_flaps_gear = aero.CL.landing_flaps/aero.CD.landing_flaps_gear;

%% Maneuver/combat

aero.e.supersonic = 0.5; %historical values from aerotoolbox
aero.CL.combat = 1.0; % lower end estimation from Raymer chapter 5.3.9

%%
aircraft.aerodynamics = aero; % REASSIGN

end