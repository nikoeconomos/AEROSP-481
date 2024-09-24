% Aerosp 481 Group 3 - Libellula 
% main file
clear;
clc;
close all;

%Input Parameters

plane_model = input('Enter the type of plane (F35 or c [custom]): ', 's');

% Check if the input matches 'F35' or 'custom'
if strcmpi(plane_model, 'F35')
    aircraft = generate_F35_params();
elseif strcmpi(plane_model, 'custom')
    aircraft = generate_RFP_params();
elseif strcmpi(plane_model, 'c')
    aircraft = generate_RFP_params();
else
    error('Invalid input. Please enter either "F35" or "custom".');
end

mission = input('Enter the type of plane (DCA, PDI, escort): ', 's');

% Check if the input matches expected
if strcmpi(mission, 'DCA')
    aircraft = generate_DCA_mission(aircraft);
elseif strcmpi(mission, 'PDI')
    aircraft = generate_PDI_mission(aircraft);
elseif strcmpi(mission, 'escort')
    aircraft = generate_ESCORT_mission(aircraft);
else
    error('Invalid input. Please enter either "DCA" "PDI" or "escort".');
end

%%

aircraft = generate_weight_params(aircraft);
aircraft = generate_prop_params(aircraft);
aircraft = generate_cost_params(aircraft);
aircraft = generate_aerodynamics_params(aircraft);
aircraft = generate_prelim_sizing_params(aircraft);

plot_T_W_W_S_space(aircraft)
drawnow

%%
disp("mission")
aircraft.mission
disp(newline)
disp("weight")
aircraft.weight
disp(newline)
%disp("performance")
%aircraft.performance
disp(newline)

%%
%{
disp("cost")
aircraft.cost

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
%}

%%
disp(newline)
%disp("propulsion")
%aircraft.propulsion
disp(newline)
%disp("aerodynamics")
%aircraft.aerodynamics
disp(newline)


disp("Sizing complete.")

