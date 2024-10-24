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

    % Lift coefficient range
    C_L = linspace(-2, 3);  
    
    aero = aircraft.aerodynamics;
    
    C_D0_clean = aero.CD0_clean; % Clean configuration
    C_D0_takeoff_gear_up = aero.CD0_takeoff_flaps_gear;   % Takeoff flaps, gear up
    C_D0_takeoff_gear_down = aero.CD0_takeoff_flaps; % Takeoff flaps, gear down
    C_D0_landing_gear_up = aero.CD0_landing_flaps;   % Landing flaps, gear up
    C_D0_landing_gear_down = aero.CD0_landing_flaps_gear; % Landing flaps, gear down
    
    K_takeoff_gear_up   = aero.k_calc(aero.e_takeoff_flaps);  
    K_takeoff_gear_down = aero.k_calc(aero.e_takeoff_flaps); 
    K_landing_gear_up   = aero.k_calc(aero.e_landing_flaps);  
    K_landing_gear_down = aero.k_calc(aero.e_landing_flaps); 
    K_clean             = aero.k_calc(aero.e_cruise);  
    
    % Clean, cruise
    C_L_clean = linspace(-aero.CL_cruise, aero.CL_cruise, 100);
    
    C_L_takeoff = linspace(-aero.CL_takeoff_flaps, aero.CL_takeoff_flaps, 100);
    
    C_L_landing = linspace(-aero.CL_landing_flaps, aero.CL_landing_flaps, 100);
    


    % Now calculate C_D for each case based on its specific C_L range
    C_D_clean             = C_D0_clean              + K_clean             * C_L_clean.^2;
    C_D_takeoff_gear_up   = C_D0_takeoff_gear_up    + K_takeoff_gear_up   * C_L_takeoff.^2;
    C_D_takeoff_gear_down = C_D0_takeoff_gear_down  + K_takeoff_gear_down * C_L_takeoff.^2;
    C_D_landing_gear_up   = C_D0_landing_gear_up    + K_landing_gear_up   * C_L_landing.^2;
    C_D_landing_gear_down = C_D0_landing_gear_down  + K_landing_gear_down * C_L_landing.^2;
    
    % Plot of drag polar for each configuration
    figure;
    hold on;
    plot(C_D_clean,C_L_clean, 'Color',[0.8, 0.2, 0.2], 'LineWidth', 1.5);
    plot(C_D_takeoff_gear_up,C_L_takeoff, 'Color',[0.6, 0.3, 0.6], 'LineWidth', 2);
    plot(C_D_takeoff_gear_down,C_L_takeoff, 'Color', [0.3, 0.3, 0.8], 'LineWidth', 1.5);
    plot(C_D_landing_gear_up,C_L_landing, 'Color',  [0.3, 0.6, 0.6], 'LineWidth', 1.5);
    plot(C_D_landing_gear_down,C_L_landing, 'Color',  [0.3, 0.8, 0.3], 'LineWidth', 1.5);
    
    % Add labels and legend
    xlabel('Coefficient of Drag (C_D)');
    ylabel('Coefficient of Lift (C_L)');
    title ('Drag Polar for Various Flight Configurations');
    legend('Clean, cruise', 'Takeoff flaps, gear up', 'Takeoff flaps, gear down', ...
           'Landing flaps, gear up', 'Landing flaps, gear down', 'Location', 'NorthWest');
    
    ylim([-2.5,2.5])

    hold off;

end