function [] = plot_T_S_space_F35(aircraft)
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

    k = 15; % number of points on the plot

    S_min = 25; %TODO update with actual values
    S_max = 60; % TODO update with actual values

    T_min = 0; % TODO update with actual values
    T_max = 300000; % TODO update with actual values
    
    S = linspace(S_min, S_max, k); %kg per m^2
    T = linspace(T_min, T_max, k); % N

%% FINDING THE COUNTOUR GRID OF TOGW %%

    % Generate meshgrid for T and S
    [S_grid, T_grid] = meshgrid(S, T);
    
    % Initialize TOGW array
    TOGW = zeros(k);
    avg_cost = zeros(k);
    
    % Evaluate TOGW at each point in the grid
    for i = 1:length(S_grid)
        for j = 1:length(T_grid)
            TOGW(i, j) = togw_as_func_of_T_S_calc(aircraft, T_grid(i, j), S_grid(i, j));  % Call your function
            [avg_cost(i, j), ~] = avg_flyaway_cost_calc(TOGW(i,j), 1000);
        end
        fprintf('%d/%d\n', i, k)
    end

    % Plot contour
    %{
    figure();
    hold on;
    contourf(S, T, TOGW, 15);        % plot contours
    colorbar_handle = colorbar;     % Display colorbar
    ylabel(colorbar_handle, 'TOGW (kg)')
    xlabel('S (m^2)')
    ylabel('T (N)')
    title('Contour Plot of TOGW vs T and S')
    hold off;
    %}

