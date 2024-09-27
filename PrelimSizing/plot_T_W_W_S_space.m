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
    t = 1.2; % TW limit
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
    TW_climb_arr = T_W_climb_calc(aircraft);

    climb_1_TW = TW_climb_arr(1);
    climb_2_TW = TW_climb_arr(2);
    climb_3_TW = TW_climb_arr(3);
    climb_4_TW = TW_climb_arr(4);
    climb_5_TW = TW_climb_arr(5);
    climb_6_TW = TW_climb_arr(6);
    ceiling_TW = TW_climb_arr(7);


    T_W_climb_1_arr = ones(1, k) .* climb_1_TW; % takeoff
    T_W_climb_2_arr = ones(1, k) .* climb_2_TW; % transition
    T_W_climb_3_arr = ones(1, k) .* climb_3_TW; % second segment
    T_W_climb_4_arr = ones(1, k) .* climb_4_TW; % enroute
    T_W_climb_5_arr = ones(1, k) .* climb_5_TW; % aeo balked landing
    T_W_climb_6_arr = ones(1, k) .* climb_6_TW; % oei balked landing

    T_W_ceiling_arr = ones(1, k) .* ceiling_TW;


    W_S_landing_field_length_arr = ones(1, k) .* W_S_landing_field_length_calc(aircraft);

    W_S_stall_speed_arr = ones(1,k) .* W_S_stall_speed_calc(aircraft, aircraft.environment.rho_SL_45C); % using cruise altitude

    %% Plotting the calculated values %%

    figure('Position', [50, 50, 1000, 800]); % Adjust figure size
    hold on;
    
    to = plot(W_S_space, T_W_takeoff_field_length_arr, 'b',LineWidth=1.2);
    lf = plot(W_S_landing_field_length_arr, T_W_space, 'b',LineWidth=1.2);

    cs = plot(W_S_space, T_W_cruise_arr, 'g',LineWidth=1.2);

    m = plot(W_S_space, T_W_maneuver_arr, 'r',LineWidth=1.2);

    c1 = plot(W_S_space, T_W_climb_1_arr, 'c',LineWidth=1.2);
    c2 = plot(W_S_space, T_W_climb_2_arr, 'c',LineWidth=1.2);
    c3 = plot(W_S_space, T_W_climb_3_arr, 'c',LineWidth=1.2);
    c4 = plot(W_S_space, T_W_climb_4_arr, 'c',LineWidth=1.2);
    c5 = plot(W_S_space, T_W_climb_5_arr, 'c',LineWidth=1.2);
    c6 = plot(W_S_space, T_W_climb_6_arr, 'c',LineWidth=1.2);

    ceil = plot(W_S_space, T_W_ceiling_arr, 'm',LineWidth=1.2);

    ss = plot(W_S_stall_speed_arr, T_W_space, 'y',LineWidth=1.2);
    
    legend([to,lf,cs,m,c1,c2,c3,c4,c5,c6,ceil,ss], ...
        {'Takeoff field length','Landing field length','Cruise', ...
        'Maneuver','Takeoff climb','Transition climb', ...
        'Second segment climb','Enroute climb','Balked landing climb (AEO)', ...
        'Balked landing climb (OEI)','Ceiling','Stall speed'});

    xlim([0 l]); 
    ylim([0 t]);
    xlabel('W/S [kg/m^2]');
    ylabel('T/W [N/N]');
    title('T/W - W/S plot for Libellula''s custom interceptor');

    hold off;   
end