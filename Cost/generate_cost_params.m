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

%% General Parameters %%
%%%%%%%%%%%%%%%%%%%%%%%
target_year = 2024;


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

% Labor %
aircraft.labor.skunk_works_hourly_2024 = 63; % USD/hour
aircraft.labor.tooling_hourly_2024 = 61; % USD/hour
aircraft.labor.manufacturing_hourly_2024 = 27; % USD/hour

% AIRFRAME %
aircraft.airframe.maint_cost = airframe_maint_cost_calc(aircraft);


% Missile cost
aircraft.cost.missile.cost_base = 386000;  % USD
aircraft.cost.missile.base_year = 2006;
aircraft.cost.missile.cost_2024 = adjust_cost_inflation_calc(aircraft.cost_params.missile.cost_base, aircraft.cost_params.missile.base_year, target_year); % USD

% Avionics cost 
aircraft.cost.avionics.cost_base = 234000;  % USD
aircraft.cost.avionics.base_year = 2006;  
aircraft.cost.avionics.cost_2024 = adjust_cost_inflation_calc(aircraft.cost_params.avionics_cost_base, base_year, target_year); % USD

% Cannon cost
aircraft.cost.cannon.cost_base = 250290;  % USD
aircraft.cost.cannon.base_year = 2006;  
aircraft.cost.cannon.cost_2024 = adjust_cost_inflation_calc(aircraft.cost_params.cannon_cost_base, base_year, target_year); % USD

end




















