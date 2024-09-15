function maintenance_costs = airframe_maint_cost_calc(aircraft)
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
    
    % Cost escalation factors
    base_cef = 5.17053 + 0.104981 * (1993 - 2006);
    then_cef = 5.17053 + 0.104981 * (2024 - 2006);
    cef = base_cef / then_cef; % Cost escalation factor

    % Route factor and MTOW (constant for all missions)
    route_factor = 1; % Route factor - Estimated
    airline_factor = 1; % Estimated

    maintenance_factor = 0.15; % Estimated
    mission_block_time = block_time_calc(aircraft);

    maintenance_costs = maintenance_factor * airline_factor * (route_factor * (aircraft.weight.togw)^0.6 * mission_block_time) * cef;

end
