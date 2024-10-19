function [W_S] = W_S_instantaneous_turn_calc(aircraft, T_W)
% Description: This function generates T/W for instatntaneous turns.

%% Define variables
    
    g = 9.8067;
    
    n = ((radial_G/g)^2+1); %raymer 5.19

    CD0_combat = aircraft.aerodynamics.CD0_clean;


%% calculation

    q   = rho*(turn_velocity)^2/2; % Pa
    W_S = q*CD0_clean/(W_S*g) + (n^2/(q*pi*AR*e))* (W_S*g);

end