%% Calculate constraint curves for distinct functions %%

    % Landing and takeoff
    T_takeoff_field_length = T_from_S_constraint_calc(aircraft, S, @T_W_takeoff_field_length_calc, k);
    S_landing_field_length = S_from_T_constraint_calc(aircraft, T, @W_S_landing_field_length_calc, k);

    % Cruise and dash
    T_cruise = T_from_S_constraint_calc(aircraft, S, @T_W_cruise_calc, k);
    T_dash   = T_from_S_constraint_calc(aircraft, S, @T_W_dash_calc, k);

    % Maneuvers
    T_sustained_turn_09  = T_from_S_constraint_calc(aircraft, S, @T_W_sustained_turn_09_calc, k);
    T_sustained_turn_12  = T_from_S_constraint_calc(aircraft, S, @T_W_sustained_turn_12_calc, k);
    S_instantaneous_turn = S_from_T_constraint_calc(aircraft, T, @W_S_instantaneous_turn_calc, k);

    % Ceiling
    T_ceiling = T_from_S_constraint_calc(aircraft, S, @T_W_ceiling_calc, k);

    % Climb
    T_climb_1 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_1, k); % TODO UPDATE/test with individualized climb calcs
    T_climb_2 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_2, k);
    T_climb_3 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_3, k);
    T_climb_4 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_4, k);
    T_climb_5 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_5, k);
    T_climb_6 = T_from_S_constraint_calc(aircraft, S, @T_W_climb_calc_6, k);

    % Specific excess power
    T_sp_ex_pwr_1 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_1, k); % TODO UPDATE/test with individualized climb calcs
    T_sp_ex_pwr_2 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_2, k);
    T_sp_ex_pwr_3 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_3, k);
    T_sp_ex_pwr_4 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_4, k);
    T_sp_ex_pwr_5 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_5, k);
    T_sp_ex_pwr_6 = T_from_S_constraint_calc(aircraft, S, @T_W_sp_ex_pwr_calc_6, k);
 

    %% PLOT ALL TOGETHER %%
    %%%%%%%%%%%%%%%%%%%%%%%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    % Takeoff and Landing Constraints (Solid Lines - Distinct Colors)
    to = plot(S, T_takeoff_field_length, 'Color', [1 0 0], 'LineStyle', '-', 'LineWidth', 1.2); % Bright Red
    lf = plot(S_landing_field_length, T, 'Color', [1, 0.5, 0], 'LineStyle', '-', 'LineWidth', 1.2); % Bright Orange
    
    % Cruise Constraints (Dashed Lines - Distinct Colors)
    cs = plot(S, T_cruise, 'Color', [0.4940 0.1840 0.5560], 'LineStyle', '--', 'LineWidth', 1.2); % Purple
    ds = plot(S, T_dash, 'Color', [1 0 1], 'LineStyle', '--', 'LineWidth', 1.2); % Magenta
    
    % Maneuver Constraints (Dash-Dot Lines - Distinct Colors)
    m09 = plot(S, T_sustained_turn_09, 'Color', [0 0 1], 'LineStyle', '-.', 'LineWidth', 1.2); % Light Blue
    m12 = plot(S, T_sustained_turn_12, 'Color', [0, 0.75, 0.75], 'LineStyle', '-.', 'LineWidth', 1.2); % Teal
    it  = plot(S_instantaneous_turn, T, 'Color', [0, 0, 0], 'LineStyle', '-.', 'LineWidth', 1.2); % Black
    
    % Climb Constraints (Dotted Lines - Distinct Colors)
    c1 = plot(S, T_climb_1, 'Color', [0.9, 0.6, 0], 'LineStyle', ':', 'LineWidth', 1.2); % Amber
    c2 = plot(S, T_climb_2, 'Color', [0.4, 0.2, 0.6], 'LineStyle', ':', 'LineWidth', 1.2); % Dark Purple
    c3 = plot(S, T_climb_3, 'Color', [0, 0.8, 0.3], 'LineStyle', ':', 'LineWidth', 1.2); % Mint Green
    c4 = plot(S, T_climb_4, 'Color', [0.1, 0.7, 0.7], 'LineStyle', ':', 'LineWidth', 1.2); % Turquoise
    c5 = plot(S, T_climb_5, 'Color', [0.7, 0.1, 0.2], 'LineStyle', ':', 'LineWidth', 1.2); % Reddish Brown
    c6 = plot(S, T_climb_6, 'Color', [0.3, 0.7, 0.3], 'LineStyle', ':', 'LineWidth', 1.2); % Olive Green
    
    % Specific Excess Power Constraints (Dash-Dot Lines, Distinct Colors)
    sp1 = plot(S, T_sp_ex_pwr_1, 'Color', [0.9, 0.4, 0.1], 'LineStyle', '-.', 'LineWidth', 1.2); % Burnt Orange
    sp2 = plot(S, T_sp_ex_pwr_2, 'Color', [0.6, 0.4, 0.8], 'LineStyle', '-.', 'LineWidth', 1.2); % Lavender
    sp3 = plot(S, T_sp_ex_pwr_3, 'Color', [0.4, 0.8, 0.2], 'LineStyle', '-.', 'LineWidth', 1.2); % Lime Green
    sp4 = plot(S, T_sp_ex_pwr_4, 'Color', [0.2, 0.5, 0.7], 'LineStyle', '-.', 'LineWidth', 1.2); % Light Blue-Gray
    sp5 = plot(S, T_sp_ex_pwr_5, 'Color', [0.7, 0.2, 0.4], 'LineStyle', '-.', 'LineWidth', 1.2); % Rose
    sp6 = plot(S, T_sp_ex_pwr_6, 'Color', [0.5, 0.8, 0.2], 'LineStyle', '-.', 'LineWidth', 1.2); % Yellow-Green
    
    % Ceiling Constraint (Solid Line - Unique Color)
    ceil = plot(S, T_ceiling, 'Color', [0.9, 0, 0.5], 'LineStyle', '-', 'LineWidth', 1.2); % Bright Rose
    
    % Add legend
    legend([to, lf, cs, ds, m12, m09, it, c1, c2, c3, c4, c5, c6, ceil, sp1, sp2, sp3, sp4, sp5, sp6], ...
        {'Takeoff field length','Landing field length', ...
        'Cruise', 'Dash', ...
        'Mach 1.2 Sustained Turn', 'Mach 0.9 Sustained Turn', 'Instantaneous Turn', ...
        'Takeoff climb', 'Transition climb', 'Second segment climb', ...
        'Enroute climb', 'Balked landing climb (AEO)', 'Balked landing climb (OEI)', ...
        'Ceiling', ...
        'Sp. Excess Power (1g, SL, Military)', 'Sp. Excess Power (1g, 4500m, Military)', ...
        'Sp. Excess Power (1g, SL, Max)', 'Sp. Excess Power (1g, 4500m, Max)', ...
        'Sp. Excess Power (5g, SL, Max)', 'Sp. Excess Power (5g, 4500m, Max)'});
    
    % Set axes limits and labels
    xlim([S_min S_max]); 
    ylim([T_min T_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T-S Plot for the F-35');
    
    hold off; 

    %% Select our point and update %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    T_selected = aircraft.propulsion.T_max;
    S_selected = aircraft.geometry.wing.S_ref;

        %% PLOT WEIGHT CONTOURS AND CONSTRAINING LINES %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    contourf(S, T, TOGW, 100, 'LineStyle', 'none');        % plot contours
    colorbar_handle = colorbar;     % Display colorbar
    ylabel(colorbar_handle, 'TOGW (kg)')

    % Takeoff and Landing Constraints (Solid Lines - Distinct Colors)
    lf = plot(S_landing_field_length, T, 'Color', [1, 1, 1], 'LineStyle', '-', 'LineWidth', 1.6); % white
    
    sp1 = plot(S, T_sp_ex_pwr_1, 'Color', [1, 1, 1], 'LineStyle', ':', 'LineWidth', 1.6); % white
    sp3 = plot(S, T_sp_ex_pwr_3, 'Color', [1, 1, 1], 'LineStyle', '-.', 'LineWidth', 1.6); % white
     
    tmax = plot(S, ones(1, k).*aircraft.propulsion.T_max, 'Color', [1, 1, 0], 'LineStyle', '--', 'LineWidth', 1.85);
    tmil = plot(S, ones(1, k).*aircraft.propulsion.T_military, 'Color', [1, 0.65, 0], 'LineStyle', '--', 'LineWidth', 1.85);

    s_pt_max = plot(S_selected, T_selected, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); % black circle
    % Create a label with the s and t values
    label = sprintf('(%.1f, %.0f)', S_selected, T_selected);  % Format the label with two decimal places
    text(S_selected + 0.3, T_selected+6000, label, 'BackgroundColor', 'white', 'EdgeColor', 'black', 'FontSize', 9, 'Color', 'k');

    s_pt_mil = plot(S_selected, aircraft.propulsion.T_military, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); % black circle
    % Create a label with the s and t values
    label = sprintf('(%.1f, %.0f)', S_selected, aircraft.propulsion.T_military);  % Format the label with two decimal places
    text(S_selected + 0.3, aircraft.propulsion.T_military+6000, label, 'BackgroundColor', 'white', 'EdgeColor', 'black', 'FontSize', 9, 'Color', 'k');

    % Add legend
    leg = legend([lf, sp3, sp1, tmax, tmil, s_pt_max, s_pt_mil], {'Landing field length', 'Sp. Excess Power (1g, SL, Max)',...
                                          'Sp. Excess Power (1g, SL, Military)', 'P&W F135 Max Thrust', ...
                                          'P&W F135 Military Thrust', 'Selected Design Point, Max Thrust' ...
                                          'Selected Design Point, Military Thrust'});
    
    set(leg, 'Color', [0.9 0.9 0.9]);  % Set legend background to light gray
    set(leg, 'EdgeColor', [0 0 0]);    % Set legend border to black

    % Set axes limits and labels
    xlim([S_min S_max]); 
    ylim([T_min T_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T-S Plot - Constraining Requirements Over TOGW Contours');
    
    hold off; 
    
    %% PLOT COST CONTOURS AND CONSTRAINING LINES %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    contourf(S, T, avg_cost, 100, 'LineStyle','none');        % plot contours
    colorbar_handle = colorbar;     % Display colorbar
    ylabel(colorbar_handle, 'Avg. Flyaway Cost ($ 2024)')

    % Takeoff and Landing Constraints (Solid Lines - Distinct Colors)
    lf = plot(S_landing_field_length, T, 'Color', [1, 1, 1], 'LineStyle', '-', 'LineWidth', 1.6); % white
    
    sp1 = plot(S, T_sp_ex_pwr_1, 'Color', [1, 1, 1], 'LineStyle', ':', 'LineWidth', 1.6); % white
    sp3 = plot(S, T_sp_ex_pwr_3, 'Color', [1, 1, 1], 'LineStyle', '-.', 'LineWidth', 1.6); % white
      
    tmax = plot(S, ones(1, k).*aircraft.propulsion.T_max, 'Color', [1, 1, 0], 'LineStyle', '--', 'LineWidth', 1.85);
    tmil = plot(S, ones(1, k).*aircraft.propulsion.T_military, 'Color', [1, 0.65, 0], 'LineStyle', '--', 'LineWidth', 1.85);

    s_pt_max = plot(S_selected, T_selected, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); % black circle
    % Create a label with the s and t values
    label = sprintf('(%.1f, %.0f)', S_selected, T_selected);  % Format the label with two decimal places
    text(S_selected + 0.3, T_selected+6000, label, 'BackgroundColor', 'white', 'EdgeColor', 'black', 'FontSize', 9, 'Color', 'k');

    s_pt_mil = plot(S_selected, aircraft.propulsion.T_military, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); % black circle
    % Create a label with the s and t values
    label = sprintf('(%.1f, %.0f)', S_selected, aircraft.propulsion.T_military);  % Format the label with two decimal places
    text(S_selected + 0.3, aircraft.propulsion.T_military+6000, label, 'BackgroundColor', 'white', 'EdgeColor', 'black', 'FontSize', 9, 'Color', 'k');

    % Add legend
    leg = legend([lf, sp3, sp1, tmax, tmil, s_pt_max, s_pt_mil], {'Landing field length', 'Sp. Excess Power (1g, SL, Max)',...
                                          'Sp. Excess Power (1g, SL, Military)', 'F110-GE-100 Max Thrust', ...
                                          'F110-GE-100 Military Thrust', 'Selected Design Point, Max Thrust' ...
                                          'Selected Design Point, Military Thrust'});
    
    set(leg, 'Color', [0.9 0.9 0.9]);  % Set legend background to light gray
    set(leg, 'EdgeColor', [0 0 0]);    % Set legend border to black

    % Set axes limits and labels
    xlim([S_min S_max]); 
    ylim([T_min T_max]);
    xlabel('S [m^2]');
    ylabel('T [N]');
    title('T-S Plot: Constraining Requirements Over Cost Contours');
    
    hold off; 

end

   