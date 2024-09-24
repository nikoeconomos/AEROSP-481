% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_aerodynamics_params(aircraft)
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
%    aircraft - aircraft param with struct, updated with aerodynamics
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Lift to Drag %%
%%%%%%%%%%%%%%%%%%

[LD_max, LD_cruise] = LD_calc();

aircraft.aerodynamics.LD_max = LD_max;
aircraft.aerodynamics.LD_cruise = LD_cruise;

%% Drag polar %%
%%%%%%%%%%%%%%%%

% aircraft = generate_drag_polar_params(aircraft); %uncomment when ready

%% Stall Speed at takeoff 

aircraft.environment.rho_SL = 1.225; %[kg.m^3]  % UPDATE TO INCLUDE THE TEMP

%aircraft.aerodynamics.V_stall = stall_speed_calc(aircraft.aerodynamics.W_S,aircraft.aerodynamics.rho,aircraft.aerodynamics.CL_max_takeoff);


end