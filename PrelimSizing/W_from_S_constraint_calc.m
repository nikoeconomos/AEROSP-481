function [aircraft] = W_from_S_constraint_calc(aircraft,S)
% Description: This function returns an array of T values from S inputs
% based on a constraint function f
%
% INPUTS:
% --------------------------------------------%
%
%   f - function handle for the calculation of T/W
%   k - number of data points for the plot
%   s_min - minimum value of s for our input array
%   s_max - maximum value of s for our input array
%
% OUTPUTS:
% --------------------------------------------
%    S - array of length k with input S values
%    T - array of length k with output T values from f
%
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/27/2024

W0 = aircraft.weight.togw;
tol = 10e-6;
delta = 2*tol;

while delta > tol

    empty_weight_fraction = 2.11*W0^-0.13; % Re-do regression from Raymer table 3.1
    empty_weight = empty_weight_fraction*W0; % Find actual empty weight
    empty_weight = empty_weight + aircraft.weight.wing_density * (S - aircraft.design_point.S_design); % Account for wing size from planform area
    empty_weight = empty_weight + w_eng_calc(aircraft.propulsion.T_military) - ...
    w_eng_calc(aircraft.design_point.T_design); % Account for engine weight with design point thrust and with original estimated thrust
    
    

    fuel_fraction = ff_total_func_S_calc(aircraft,S); % Use updated fuel fraction now inforporating design point S
    
    W0_new = (aircraft.weight.crew + aircraft.weight.payload) ./ (1 - fuel_fraction - empty_weight/W0);

    delta = abs(W0_new - W0)/abs(W0_new);
    W0 = W0_new;

end

end