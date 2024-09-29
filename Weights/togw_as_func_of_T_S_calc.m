% Aerosp 481 Group 3 - Libellula 
function [togw, w_e] = togw_as_func_of_T_S_calc(aircraft, S)
% Description: This function generates a the TOGW of our aircraft. It
% calculates it as a function of T and S.
% 
% INPUTS:
% --------------------------------------------
%    aircraft 
% 
% OUTPUTS:
% --------------------------------------------
%    togw
% 
% Latest author:                   Niko
% Version history revision notes:
%                                  v1: 9/22/2024

    w_0 = aircraft.weight.guess; % set the w0 to our initial guess
    w_crew = aircraft.weight.crew;
    w_payload = aircraft.weight.payload;
    % Regression constant, assuming jet fighter.
    % Pulled from Raymer table 3.1, assuming conventional metallic structure will be used
    A = 2.11; % unitless parameters, metric
    C = -0.13; % unitless, metric
    TW_design = 0.85; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM
    WS_design = 475; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM
    epsilon = 10e-6; % error for convergence
    delta = 2*epsilon; % the amount the we are off from converging
    aircraft.weight.togw = w_0;
    T_0 = 191000; % GUESS
    % generates a the TOGW of our aircraft based on
    % the algorithm given in section 2.5 of the meta guide.
    while delta > epsilon
        S_design = w_0/WS_design;% just plugging in values to test 
        T_0_design = TW_design*w_0*9.807;% just plugging in values to test 
        wing_density = 44;
        empty_weight_fraction = (A * w_0^C); % w_e/w_0
        
        w_e = empty_weight_fraction * w_0;

        w_e = w_e + wing_density * (S-S_design);  %What is S vs S design?
        w_e = w_e + w_eng_calc(T_0)-w_eng_calc(T_0_design);
    
        ff = ff_total_func_S_calc(aircraft,S);

        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);
        disp('Residual:');
        delta = abs(w_0_new-w_0)/abs(w_0_new)
        w_0 = w_0_new;
        aircraft.weight.togw = w_0;
    end
    
    togw = w_0;
end