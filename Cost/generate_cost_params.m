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
aircraft.cost.target_year = 2024;


%% Individual Components %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PROPULSION %%
aircraft.cost.propulsion.fuel_price = 2.14/0.00378541; % $/m3 as of September 13, 2024
aircraft.cost.propulsion.oil_price = 113.92/0.00378541; % $/m3 as of September 13, 2024
aircraft.cost.propulsion.fuel_cost = 1.02*aircraft.weight.ff*aircraft.weight.togw*aircraft.cost.propulsion.fuel_price/aircraft.weight.fuel_density;
aircraft.cost.propulsion.oil_cost = 1.02*aircraft.weight.oil*aircraft.cost.propulsion.oil_price/aircraft.weight.oil_density;

% Engine cost
aircraft.cost.propulsion.engine.base_year = 1993;
aircraft.cost.propulsion.engine.maintenance_labor_rate = 24.81; % $ as of June 2024
aircraft.cost.propulsion.engine.maintenance_cost = engine_maint_cost_calc(aircraft);

% engine cost
aircraft.cost.propulsion.engine.engine_cost = 5000000; % TODO adjust when engine is selected

aircraft.cost.propulsion.total = aircraft.propulsion.num_engines*aircraft.cost.propulsion.engine.engine_cost ...
                                + aircraft.cost.propulsion.fuel_cost + aircraft.cost.propulsion.oil_cost ...
                                + aircraft.cost.propulsion.engine.maintenance_cost;


%% CREW %
aircraft.cost.crew.base_year = 1993;
aircraft.cost.crew.crew_cost = crew_cost_calc(aircraft);

%% Labor %
aircraft.cost.labor.skunk_works_hourly_2024 = 63; % USD/hour
aircraft.cost.labor.tooling_hourly_2024 = 61; % USD/hour
aircraft.cost.labor.manufacturing_hourly_2024 = 27; % USD/hour

%% AIRFRAME %
aircraft.cost.airframe.maint_cost = airframe_maint_cost_calc(aircraft);

%% Missile cost
aircraft.cost.missile.cost_base = 386000;  % USD Pulled RFP
aircraft.cost.missile.base_year = 2006;
aircraft.cost.missile.cost_2024 = adjust_cost_inflation_calc(aircraft.cost.missile.cost_base, aircraft.cost.missile.base_year, aircraft.cost.target_year); % USD
aircraft.cost.missile.total = aircraft.cost.missile.cost_2024*aircraft.payload.num_missiles;

%% Avionics cost 
aircraft.cost.avionics.cost_base = 234000;  % USD
aircraft.cost.avionics.base_year = 2006;  
aircraft.cost.avionics.cost_2024 = adjust_cost_inflation_calc(aircraft.cost.avionics.cost_base, aircraft.cost.avionics.base_year, aircraft.cost.target_year); % USD

%% Cannon cost
aircraft.cost.cannon.cost_base = 250290;  % USD
aircraft.cost.cannon.base_year = 2006;  
aircraft.cost.cannon.cost_2024 = adjust_cost_inflation_calc(aircraft.cost.cannon.cost_base, aircraft.cost.cannon.base_year, aircraft.cost.target_year); % USD

%% total cost
aircraft.cost.total = aircraft.cost.missile.cost_2024*aircraft.payload.num_missiles + aircraft.cost.cannon.cost_2024 ...
                        + aircraft.cost.airframe.maint_cost + aircraft.cost.crew.crew_cost + aircraft.cost.propulsion.total + aircraft.cost.avionics.cost_2024...
                        + 0; % TODO INPUT LABOR COSTS -- HOW??

end




















