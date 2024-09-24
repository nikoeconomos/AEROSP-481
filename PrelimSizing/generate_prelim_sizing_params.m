% Aerosp 481 Group 3 - Libellula 
function aircraft = generate_prelim_sizing_params(aircraft)
% Description: This function generates a struct of aircraft parameters that
% relate to assignment 4, preliminary sizing.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with prelim sizing
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% ***CATEGORY*** %%
%%%%%%%%%%%%%%%%%%%%
%aircraft.descriptiveName.placeholder = 0; %placeholder
%Wetted surface area estimate placed into generate_geometry_params(), m2
aircraft.aerodynamics.skin_friction_coefficient = 0.0035; % skin friction coefficient estimate

aircraft.aerodynamics.span_efficiency = 0.85;
aircraft.performance.max_sustained_g_force = 3.5;
aircraft.performance.max_sustained_turn_mach = 1.2;

aircraft.performance.cruise_speed_mach = 0.8; % mach number taken from an average in our historical dataset


aircraft.aerodynamics.e_cruise = 0.8; %from table
aircraft.aerodynamics.e_takeoff = 0.75; %from table
aircraft.aerodynamics.e_landing_1 = 0.7; %from table

aircraft = generate_climb_segments(aircraft);


% Thrust design point
% S design point put in

end