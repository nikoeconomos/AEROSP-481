% Aerosp 481 Group 3 - Libellula 
function total_prop_cost = prop_cost_calc(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the propulsion system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    total_prop_cost - Total cost of the propulsion system, in 2024 dollars
%                       
% 
% See also: block_time_calc.m, ff_total_calc.m
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/14/2024
%                                  v1.1: 9/15/2024 - Modified to use
%                                  aircraft struct input argument. (Joon)
%                                  v1.2: 9/15/2024 - Separated engine
%                                  maintenance cost into a different
%                                  function.
    
    total_prop_cost = aircraft.propulsion.engine_cost + aircraft.propulsion.fuel_cost + aircraft.propulsion.oil_cost + aircraft.propulsion.engine_maintenance_cost;
end