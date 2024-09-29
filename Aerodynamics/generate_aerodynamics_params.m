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

%[LD_max, LD_cruise] = LD_calc(); % TODO UNCOMMENT WHEN THE FUNCTION WORKS
%aircraft.aerodynamics.LD_max = LD_max;
%aircraft.aerodynamics.LD_cruise = LD_cruise;

aircraft.aerodynamics.LD_max = 12; % TODO: UPDATE, ESTIMATION, from hand calculation & graph
aircraft.aerodynamics.LD_cruise = 0.943*aircraft.aerodynamics.LD_max; % next to eq 2.15

aircraft.aerodynamics.Cf = 0.0035; % skin friction coefficient estimate figure 4.4 meta 

aircraft.aerodynamics.e_maneuver = 0.8; % TODO not sure if this changes. Used in maneuver. Can be replaced by e_cruise

%% Drag polar %%
%%%%%%%%%%%%%%%%

aircraft = generate_drag_polar_params(aircraft);

%% Stall Speed at takeoff 

aircraft.environment.rho_SL_15C = 1.225; %[kg.m^3]  % 15 degrees celsius, sea level
aircraft.environment.rho_SL_45C = 1.109; % [kg/m^3] % 45 degrees celsius, sea level. Calculated from an online calc

aircraft.performance.max_alt = 15240; %[m], got this from f35 guess (50,000 feet). Needs to be updated with our actual max altitude. TOD UPDATE

[~, ~, rho_max_alt, ~] = standard_atmosphere_calc(aircraft.performance.max_alt);
aircraft.environment.rho_max_alt = rho_max_alt;

%aircraft.aerodynamics.V_stall = stall_speed_calc(aircraft.aerodynamics.W_S,aircraft.aerodynamics.rho,aircraft.aerodynamics.CL_max_takeoff);


end