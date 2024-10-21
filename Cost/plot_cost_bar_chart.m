function [] = plot_cost_bar_chart(aircraft)
% Description: This function makes a bar chart displaying the cost
% breakdown of different cost values and categories
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes: 9/24/24
%    

% Define the cost components and their corresponding prices
cost_names = {'Propulsion', 'Crew', 'Labor', 'Airframe Maintenance', 'Missile', 'Avionics', 'Cannon'};
cost_values = [aircraft.cost.propulsion.total, aircraft.cost.crew.crew_cost, 0, ...
               aircraft.cost.airframe.maint_cost, aircraft.cost.missile.total, aircraft.cost.avionics.cost_2024, ...
               aircraft.cost.cannon.cost_2024];

% Create a bar chart
figure;
bar(cost_values);

% Set the labels for the x-axis
set(gca, 'XTickLabel', cost_names);

% Add labels and title
xlabel('Cost Components');
ylabel('Price ($)');
title('Aircraft Cost Breakdown');

% Rotate x-axis labels for better visibility (optional)
xtickangle(45);

% Display grid for clarity
grid on;

end