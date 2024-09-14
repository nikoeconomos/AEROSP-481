% This calculates cost incurred through flight crew wages and other expenses

airline_factor = 0.8; % Average
base_year = ;
then_year = ;
base_cef = 5.17053 + 0.104981 * (base_year - );
then_cef = 5.17053 + 0.104981 * (then_year - );
cef = base_cef / then_cef; % Cost escalation factor
mission_block_time = ; % In hours
k = ; % Route factor
mtow = max(togw_calculation(generate_weight_params(),generate_constants())); % Max takeoff weight

crew_cost = airline_factor * (route_factor * (mtow)^0.4 * mission_block_time) * cef;
