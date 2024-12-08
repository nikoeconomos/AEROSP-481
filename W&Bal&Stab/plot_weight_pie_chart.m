function [] = plot_weight_pie_chart(aircraft)
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

%% All pieces %%

%  All pieces, not needed. Use the other two instead

% Define the cost components and their corresponding weights
comp_names = {'Fuel', 'Payload', 'Engine', 'Fuselage', 'Wing', 'Empennage', ...
              'LG', 'Extra', 'GFE'};
comp_weights = [aircraft.weight.components.fuel,  ...
                aircraft.weight.components.payload, ...
                aircraft.weight.components.engine, ...
                aircraft.weight.components.fuselage, aircraft.weight.components.wing, ...
                aircraft.weight.components.htail + aircraft.weight.components.vtail, ...
                aircraft.weight.components.lg, aircraft.weight.components.xtra, ...
                aircraft.weight.components.gfe_total];


% Reorder components to place 'Fuel' and 'Payload' next to each other in the chart
fuel_idx = find(strcmp(comp_names, 'Fuel'));
payload_idx = find(strcmp(comp_names, 'Payload'));

% Ensure "Fuel" and "Payload" are adjacent by swapping if necessary
if payload_idx ~= fuel_idx + 1
    % Swap Payload with the next item if not adjacent to Fuel
    [comp_names{fuel_idx + 1}, comp_names{payload_idx}] = deal(comp_names{payload_idx}, comp_names{fuel_idx + 1});
    [comp_weights(fuel_idx + 1), comp_weights{payload_idx}] = deal(comp_weights(payload_idx), comp_weights(fuel_idx + 1));
    payload_idx = fuel_idx + 1; % Adjust Payload index
end

% Create a pie chart with customized colors
figure;
h = pie(comp_weights);

% Define color map: red for Fuel, orange for Payload, and shades of blue for the remaining components
num_components = length(comp_weights);
blue_shades = [linspace(0.3, 0.7, num_components - 2)', linspace(0.5, 0.9, num_components - 2)', ones(num_components - 2, 1)]; % Shades of blue

% Combine red, orange, and blue shades into a color map
colors = [0.784, 0.275, 0.275;        % Red for Fuel
          0.902, 0.549, 0.275;        % Orange for Payload
          blue_shades];               % Shades of blue for remaining components

% Apply colors to each pie slice
for k = 1:2:length(h) % h contains patches and text labels in alternating positions
    slice_index = (k + 1) / 2; % slice index
    h(k).FaceColor = colors(slice_index, :); % Set the face color
end

% Add labels with component names and weights
for i = 2:2:length(h)
    slice_idx = i / 2;
    h(i).String = sprintf('%s: %.1f kg (%.1f%%)', comp_names{slice_idx}, ...
                          comp_weights(slice_idx), ...
                          100 * comp_weights(slice_idx) / sum(comp_weights));
end

% Add a title
title(['Aircraft Component Weight Breakdown. TOGW: ', num2str(round(aircraft.weight.togw)), ' kg']);


%% OEW, FUEL, PAYLOAD

% Define the main weight categories
fuel_weight = aircraft.weight.components.fuel;
payload_weight = aircraft.weight.components.payload;
oew_weight = sum(comp_weights) - (fuel_weight + payload_weight); % OEW is everything except fuel and payload

% Define names and weights for the simplified breakdown
main_categories = {'Fuel', 'Payload', 'OEW'};
main_weights = [fuel_weight, payload_weight, oew_weight];

% Define colors: red for Fuel, orange for Payload, and darker pale blue for OEW
main_colors = [
    0.50, 0.30, 0.30;  % Muted dark red for Fuel
    0.60, 0.40, 0.30;  % Muted dark orange for Payload
    0.20, 0.30, 0.40;  % Dark bluish-gray (adjusted for more blue)
];

% Create the pie chart
figure;
h_main = pie(main_weights);

% Apply colors to each pie slice
for k = 1:2:length(h_main) % h contains patches and text labels in alternating positions
    slice_index = (k + 1) / 2; % slice index
    h_main(k).FaceColor = main_colors(slice_index, :); % Set the face color
end

% Add labels with component names and weights
for i = 2:2:length(h_main)
    slice_idx = i / 2;
    h_main(i).String = sprintf('%s: %.1f kg (%.1f%%)', main_categories{slice_idx}, ...
                               main_weights(slice_idx), ...
                               100 * main_weights(slice_idx) / sum(main_weights));
end

% Add a title
title(['Fuel, Payload, and OEW Breakdown. TOGW: ', num2str(round(aircraft.weight.togw)), ' kg']);


%% OEW BREAKDOWN 

% Define OEW component names and weights
oew_names = {'Engine', 'Fuselage', 'Wing', 'Empennage', 'LG', 'Extra', 'GFE'};
oew_weights = [aircraft.weight.components.engine, ...
               aircraft.weight.components.fuselage, aircraft.weight.components.wing, ...
               aircraft.weight.components.htail + aircraft.weight.components.vtail, ...
               aircraft.weight.components.lg, aircraft.weight.components.xtra, ...
               aircraft.weight.components.gfe_total];

% Define distinct shades of blue for each OEW component
oew_colors = [
    0.12, 0.17, 0.20;  % Medium dark gray-blue
    0.20, 0.30, 0.35;  % Soft medium blue-gray
    0.30, 0.40, 0.50;  % Muted medium blue
    0.45, 0.55, 0.65;  % Balanced blue-gray
    0.60, 0.70, 0.80;  % Light blue-gray
    0.70, 0.80, 0.90;  % Soft light blue
    0.80, 0.85, 0.95;  % Very light blue-gray
];
% Create the pie chart
figure;
h_oew = pie(oew_weights);

% Apply colors to each pie slice
for k = 1:2:length(h_oew) % h contains patches and text labels in alternating positions
    slice_index = (k + 1) / 2; % slice index
    h_oew(k).FaceColor = oew_colors(slice_index, :); % Set the face color
end

% Add labels with component names and weights
for i = 2:2:length(h_oew)
    slice_idx = i / 2;
    h_oew(i).String = sprintf('%s: %.1f kg (%.1f%%)', oew_names{slice_idx}, ...
                              oew_weights(slice_idx), ...
                              100 * oew_weights(slice_idx) / sum(oew_weights));
end

% Add a title
title('OEW Component Breakdown');



end