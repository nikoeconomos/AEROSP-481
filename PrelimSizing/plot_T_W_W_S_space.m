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

    l = 250; % wing loading limit
    t = 2; % TW limit
    k = 250; % number of points on the plot

    W_S_space =  linspace(0,l,k); %kg per m^2
    T_W_space =  linspace(0,t,k); %kg per m^2

    T_W_cruise_speed_arr = zeros(k);
    T_W_takeoff_field_length_arr = zeros(k);
    T_W_maneuver_arr = zeros(k);

    for i = 1:k
        T_W_takeoff_field_length_arr(i) = T_W_takeoff_field_length_calc(W_S_space(i));

        T_W_cruise_speed_arr(i) = T_W_cruise_speed_calc(W_S_space(i));

        T_W_maneuver_arr(i) = T_W_maneuver_calc(W_S_space(i));
    end

    % climb calculations
    [climb_1_TW, climb_2_TW, climb_3_TW, climb_4_TW, climb_5_TW, climb_6_TW] = T_W_climb_calc(aircraft);

    T_W_climb_1_arr = ones(1, k) * climb_1_TW; % takeoff
    T_W_climb_2_arr = ones(1, k) * climb_2_TW; % transition
    T_W_climb_3_arr = ones(1, k) * climb_3_TW; % second segment
    T_W_climb_4_arr = ones(1, k) * climb_4_TW; % enroute
    T_W_climb_5_arr = ones(1, k) * climb_5_TW; % aeo balked landing
    T_W_climb_6_arr = ones(1, k) * climb_6_TW; % oei balked landing

    T_W_ceiling_arr = ones(1, k) * T_W_ceiling_calc();

    W_S_landing_field_length_arr = ones(1, k) * W_S_landing_field_length_calc();

    %% Plotting the calculated values %%

    figure;
    hold on;
    
    plot(W_S_space, T_W_takeoff_field_length_arr);

    plot(W_S_space, T_W_cruise_speed_arr);

    plot(W_S_space, T_W_maneuver_arr);

    plot(W_S_space, T_W_climb_1_arr)
    plot(W_S_space, T_W_climb_2_arr)
    plot(W_S_space, T_W_climb_3_arr)
    plot(W_S_space, T_W_climb_4_arr)
    plot(W_S_space, T_W_climb_5_arr)
    plot(W_S_space, T_W_climb_6_arr)

    plot(W_S_space, T_W_ceiling_arr)

    plot(W_S_landing_field_length_arr, T_W_space)

    legend('Takeoff field length','Cruise','Maneuver','Takeoff climb','Transition climb','Second segment climb',...
            'Enroute climb','Balked landing climb (AEO)','Balked landing climb (OEI)','Ceiling','Landing field length');

    axis equal;
    grid on;
    xlim([0 l]); ylim([0 t]);
    xlabel('W/S [UNITS]');
    ylabel('T/W [UNITS]');
    title('T/W - W/S plot for Libellula''s custom interceptor');

    hold off;   
end