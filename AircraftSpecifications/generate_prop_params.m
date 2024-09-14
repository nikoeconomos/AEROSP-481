% Aerosp 481 Group 3 - Libellula 
function [prop_params] = generate_prop_params()
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the propulsion system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    None
% 
% OUTPUTS:
% --------------------------------------------
%    weight_params - X element struct, contains:
%                       
% 
% See also: None
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/13/2024

    prop_params.fuel_price = 2.14; % $/gal as of September 13, 2024
    prop_params.oil_price = 113.92; % $/gal as of September 13, 2024
    prop_params.fuel_density = 7.01; % lb/gal
    prop_params.oil_density = 8.375; % lb/gal
    prop_params.max_thrust = 29160; % lbf
    prop_params.maintenace_labor_rate = 24.81; % $ as of June 2024
    prop_params.engine_cost = 8200000; % $, 2024
end