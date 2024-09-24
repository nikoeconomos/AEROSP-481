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
Swet = 10^(-.1289)*(aircraft.weight.togw)^0.7506; %Wetted surface area estimate, ft2
aircraft.aerodynamics.Swet = Swet*0.092903; %Wetted surface area estimate, m2
aircraft.aerodynamics.skin_friction_coefficient = 0.0035; % skin friction coefficient estimate

aircraft.geometry.aspect_ratio = 2.66; %Assumed from F-35
aircraft.geometry.AR = 2.663; % Of the F35. TODO CHANGE ESTIMATE

aircraft.aerodynamics.Sref = 0.75*aircraft.aerodynamics.Swet/aircraft.geometry.aspect_ratio; % Estimated from wetted aspect ratio graph (fig 2.4)
aircraft.aerodynamics.span_efficiency = 0.85;
aircraft.performance.max_sustained_g_force = 3.5;
aircraft.performance.max_sustained_turn_mach = 1.2;

aircraft.performance.cruise_speed_mach = 0.8; % mach number taken from an average in our historical dataset

aircraft.geometry.S_ref = 19.55*19.55*0.85; % Wingspan of F14^2 * 0.85 to account for taper. ROUGH estimate. TODO CHANGE


aircraft.aerodynamics.e_cruise = 0.8; %from table
aircraft.aerodynamics.e_takeoff = 0.75; %from table
aircraft.aerodynamics.e_landing_1 = 0.7; %from table

aircraft = generate_climb_segments(aircraft);


end