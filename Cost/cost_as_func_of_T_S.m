function cost = cost_as_func_of_T_S(aircraft,T,S)
% Description: This function returns the total cost of the aircraft in
% terms of thrust and wing area. Simply replaces the max thrust and
% reference area of the aircraft struct, then reruns the cost analysis.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    T - thrust value; chosen from a point in the T-S grid
%    S - wing area; chosen from a point in the T-S grid
% 
% OUTPUTS:
% --------------------------------------------
%    cost - new cost of the aircraft with specific T and S
%                       
% 
% See also: None
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/29/2024

    [aircraft] = W_from_S_constraint_calc(aircraft,S);
    aircraft.propulsion.T_max = T;
    aircraft.geometry.S_ref = S;
    aircraft = generate_cost_params(aircraft);
    cost = aircraft.cost.total;
end