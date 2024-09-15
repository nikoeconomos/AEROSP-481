function maintenance_costs = airframe_maintence_cost_calc(base_year, then_year, airline_factor)
    % Description: This function calculates the airframe maintenance costs 
    % incurred for multiple missions based on block times and aircraft weight.
    %
    % INPUTS: 
    %    base_year    - The reference base year for cost escalation
    %    then_year    - The year for which cost is being estimated
    %    airline_factor - Factor to adjust for airline-specific expenses
    %
    % OUTPUTS:
    %    maintenance_costs - Estimated airframe maintenance costs for each mission
    % 
    % Author:                          Victoria
    % Version history revision notes:
    %                                  v1: 9/14/2024

    % Cost escalation factors
    base_cef = 5.17053 + 0.104981 * (base_year - 2006);
    then_cef = 5.17053 + 0.104981 * (then_year - 2006);
    cef = base_cef / then_cef; % Cost escalation factor

    % Route factor and MTOW (constant for all missions)
    route_factor = 1; % Route factor (can adjust if needed)
    mtow = max(togw_calculation(generate_weight_params(), generate_constants())); % Max takeoff weight

    % Maintenance cost multiplier (hypothetical constant factor)
    maintenance_factor = 0.15; % Adjust to reflect typical maintenance cost influence

    % Mission block times for different mission profiles
    mission_block_times = block_time_calc(...
        generate_DCA_mission(), ...
        generate_PDI_mission(), ...
        generate_ESCORT_mission() ...
    );

    % Initialize result
    maintenance_costs = zeros(length(mission_block_times), 1);

    % Calculate airframe maintenance cost for each mission
    for i = 1:length(mission_block_times)
        mission_block_time = mission_block_times(i);
        % Airframe maintenance cost formula
        maintenance_costs(i) = maintenance_factor * airline_factor * ...
                               (route_factor * (mtow)^0.6 * mission_block_time) * cef;
    end

    % Display the estimated maintenance cost for each mission
    for i = 1:length(maintenance_costs)
        fprintf('Estimated airframe maintenance cost for Mission %d: $%.2f\n', i, maintenance_costs(i));
    end
end
