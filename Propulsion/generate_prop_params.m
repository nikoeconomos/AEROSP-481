% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_prop_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the propulsion system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with propulsion
%    parameters
%                       
% 
% See also: None
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/13/2024

%% COSTS %%
%%%%%%%%%%%

propulsion.fuel_price = 2.14; % $/gal as of September 13, 2024
propulsion.oil_price = 113.92; % $/gal as of September 13, 2024
propulsion.fuel_density = 7.01; % lb/gal
propulsion.oil_density = 8.375; % lb/gal
propulsion.max_thrust = 29160; % lbf
propulsion.maintenace_labor_rate = 24.81; % $ as of June 2024
propulsion.engine_cost = 8200000; % $, 2024

%% UPDATE AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%

aircraft.propulsion = propulsion;

end