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

% Define the base year and target year
base_year = 2005;
target_year = 2024;

% Missile cost 
missile_cost_2005 = 386000;  

% Avionics cost in 2005
avionics_cost_2005 = 2340000;  

% Cannon cost 
cannon_cost_2005 = 250290; 
% M61A1 20 mm cannon cost $200,000 + ammunitionn feed system $50,000 =
% 250,000
% Ammunition (50 rounds): Ammunition cost = 500 x 0.58 = 290 USD 
% Total Cannon Cost = 250,290

% Apply inflation adjustment using apply_inflation function
missile_cost_2024 = apply_inflation(missile_cost_2005, base_year, target_year);
avionics_cost_2024 = apply_inflation(avionics_cost_2005, base_year, target_year);
cannon_cost_2024 = apply_inflation(cannon_cost_2005, base_year, target_year);

% Display the adjusted costs


% Inflation adjustment function using the CEF method
function adjusted_cost = apply_inflation(base_cost, base_year, target_year)

    % Calculate bCEF (Base Year CEF) and tCEF (Then Year CEF)
    bCEF = 5.17053 + 0.104981 * (base_year - 2006);  % Base year CEF
    tCEF = 5.17053 + 0.104981 * (target_year - 2006); % Target year CEF
    
    % Calculate the effective CEF
    CEF = tCEF / bCEF;
    
    % Adjust the cost using the CEF
    adjusted_cost = base_cost * CEF;
    
end
