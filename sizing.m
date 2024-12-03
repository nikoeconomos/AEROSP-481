% Aerosp 481 Group 3 - Libellula 
% main file
clear;
clc;
close all;

%% POPULATE INITIAL AIRCRAFT STRUCTS %%

aircraft = generate_performance_params();
aircraft = generate_DCA_mission(aircraft);

aircraft = generate_init_weight_params(aircraft);
aircraft = generate_prop_params(aircraft);

aircraft = generate_CL_params(aircraft);
aircraft = generate_aerodynamics_params(aircraft);

aircraft = generate_init_weight_params(aircraft); % run again for better estimate

aircraft = generate_climb_segments(aircraft);

% INPUT F35 PARAMETERS IF DESIRED
% aircraft = generate_F35_params(aircraft);

%% GENERATE PRELIMINARY SIZINCAG PLOTS %%

%plot_T_W_W_S_space(aircraft)


% plot_T_S_space(aircraft)
% plot_T_S_space_F35(aircraft)
% [togw, ff] = togw_as_func_of_T_S_calc(aircraft, aircraft.propulsion.T_max, aircraft.geometry.wing.S_ref)

%% REFINE SIZING

aircraft = generate_component_weights(aircraft);
% aircraft = generate_LG_params(aircraft);

aircraft = generate_REFINED_drag_polar_params(aircraft);
% plot_drag_polar(aircraft);

plot_V_n_diagram(aircraft);


%% FIND AIRCRAFT COST

aircraft = generate_cost_params(aircraft);
% plot_cost_pie_chart(aircraft);


%% PRINT %%

aircraft;

disp(newline)

disp("Sizing complete.")
