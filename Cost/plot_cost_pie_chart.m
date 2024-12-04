function [aircraft] = plot_cost_pie_chart(aircraft)
% Description: This function makes a pie chart displaying the cost
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
% Author:                          Victoria
%
% Version history revision notes: 
%                                  11/15/24


%% IOC %%

w = aircraft.weight;
W_cargo = w.components.payload;
tb = block_time_calc(aircraft);
CEF = 2.0852; % Base year 1989, target year 2024 - in generate_cost_params

Cost_cargo = 131.08 * (W_cargo / (2000 * tb)) * CEF;
IOC = Cost_cargo;

%% COC %%

Cost_crew = aircraft.cost.crew;
Cost_fuel = 4.7673e+03; % NEED TO PARAMETRIZE - in generate_cost_params
Cost_oil = 137.7898; % NEED TO PARAMETRIZE - in generate_cost_params
Engine_maint = 722.3120; % NEED TO PARAMETRIZE - in generate_cost_params

COC = Cost_crew + Cost_fuel + Cost_oil + Engine_maint;

%% FOC %%

% This must be fixed!
%{
Cost_unit = mean(aircraft.cost.avg_flyaway_cost); % Average cost for one aircraft
K_depreciation = 0.1; % Typical - from metabook chapter 3
n = 25; % Number of years aircraft is used - Estimated

U_annual = 1.5e3 * ((3.4546 * tb) + 2.994 - ((12.289*tb^2)-(5.6626*tb)+8.964)^0.5);

Cost_insurance = aircraft.cost.insurance;
Cost_financing = 0.07; % From Raymer - should be 7% of DOC
Cost_depreciation = (Cost_unit * (1 - K_depreciation) * tb) / (n * U_annual);

FOC = Cost_insurance + Cost_financing + Cost_depreciation;
%}

FOC = 0; %placeholder TODO REMOVE

%% DOC %%

DOC = COC + FOC;

%% TOC %%

TOC = IOC + DOC;

%% Plotting %%

% Color Palette
custom_colormap1 = [
 0.078, 0.098, 0.118; % Dark shade
 0.157, 0.208, 0.235; % Light shade
 0.941, 0.953, 0.957; % Gray
];
custom_colormap2 = [
 0.157, 0.208, 0.235; % Light shade
 0.941, 0.953, 0.957; % Gray
];

% First Pie Chart: Cost Breakdown
figure;
data = [IOC, DOC, TOC]; % Use struct notation
labels = {'IOC', 'DOC', 'TOC'}; 

% Create pie chart
p1 = pie(data, labels);

% Manually set colors for pie slices
for k = 1:2:length(p1)
    p1(k).FaceColor = custom_colormap1(ceil(k/2), :);
end

title("Cost Breakdown");

% Second Pie Chart: DOC Breakdown
figure;
DOC_data = [FOC, COC]; % Use struct notation
DOC_labels = {'FOC', 'COC'}; 

% Create pie chart
p2 = pie(DOC_data, DOC_labels);

% Manually set colors for pie slices
for k = 1:2:length(p2)
    p2(k).FaceColor = custom_colormap2(ceil(k/2), :);
end

title("DOC Breakdown");

%% Displaying Costs %%

disp(['The IOC is ', num2str(IOC)])
disp(['The COC is ', num2str(COC)])
disp(['The FOC is ', num2str(FOC)])
disp(['The DOC is ', num2str(DOC)])
disp(['The TOC is ', num2str(TOC)])

end