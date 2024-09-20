function crew_costs_adjusted = crew_cost_calc(aircraft)
% Description: This function calculates the crew cost incurred through
% flight crew wages and other expenses for multiple missions.
%
% INPUTS: 
%    aircraft struct
%
% OUTPUTS:
%    crew_costs - Estimated crew costs for each mission
% 
% Author:                          Victoria
% Version history revision notes:
%                                  v1: 9/14/2024

    % Route factor
    route_factor = 1; % Route factor -- estimated

    mission_block_time = block_time_calc(aircraft);
    airline_factor = 1; % Estimated

    % Initialize result
    crew_costs = airline_factor * (route_factor * (aircraft.weight.togw)^0.4 * mission_block_time);

    crew_costs_adjusted = adjust_cost_inflation_calc(crew_costs, aircraft.cost.crew.base_year, aircraft.cost.target_year);

end
