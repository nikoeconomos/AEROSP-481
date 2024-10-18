function [] = plot_T_W_W_S_space(aircraft)
% Description: This function generates a plot of T/W vs W/S as it
% corresponds to each curve we are plotting for various segments of flight.
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
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 9/21/2024

    l = 1000; % wing loading limit - want this to cover up to 750 kg/m^2
    t = 1.5; % TW limit
    k = 300; % number of points on the plot

    W_S_space =  linspace(0,l,k); %kg per m^2
    T_W_space =  linspace(0,t,k); %kg per m^2

    T_W_cruise_arr = zeros(1,k);
    T_W_takeoff_field_length_arr = zeros(1,k);
    T_W_maneuver_arr = zeros(1,k);

    for i = 1:k
        T_W_takeoff_field_length_arr(i) = T_W_takeoff_field_length_calc(aircraft, W_S_space(i));

        T_W_cruise_arr(i) = T_W_cruise_calc(aircraft, W_S_space(i));

        T_W_maneuver_arr(i) = T_W_maneuver_calc(aircraft, W_S_space(i));
    end

    % climb calculations
    T_W_climb_arr = T_W_climb_general_calc(aircraft, NaN); % does not depend on W_S

    climb_1_T_W = T_W_climb_arr(1);
    climb_2_T_W = T_W_climb_arr(2);
    climb_3_T_W = T_W_climb_arr(3);
    climb_4_T_W = T_W_climb_arr(4);
    climb_5_T_W = T_W_climb_arr(5);
    climb_6_T_W = T_W_climb_arr(6);

    ceiling_T_W = T_W_ceiling_calc(aircraft, NaN); % does not depend on W_S

    T_W_climb_1_arr = ones(1, k) .* climb_1_T_W; % takeoff
    T_W_climb_2_arr = ones(1, k) .* climb_2_T_W; % transition
    T_W_climb_3_arr = ones(1, k) .* climb_3_T_W; % second segment
    T_W_climb_4_arr = ones(1, k) .* climb_4_T_W; % enroute
    T_W_climb_5_arr = ones(1, k) .* climb_5_T_W; % aeo balked landing
    T_W_climb_6_arr = ones(1, k) .* climb_6_T_W; % oei balked landing

    T_W_ceiling_arr = ones(1, k) .* ceiling_T_W;

    W_S_landing_field_length_arr = ones(1, k) .* W_S_landing_field_length_calc(aircraft, NaN); % does not depend on T_W

    %% Plotting the calculated values %%
    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    % Takeoff and Landing Constraints
    to = plot(W_S_space, T_W_takeoff_field_length_arr, 'Color', [1, 0, 0], 'LineWidth', 1.2); % Bright Red
    lf = plot(W_S_landing_field_length_arr, T_W_space, 'Color', [1, 0.5, 0], 'LineWidth', 1.2); % Bright Orange
    
    % Cruise Constraint
    cs = plot(W_S_space, T_W_cruise_arr, 'Color', [1, 1, 0], 'LineWidth', 1.2); % Bright Yellow
    
    % Maneuver Constraint
    m = plot(W_S_space, T_W_maneuver_arr, 'Color', [0, 1, 0], 'LineWidth', 1.2); % Bright Green
    
    % Climb Constraints with distinct colors
    c1 = plot(W_S_space, T_W_climb_1_arr, 'Color', [0, 1, 1], 'LineWidth', 1.2);  % Bright Cyan
    c2 = plot(W_S_space, T_W_climb_2_arr, 'Color', [0, 0, 1], 'LineWidth', 1.2);  % Bright Blue
    c3 = plot(W_S_space, T_W_climb_3_arr, 'Color', [1, 0.6, 0], 'LineWidth', 1.2); % Bright Amber
    c4 = plot(W_S_space, T_W_climb_4_arr, 'Color', [0.1, 0.6, 0.8], 'LineWidth', 1.2); % Turquoise
    c5 = plot(W_S_space, T_W_climb_5_arr, 'Color', [0.8, 0.3, 0], 'LineWidth', 1.2); % Orange-red
    c6 = plot(W_S_space, T_W_climb_6_arr, 'Color', [0, 0.8, 0.4], 'LineWidth', 1.2); % Bright Mint Green
    
    % Ceiling Constraint
    ceil = plot(W_S_space, T_W_ceiling_arr, 'Color', [0.9, 0, 0.5], 'LineWidth', 1.2); % Bright Rose
    
    % Add legend
    legend([to,lf,cs,m,c1,c2,c3,c4,c5,c6,ceil], ...
        {'Takeoff field length','Landing field length','Cruise', ...
        'Maneuver','Takeoff climb','Transition climb', ...
        'Second segment climb','Enroute climb','Balked landing climb (AEO)', ...
        'Balked landing climb (OEI)','Ceiling'});
    
    % Set axes limits and labels
    xlim([0 l]); 
    ylim([0 t]);
    xlabel('W/S [kg/m^2]');
    ylabel('T/W [N/N]');
    title('T/W - W/S plot for Libellula''s custom interceptor');
    
    hold off;

end