function crew_costs = crew_cost_calc(aircraft)
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
    base_cef = 5.17053 + 0.104981 * (1993 - 2006);
    then_cef = 5.17053 + 0.104981 * (2024 - 2006);
    cef = base_cef / then_cef; % Cost escalation factor

    % Route factor and MTOW
    route_factor = 2; % Route factor -- estimated

    mission_block_time = block_time_calc(aircraft);
    airline_factor = 1;

    % Initialize result
    crew_costs = airline_factor * (route_factor * (mtow)^0.4 * mission_block_time) * cef;

end
