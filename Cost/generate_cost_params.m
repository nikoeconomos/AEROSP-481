% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_cost_params(aircraft)
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
%    aircraft - aircraft param with struct, updated with cost
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Individual Components %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PROPULSION %
aircraft.propulsion.fuel_price = 2.14/0.00378541; % $/m3 as of September 13, 2024
aircraft.propulsion.oil_price = 113.92/0.00378541; % $/m3 as of September 13, 2024
aircraft.propulsion.fuel_cost = 1.02*aircraft.weight.ff*aircraft.weight.togw*aircraft.propulsion.fuel_price/aircraft.propulsion.fuel_density;
aircraft.propulsion.oil_cost = 1.02*aircraft.propulsion.weight_oil*aircraft.propulsion.oil_price/aircraft.propulsion.oil_density;
aircraft.propulsion.engine_maintenance_cost = engine_maint_cost_calc(aircraft);
aircraft.propulsion.total_cost = prop_cost_calc(aircraft);


% CREW %
aircraft.crew.crew_cost = crew_cost_calc(aircraft);


% AIRFRAME %
aircraft.airframe.maint_cost = airframe_maintenance_cost_calc(aircraft);































end