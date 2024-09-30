function [] = plot_T_S_space(aircraft)
% Description: This function generates a plot of T vs S as it
% corresponds to each curve we are plotting for various constraints of flight.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    none
%                       
% 
% See also: generate_prelim_sizing_params.m - required to run prior to this
% script
% Author:                          Niko Economos
% Version history revision notes:
%                                  v1: 9/24/2024

%% Calculate constraint curves for distinct functions %%

    S_min = 10; %TODO update with actual values
    S_max = 100; % TODO update with actual values

    T_min = 0; % TODO update with actual values
    T_max = 300000; % TODO update with actual values

    k = 300; % number of points on the plot
    
    S = linspace(S_min, S_max,k); %kg per m^2
    T = linspace(T_min,T_max, k); % N

    T_takeoff_field_length = T_from_S_constraint_calc(aircraft, S, @T_W_takeoff_field_length_calc);

    to = plot(S, T_takeoff_field_length, 'b',LineWidth=1.2);

    S_landing_field_length = S_from_T_constraint_calc(aircraft,T, @W_S_landing_field_length_calc);

    T_cruise_speed = T_from_S_constraint_calc(aircraft, S, @T_W_cruise_calc);
    T_maneuver = T_from_S_constraint_calc(aircraft, S, @T_W_maneuver_calc);

    T_climb_1 = T_from_S_constraint_calc(aircraft, S, @T_W_climb1_calc); % TODO UPDATE/test with individualized climb calcs
    T_climb_2 = T_from_S_constraint_calc(aircraft, S, @T_W_climb2_calc);
    T_climb_3 = T_from_S_constraint_calc(aircraft, S, @T_W_climb3_calc);
    T_climb_4 = T_from_S_constraint_calc(aircraft, S, @T_W_climb4_calc);
    T_climb_5 = T_from_S_constraint_calc(aircraft, S, @T_W_climb5_calc);
    T_climb_6 = T_from_S_constraint_calc(aircraft, S, @T_W_climb6_calc);

    T_ceiling = T_from_S_constraint_calc(aircraft, S, @T_W_ceiling_calc);

    %S_stall_speed = S_from_T_constraint_calc(aircraft, T, @W_S_stall_speed_calc); DEPRECATED

    %% Plotting the calculated constraints %%

    hold on;
    
    to = plot(S, T_takeoff_field_length, 'b',LineWidth=1.2);
    lf = plot(S_landing_field_length, T, 'b',LineWidth=1.2);

    cs = plot(S, T_cruise_speed, 'g',LineWidth=1.2);

    m = plot(S, T_maneuver, 'r',LineWidth=1.2);

    c1 = plot(S, T_climb_1, 'c',LineWidth=1.2);
    c2 = plot(S, T_climb_2, 'c',LineWidth=1.2);
    c3 = plot(S, T_climb_3, 'c',LineWidth=1.2);
    c4 = plot(S, T_climb_4, 'c',LineWidth=1.2);
    c5 = plot(S, T_climb_5, 'c',LineWidth=1.2);
    c6 = plot(S, T_climb_6, 'c',LineWidth=1.2);

    ceil = plot(S, T_ceiling, 'm',LineWidth=1.2);

    ss = plot(S_stall_speed, T, 'y',LineWidth=1.2);
    
    legend([to,lf,cs,m,c1,c2,c3,c4,c5,c6,ceil,ss], ...
        {'Takeoff field length','Landing field length','Cruise', ...
        'Maneuver','Takeoff climb','Transition climb', ...
        'Second segment climb','Enroute climb','Balked landing climb (AEO)', ...
        'Balked landing climb (OEI)','Ceiling','Stall speed'});

    %xlim([s_min s_max]); 
    %ylim([t_min t_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T- S plot for Libellula''s custom interceptor');

    hold off;   
end

   