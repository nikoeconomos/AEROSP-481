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
    
    K_takeoff_gear_up   = aero.k_calc(aero.e.takeoff_flaps_slats);  
    K_takeoff_gear_down = aero.k_calc(aero.e.takeoff_flaps_slats); 
    K_landing_gear_up   = aero.k_calc(aero.e.landing_flaps_slats);  
    K_landing_gear_down = aero.k_calc(aero.e.landing_flaps_slats); 
    K_cruise            = aero.k_calc(aero.e.cruise);  
    
    % Make the empty arrays
    C_L_cruise  = linspace(-aero.CL.cruise, aero.CL.cruise, 100);
    C_L_takeoff = linspace(-aero.CL.takeoff_flaps_slats, aero.CL.takeoff_flaps_slats, 100);
    C_L_landing = linspace(-aero.CL.landing_flaps_slats, aero.CL.landing_flaps_slats, 100);

    % Now calculate C_D for each case based on its specific C_L range
    C_D_cruise            = aero.CD0.cruise                    + K_cruise            * C_L_cruise.^2;
    C_D_takeoff_gear_up   = aero.CD0.takeoff_flaps_slats       + K_takeoff_gear_up   * C_L_takeoff.^2;
    C_D_takeoff_gear_down = aero.CD0.takeoff_flaps_slats_gear  + K_takeoff_gear_down * C_L_takeoff.^2;
    C_D_landing_gear_up   = aero.CD0.landing_flaps_slats       + K_landing_gear_up   * C_L_landing.^2;
    C_D_landing_gear_down = aero.CD0.landing_flaps_slats_gear  + K_landing_gear_down * C_L_landing.^2;
    
    % Define a new palette with distinct muted colors
distinct_colors = [
    0.80, 0.40, 0.40;  % Muted reddish tone
    0.40, 0.60, 0.80;  % Muted blue tone
    0.60, 0.80, 0.40;  % Muted green tone
    0.80, 0.60, 0.40;  % Muted orange tone
    0.70, 0.50, 0.80;  % Muted purple tone
];

% Plot of drag polar for each configuration
figure;
hold on;

% Cruise configuration
plot(C_D_cruise, C_L_cruise, 'Color', distinct_colors(1, :), 'LineWidth', 1.5);

% Takeoff configuration with gear up
plot(C_D_takeoff_gear_up, C_L_takeoff, 'Color', distinct_colors(2, :), 'LineWidth', 1.5);

% Takeoff configuration with gear down
plot(C_D_takeoff_gear_down, C_L_takeoff, 'Color', distinct_colors(3, :), 'LineWidth', 1.5);

% Landing configuration with gear up
plot(C_D_landing_gear_up, C_L_landing, 'Color', distinct_colors(4, :), 'LineWidth', 1.5);

% Landing configuration with gear down
plot(C_D_landing_gear_down, C_L_landing, 'Color', distinct_colors(5, :), 'LineWidth', 1.5);

% Add labels, legend, and title
xlabel('C_D');
ylabel('C_L');
title('Drag Polar for Various Flight Configurations');
legend('Cruise', 'Takeoff flaps, gear up', 'Takeoff flaps, gear down', ...
       'Landing flaps, gear up', 'Landing flaps, gear down', 'Location', 'Best');

% Set y-axis limits
ylim([-2.5, 2.5]);

% Turn off hold
hold off;



end