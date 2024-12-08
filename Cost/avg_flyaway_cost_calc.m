% Aerosp 481 Group 3 - Libellula 
function [H_adjusted] = learning_curve_95(H1, Q)
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

x = 0.926; %(95% learning curve))

H_adjusted = H1 * (1/Q)^(1-x);

avg_flyaway_cost = mean(learning_curve_costs);

end