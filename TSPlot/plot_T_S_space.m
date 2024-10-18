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

%% SET LIMITS %%

    k = 30; % number of points on the plot

    S_min = 20; %TODO update with actual values
    S_max = 60; % TODO update with actual values

    T_min = 0; % TODO update with actual values
    T_max = 250000; % TODO update with actual values
    
    S = linspace(S_min, S_max, k); %kg per m^2
    T = linspace(T_min, T_max, k); % N

%% FINDING THE COUNTOUR GRID OF TOGW %%

    % Generate meshgrid for T and S
    [S_grid, T_grid] = meshgrid(S, T);
    
    % Initialize TOGW array
    TOGW = zeros(k);
    
    % Evaluate TOGW at each point in the grid
    for i = 1:length(S_grid)
        for j = 1:length(T_grid)
            TOGW(i, j) = togw_as_func_of_T_S_calc(aircraft, T_grid(i, j), S_grid(i, j));  % Call your function
        end
        fprintf('%d/%d\n', i, k)
    end

    % Plot contour
    contourf(S, T, TOGW, 15);        % plot contours
    colorbar_handle = colorbar;     % Display colorbar
    ylabel(colorbar_handle, 'TOGW (kg)')

%% Calculate constraint curves for distinct functions %%

    T_takeoff_field_length = T_from_S_constraint_calc(aircraft, S, @T_W_takeoff_field_length_calc, k);
    disp('1/12');

    T_cruise_speed  = T_from_S_constraint_calc(aircraft, S, @T_W_cruise_calc, k);
    disp('2/12');

    T_maneuver      = T_from_S_constraint_calc(aircraft, S, @T_W_maneuver_calc, k);
    disp('3/12');

    T_climb_1       = T_from_S_constraint_calc(aircraft, S, @T_W_climb1_calc, k); % TODO UPDATE/test with individualized climb calcs
    disp('4/12');
    T_climb_2       = T_from_S_constraint_calc(aircraft, S, @T_W_climb2_calc, k);
    disp('5/12');
    T_climb_3       = T_from_S_constraint_calc(aircraft, S, @T_W_climb3_calc, k);
    disp('6/12');
    T_climb_4       = T_from_S_constraint_calc(aircraft, S, @T_W_climb4_calc, k);
    disp('7/12');
    T_climb_5       = T_from_S_constraint_calc(aircraft, S, @T_W_climb5_calc, k);
    disp('8/12');
    T_climb_6       = T_from_S_constraint_calc(aircraft, S, @T_W_climb6_calc, k);
    disp('9/12');

    T_ceiling       = T_from_S_constraint_calc(aircraft, S, @T_W_ceiling_calc, k);
    disp('10/12');

    S_landing_field_length = S_from_T_constraint_calc(aircraft, T, @W_S_landing_field_length_calc, k);
    disp('11/12');

    %% Plotting the calculated constraints %%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    % Takeoff and Landing Constraints
    to = plot(S, T_takeoff_field_length, 'Color', [1, 0, 0], 'LineWidth', 1.0); % Bright Red

    lf = plot(S_landing_field_length, T, 'Color', [1, 0.5, 0], 'LineWidth', 1.0); % Bright Orange
    
    % Cruise Constraint
    cs = plot(S, T_cruise_speed, 'Color', [1, 1, 0], 'LineWidth', 1.0); % Bright Yellow
    
    % Maneuver Constraint
    m = plot(S, T_maneuver, 'Color', [0, 1, 0], 'LineWidth', 1.0); % Bright Green
    
    % Climb Constraints with distinct colors
    c1 = plot(S, T_climb_1, 'Color', [0, 1, 1], 'LineWidth', 1.0);  % Bright Cyan
    c2 = plot(S, T_climb_2, 'Color', [0, 0, 1], 'LineWidth', 1.0);  % Bright Blue
    c3 = plot(S, T_climb_3, 'Color', [1, 0.6, 0], 'LineWidth', 1.0); % Bright Amber
    c4 = plot(S, T_climb_4, 'Color', [0.1, 0.6, 0.8], 'LineWidth', 1.0); % Turquoise
    c5 = plot(S, T_climb_5, 'Color', [0.8, 0.3, 0], 'LineWidth', 1.0); % Orange-red
    c6 = plot(S, T_climb_6, 'Color', [0, 0.8, 0.4], 'LineWidth', 1.0); % Bright Mint Green
    
    % Ceiling Constraint
    ceil = plot(S, T_ceiling, 'Color', [0.9, 0, 0.5], 'LineWidth', 1.0); % Bright Rose
    
    % Add legend
    legend([to,lf,cs,m,c1,c2,c3,c4,c5,c6,ceil], ...
        {'Takeoff field length','Landing field length','Cruise', ...
        'Maneuver','Takeoff climb','Transition climb', ...
        'Second segment climb','Enroute climb','Balked landing climb (AEO)', ...
        'Balked landing climb (OEI)','Ceiling'});

    xlim([S_min S_max]); 
    ylim([T_min T_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T- S plot for Libellula''s custom interceptor');

    hold off;   
end

   