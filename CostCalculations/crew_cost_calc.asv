function crew_costs = crew_cost_calc(base_year, then_year, airline_factor)
% Description: This function calculates the crew cost incurred through
% flight crew wages and other expenses for multiple missions.
%
% INPUTS: 
%    base_year    - The reference base year for cost escalation
%    then_year    - The year for which cost is being estimated
%    airline_factor - Factor to adjust for airline-specific expenses
%
% OUTPUTS:
%    crew_costs - Estimated crew costs for each mission
% 
% Author:                          Victoria
% Version history revision notes:
%                                  v1: 9/14/2024

    % Cost escalation factors
    base_cef = 5.17053 + 0.104981 * (base_year - 2006);
    then_cef = 5.17053 + 0.104981 * (then_year - 2006);
    cef = base_cef / then_cef; % Cost escalation factor

    % Route factor and MTOW
    route_factor = 1; % Route factor -- estimated
    mtow = max(togw_calc(generate_weight_params(), generate_constants())); % Max takeoff weight

    % Mission block times for different mission profiles
    mission_block_times = block_time_calc(...
        generate_DCA_mission(), ...
        generate_PDI_mission(), ...
        generate_ESCORT_mission() ...
    );

    % Initialize result
    crew_costs = zeros(length(mission_block_times), 1);

    % Calculate crew cost for each mission
    for i = 1:length(mission_block_times)
        mission_block_time = mission_block_times(i);
        crew_costs(i) = airline_factor * (route_factor * (mtow)^0.4 * mission_block_time) * cef;
    end

    % Display the estimated crew cost for each mission
    for i = 1:length(crew_costs)
        fprintf('Estimated crew cost for Mission %d: $%.2f\n', i, crew_costs(i));
    end
end
