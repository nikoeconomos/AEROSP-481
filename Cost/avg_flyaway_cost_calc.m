% Aerosp 481 Group 3 - Libellula 
function [avg_flyaway_cost, learning_curve_costs] = avg_flyaway_cost_calc(aircraft_cost, Q)
% Description: This function generates the average flyway cost using the
% roskam method and the learning curve
% 
% 
% INPUTS:
% --------------------------------------------
%    togw kg
% 
% OUTPUTS:
% --------------------------------------------
%    average flyaway cost $
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 10/20/24


target_year = 2024;

Q_i = 1:1:Q;

x = 0.926; %(95% learning curve))

aircraft_cost_2024 = adjust_cost_inflation_calc(aircraft_cost, 1989, target_year); 

learning_curve_costs = aircraft_cost_2024 * (1./Q_i).^(1-x);

avg_flyaway_cost = mean(learning_curve_costs);

end