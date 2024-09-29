    function maintenance_costs_adjusted = airframe_maint_cost_calc(aircraft)
    % Description: This function calculates the airframe maintenance costs 
    % incurred for multiple missions based on block times and aircraft weight.
    %
    % INPUTS: 
    %    aircraft struct
    %
    % OUTPUTS:
    %    maintenance_costs - Estimated airframe maintenance costs for each mission
    % 
    % Author:                          Victoria
    % Version history revision notes:
    %                                  v1: 9/14/2024
    

    % Route factor and MTOW (constant for all missions)
    route_factor = 1; % Route factor - Estimated
    airline_factor = 1; % Estimated

    maintenance_factor = 0.15; % Estimated
    mission_block_time = block_time_calc(aircraft);

    maintenance_costs = maintenance_factor * airline_factor * (route_factor * (aircraft.weight.togw)^0.6 * mission_block_time);

    maintenance_costs_adjusted = adjust_cost_inflation_calc(maintenance_costs, aircraft.cost.propulsion.engine.base_year, aircraft.cost.target_year);

end
