function adjusted_cost = adjust_cost_inflation_calc(base_cost, base_year, target_year)
% AE 481: Aircraft Design - Group 3: Libellula
% Inflation Adjustment Function for Avionics and Weapons Cost
%
% Description: 
% This script adjusts the costs of the missile, avionics system, and cannon 
% from their base year (2005) to the target year (2024) using the Cost 
% Escalation Factor (CEF). The CEF formula is used to account 
% for inflation over time.
%
% INPUTS:
%    base_cost  - The original cost of the item in the base year
%    base_year  - The year the base cost applies to
%    then_year - The year to which you want to adjust the cost (2024)
%
% OUTPUTS:
%    adjusted_cost - The cost adjusted to the target year using inflation
%
% Version History:
%    v1:   9/15/2024 - Initial version (Vienna)
%
% See also: prop_cost_calc.m, engine_maint_cost_calc.m
%
% Author:
%    Vienna - 9/15/2024

% Inflation adjustment function using the CEF method

% Compare years again 2006 (from Raymer)
compare_year = 2006;

% Calculate bCEF (Base Year CEF) and tCEF (Then Year CEF)
bCEF = 5.17053 + 0.104981 * (base_year - compare_year);  % Base year CEF TODO
tCEF = 5.17053 + 0.104981 * (target_year - compare_year); % Target year CEF

% Calculate the effective CEF
CEF = tCEF / bCEF;

% Adjust the cost using the CEF
adjusted_cost = base_cost * CEF;
    
end