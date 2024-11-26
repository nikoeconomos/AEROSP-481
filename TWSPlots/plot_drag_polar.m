function [] = plot_drag_polar(aircraft)
% Description:plots the drag polar for different segments of flight
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
% See also: 
% Author:                          Vienna
% Version history revision notes:

    
    aero = aircraft.aerodynamics;
    
    K_takeoff_gear_up   = aero.k_calc(aero.e.takeoff_flaps);  
    K_takeoff_gear_down = aero.k_calc(aero.e.takeoff_flaps); 
    K_landing_gear_up   = aero.k_calc(aero.e.landing_flaps);  
    K_landing_gear_down = aero.k_calc(aero.e.landing_flaps); 
    K_clean             = aero.k_calc(aero.e.clean);  
    
    % Make the empty arrays
    C_L_clean = linspace(-aero.CL.clean, aero.CL.clean, 100);
    C_L_takeoff = linspace(-aero.CL.takeoff_flaps, aero.CL.takeoff_flaps, 100);
    C_L_landing = linspace(-aero.CL.landing_flaps, aero.CL.landing_flaps, 100);

    % Now calculate C_D for each case based on its specific C_L range
    C_D_clean             = aero.CD0.clean               + K_clean             * C_L_clean.^2;
    C_D_cruise            = aero.CD0.cruise              + K_clean             * C_L_clean.^2;
    C_D_takeoff_gear_up   = aero.CD0.takeoff_flaps       + K_takeoff_gear_up   * C_L_takeoff.^2;
    C_D_takeoff_gear_down = aero.CD0.takeoff_flaps_gear  + K_takeoff_gear_down * C_L_takeoff.^2;
    C_D_landing_gear_up   = aero.CD0.landing_flaps       + K_landing_gear_up   * C_L_landing.^2;
    C_D_landing_gear_down = aero.CD0.landing_flaps_gear  + K_landing_gear_down * C_L_landing.^2;
    
    % Plot of drag polar for each configuration
    figure;
    hold on;
    plot(C_D_clean , C_L_clean, 'Color',[0.8, 0.2, 0.2], 'LineWidth', 1.5);
    plot(C_D_cruise, C_L_clean, 'Color',[0.8, 0.2, 0.8], 'LineWidth', 1.5);
    plot(C_D_takeoff_gear_up,C_L_takeoff, 'Color',[0.6, 0.3, 0.6], 'LineWidth', 2);
    plot(C_D_takeoff_gear_down,C_L_takeoff, 'Color', [0.3, 0.3, 0.8], 'LineWidth', 1.5);
    plot(C_D_landing_gear_up,C_L_landing, 'Color',  [0.3, 0.6, 0.6], 'LineWidth', 1.5);
    plot(C_D_landing_gear_down,C_L_landing, 'Color',  [0.3, 0.8, 0.3], 'LineWidth', 1.5);
    
    % Add labels and legend
    xlabel('Coefficient of Drag (C_D)');
    ylabel('Coefficient of Lift (C_L)');
    title ('Drag Polar for Various Flight Configurations');
    legend('Clean', 'Cruise', 'Takeoff flaps, gear up', 'Takeoff flaps, gear down', ...
           'Landing flaps, gear up', 'Landing flaps, gear down', 'Location', 'Best');
    
    ylim([-2.5,2.5])

    hold off;

end