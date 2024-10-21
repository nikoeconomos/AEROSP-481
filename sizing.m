% Aerosp 481 Group 3 - Libellula 
% main file
clear;
clc;
close all;

%Input Parameters

aircraft = generate_performance_params(); % have yet to implement f35 stuff
aircraft = generate_DCA_mission(aircraft);

%%

aircraft = generate_init_weight_params(aircraft);
aircraft = generate_geometry_params(aircraft);
aircraft = generate_aerodynamics_params(aircraft);
aircraft = generate_init_weight_params(aircraft);
aircraft = generate_prop_params(aircraft);

aircraft = generate_climb_segments(aircraft);

%plot_drag_polar(aircraft);
drawnow

aircraft = generate_component_weights(aircraft);

plot_T_W_W_S_space(aircraft)
drawnow

plot_T_S_space(aircraft)
drawnow

aircraft = generate_aerodynamics_params(aircraft);

aircraft = generate_cost_params(aircraft);

%%
disp(newline)
%disp("mission")
%aircraft.mission
disp(newline)

%%
disp(newline)
%disp("weight")
%aircraft.weight
disp(newline)

%%
disp(newline)
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