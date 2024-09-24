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


%% Drag Polar and Parasite Drag Coefficent 

aircraft.aerodynamics.Cf_clean = 0.0040;  % Skin friction coefficient (from table 12.3)
aircraft.aerodynamics.c_coeff = -0.1289;   % Constant for Jet Fighter from reference table
aircraft.aerodynamics.d_coeff = 0.7506;    % Constant for Jet Fighter from reference table
aircraft.aerodynamics.delta_CD0_clean = 0;


%% ----------- Clean Configuration (Cruise) -----------
% parasite drag coefficient (CD0) for clean configuration
aircraft.aerodynamics.CD0_clean = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, 0);

%total drag coefficient using drag polar for cruise
aircraft.aerodynamics.e_cruise = 0.825;
aircraft.aerodynamics.CL_cruise = 1.25;
aircraft.aerodynamics.CD_cruise = drag_polar_calc(aircraft.aerodynamics.CD0_clean, ...
    aircraft.aerodynamics.CL_cruise, aircraft.geometry.AR, aircraft.aerodynamics.e_cruise);

%% ----------- Takeoff Configuration (Flaps Deployed) -----------
aircraft.aerodynamics.delta_CD0_takeoff = 0.015;  % Additional drag due to takeoff flaps

%parasite drag coefficient (CD0) for takeoff configuration
aircraft.aerodynamics.CD0_takeoff = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.delta_CD0_takeoff);

%total drag coefficient for takeoff using drag polar
aircraft.aerodynamics.e_takeoff = 0.775;
aircraft.aerodynamics.CL_takeoff = 1.6;
aircraft.aerodynamics.CD_takeoff = drag_polar_calc(aircraft.aerodynamics.CD0_takeoff, ...
                                                    aircraft.aerodynamics.CL_takeoff, aircraft.geometry.AR, aircraft.aerodynamics.e_takeoff);

%% ----------- Landing Configuration (Flaps) -----------
aircraft.aerodynamics.delta_CD0_landing_flaps = 0.065;  % Additional drag due to landing flaps

%parasite drag coefficient (CD0) for landing configuration
aircraft.aerodynamics.CD0_landing_flaps = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.delta_CD0_landing_flaps);

%total drag coefficient for landing using the drag polar equation
aircraft.aerodynamics.e_landing_flaps = 0.725;
aircraft.aerodynamics.CL_landing_flaps = 1.9;
aircraft.aerodynamics.CD_landing_flaps = drag_polar_calc(aircraft.aerodynamics.CD0_landing_flaps, ...
                                        aircraft.aerodynamics.CL_landing_flaps, aircraft.geometry.AR, aircraft.aerodynamics.e_landing_1);

%% ----------- Landing Configuration (Flaps and Gear Deployed) -----------
aircraft.aerodynamics.delta_CD0_landing_flaps_gears = 0.020;  % Additional drag due to landing flaps and gear

aircraft.aerodynamics.CD0_landing_flaps_gears = parasite_drag_calc(aircraft.weight.togw, aircraft.geometry.S_ref, aircraft.aerodynamics.Cf_clean, aircraft.aerodynamics.c_coeff, aircraft.aerodynamics.d_coeff, aircraft.aerodynamics.delta_CD0_landing_flaps_gears);
%total drag coefficient for landing using the drag polar equation
aircraft.aerodynamics.e_landing_flaps_gears = 1;
aircraft.aerodynamics.CL_landing_flaps_gears = 2.0;
aircraft.aerodynamics.CD_landing_flaps_gears = drag_polar_calc(aircraft.aerodynamics.CD0_landing_flaps_gears, ...
aircraft.aerodynamics.CL_landing_flaps_gears, aircraft.geometry.AR, aircraft.aerodynamics.e_landing_flaps_gears);


end