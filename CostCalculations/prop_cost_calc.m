% Aerosp 481 Group 3 - Libellula 
function total_prop_cost = prop_cost_calc(prop_params, togw, mission_ff, block_time,cef)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the propulsion system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    prop_params - 7 element struct, contains:
%                       fuel/oil prices and densities
%                       max thrust
%                       engine maint labor rate
%                       engine cost
%   togw - Takeoff Gross Weight obtained from togw_calculation; modify
%   input to input the corresponding mission
%   mission_ff - fuel fraction for a given mission profile
%   block_time - block time for specific mission
%   number_engines - number of engines to be used
%   cef - Cost Escalation Factor
% 
% OUTPUTS:
% --------------------------------------------
%    total_prop_cost - Total cost of the propulsion system, in 2024 dollars
%                       
% 
% See also: block_time_calc.m, ff_total_calc.m
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/13/2024
    % vvv PARAMETERIZE THIS SECTION IF NEEDED!!! vvv
    number_engines = 2;
    base_year = 1993;
    then_year = 2024;
    bcef = 5.17053+0.104981*(base_year-2006);
    tcef = 5.17053+0.104981*(then_year-2006);
    cef = tcef/bcef;
    % ^^^ PARAMETERIZE THIS SECTION IF NEEDED!!! ^^^
    fuel_cost = 1.02*mission_ff*togw*prop_params.fuel_price/prop_params.fuel_density;
    weight_oil = 0.0125*mission_ff*togw*block_time/100;
    oil_cost = 1.02*weight_oil*prop_params.oil_price/prop_params.oil_density;
    Cml = (0.645+(0.05*prop_params.max_thrust/10000))*(0.566+0.434/tb)*prop_params.maintenance_labor_rate;
    Cmm = (25+(18*prop_params.max_thrust/10000))*(0.62+0.38/block_time)*cef;
    engine_maint_cost = number_engines*(Cml+Cmm)*block_time;
    total_prop_cost = number_engines*prop_params.engine_cost + fuel_cost + oil_cost + engine_maint_cost;
end