% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_prelim_sizing_params(aircraft)
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
aircraft.aerodynamics.span_efficiency = 0.85;
aircraft.performance.max_sustained_g_force = 3.5;
aircraft.performance.max_sustained_turn_mach = 1.2;









%% ***CATEGORY*** %%
%%%%%%%%%%%%%%%%%%%%













end