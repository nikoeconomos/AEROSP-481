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
    S_max = 80; % TODO update with actual values

    T_min = 0; % TODO update with actual values
    T_max = 300000; % TODO update with actual values

    k = 100; % number of points on the plot
    
    S = linspace(S_min, S_max, k); %kg per m^2
    T = linspace(T_min, T_max, k); % N

    T_takeoff_field_length = T_from_S_constraint_calc(aircraft, S, @T_W_takeoff_field_length_calc, k);

    %to = plot(S, T_takeoff_field_length, 'b',LineWidth=1.2); % DEBUG

    T_cruise_speed  = T_from_S_constraint_calc(aircraft, S, @T_W_cruise_calc, k);
    T_maneuver      = T_from_S_constraint_calc(aircraft, S, @T_W_maneuver_calc, k);

    T_climb_1       = T_from_S_constraint_calc(aircraft, S, @T_W_climb1_calc, k); % TODO UPDATE/test with individualized climb calcs
    T_climb_2       = T_from_S_constraint_calc(aircraft, S, @T_W_climb2_calc, k);
    T_climb_3       = T_from_S_constraint_calc(aircraft, S, @T_W_climb3_calc, k);
    T_climb_4       = T_from_S_constraint_calc(aircraft, S, @T_W_climb4_calc, k);
    T_climb_5       = T_from_S_constraint_calc(aircraft, S, @T_W_climb5_calc, k);
    T_climb_6       = T_from_S_constraint_calc(aircraft, S, @T_W_climb6_calc, k);

    T_ceiling       = T_from_S_constraint_calc(aircraft, S, @T_W_ceiling_calc, k);

    

    %S_landing_field_length = S_from_T_constraint_calc(aircraft, T, @W_S_landing_field_length_calc);

    %S_stall_speed = S_from_T_constraint_calc(aircraft, T, @W_S_stall_speed_calc); DEPRECATED

    %% Finding the grid of TOGW
    
    % Generate meshgrid for T and S
    [S_grid, T_grid] = meshgrid(S, T);
    
    % Initialize TOGW array
    TOGW = zeros(k);
    
    % Evaluate TOGW at each point in the grid
    for i = 1:length(S_grid)
        for j = 1:length(T_grid)
            TOGW(i, j) = togw_as_func_of_T_S_calc(aircraft, T_grid(i, j), S_grid(i, j));  % Call your function
        end
    end
    
    %% Plotting the calculated constraints %%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;

    % Plot contour
    %contour(S, T, TOGW, 20);  % 20 contour levels
    %colorbar;                  % Display colorbar
    
    % Takeoff and Landing Constraints
    to = plot(S, T_takeoff_field_length, 'Color', [1, 0, 0], 'LineWidth', 1.2); % Bright Red
    %lf = plot(W_S_landing_field_length_arr, T_W_space, 'Color', [1, 0.5, 0], 'LineWidth', 1.2); % Bright Orange
    lf = plot(S, T_takeoff_field_length, 'Color', [1, 0, 0], 'LineWidth', 1.2); % Bright Orange
    
    % Cruise Constraint
    cs = plot(S, T_cruise_speed, 'Color', [1, 1, 0], 'LineWidth', 1.2); % Bright Yellow
    
    % Maneuver Constraint
    m = plot(S, T_maneuver, 'Color', [0, 1, 0], 'LineWidth', 1.2); % Bright Green
    
    % Climb Constraints with distinct colors
    c1 = plot(S, T_climb_1, 'Color', [0, 1, 1], 'LineWidth', 1.2);  % Bright Cyan
    c2 = plot(S, T_climb_2, 'Color', [0, 0, 1], 'LineWidth', 1.2);  % Bright Blue
    c3 = plot(S, T_climb_3, 'Color', [1, 0.6, 0], 'LineWidth', 1.2); % Bright Amber
    c4 = plot(S, T_climb_4, 'Color', [0.1, 0.6, 0.8], 'LineWidth', 1.2); % Turquoise
    c5 = plot(S, T_climb_5, 'Color', [0.8, 0.3, 0], 'LineWidth', 1.2); % Orange-red
    c6 = plot(S, T_climb_6, 'Color', [0, 0.8, 0.4], 'LineWidth', 1.2); % Bright Mint Green
    
    % Ceiling Constraint
    ceil = plot(S, T_ceiling, 'Color', [0.9, 0, 0.5], 'LineWidth', 1.2); % Bright Rose
    
    % Add legend
    legend([to,lf,cs,m,c1,c2,c3,c4,c5,c6,ceil], ...
        {'Takeoff field length','Landing field length','Cruise', ...
        'Maneuver','Takeoff climb','Transition climb', ...
        'Second segment climb','Enroute climb','Balked landing climb (AEO)', ...
        'Balked landing climb (OEI)','Ceiling'});

    %xlim([s_min s_max]); 
    %ylim([t_min t_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T- S plot for Libellula''s custom interceptor');

    hold off;   
end

   