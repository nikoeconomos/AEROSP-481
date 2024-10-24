function [] = plot_weight_bar_chart(aircraft)
% Description: This function makes a bar chart displaying the weight
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
comp_names = {'Payload', 'Fuel', 'Fuselage', 'Wing', 'Htail', 'Vtail', ...
              'Engine Total', 'LG', 'Xtra'};
comp_weights = [aircraft.weight.components.payload, ...
                aircraft.weight.components.fuel,  ...
                aircraft.weight.components.fuselage, aircraft.weight.components.wing, ...
                aircraft.weight.components.htail, aircraft.weight.components.vtail, ...
                aircraft.weight.components.engine, ...
                aircraft.weight.components.lg, aircraft.weight.components.xtra];

% Create a bar chart
figure;
bar(comp_weights);

% Set the labels for the x-axis
set(gca, 'XTickLabel', comp_names);

% Add labels and title
xlabel('Aircraft Components');
ylabel('Weight (kg)');
title(['Aircraft Component Weight Breakdown. TOGW: ', num2str(round(aircraft.weight.togw)), ' kg']);

% Rotate x-axis labels for better visibility (optional)
xtickangle(45);

% Display grid for clarity
grid on;

end