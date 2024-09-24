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
aircraft = generate_geometry_params(aircraft);
aircraft = generate_drag_polar_params(aircraft);
aircraft = generate_prelim_sizing_params(aircraft);

plot_T_W_W_S_space(aircraft)
drawnow

%%
disp("mission")
aircraft.mission
disp(newline)

%%
disp("weight")
aircraft.weight
disp(newline)

%%
%disp("performance")
%aircraft.performance
disp(newline)

%%
%disp("cost")
%aircraft.cost
%plot_cost_bar_chart(aircraft);

%%
disp(newline)
%disp("propulsion")
%aircraft.propulsion

%%
disp(newline)
%disp("aerodynamics")
%aircraft.aerodynamics
disp(newline)


disp("Sizing complete.")

