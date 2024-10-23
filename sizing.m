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

plot_T_W_W_S_space(aircraft)
drawnow

plot_T_S_space(aircraft)
drawnow

aircraft = generate_component_weights(aircraft);
aircraft = generate_aerodynamics_params(aircraft);

aircraft = generate_cost_params(aircraft);

%%
disp("weight")
plot_weight_bar_chart(aircraft);
aircraft.weight

%%
disp("performance")
aircraft.performance

%%
disp("geometry")
aircraft.geometry

%%
%disp("cost")
%aircraft.cost
%plot_cost_bar_chart(aircraft);

%%
disp("propulsion")
aircraft.propulsion

%%
disp("aerodynamics")
aircraft.aerodynamics
disp(newline)

disp("Sizing complete.")

a = aircraft

w0 = a.weight.togw;


tw_des = a.performance.TW_design

tw_mil_des = a.performance.TW_design_military

ws_des = a.performance.WS_design

disp('twreal')
TWmax = a.propulsion.T_max/(w0*9.81)
disp('twreal mil')
TWmil = a.propulsion.T_military/(w0*9.81)
disp('wsreal')
WS = w0/a.geometry.wing.S_ref