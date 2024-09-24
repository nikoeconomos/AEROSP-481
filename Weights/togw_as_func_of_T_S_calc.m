% Aerosp 481 Group 3 - Libellula 
function [togw, w_e] = togw_as_func_of_T_S_calc(aircraft, T_over_W, W_over_S)
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

    epsilon = 10e-6; % error for convergence
    delta = 2*epsilon; % the amount the we are off from converging

    % generates a the TOGW of our aircraft based on
    % the algorithm given in section 2.5 of the meta guide.
    while delta > epsilon
        empty_weight_fraction = (A * w_0^C); % w_e/w_0
        
        w_e = empty_weight_fraction * w_0;

        w_e = w_e + aircraft.weight.wing_density * (S-S_design);  %What is S vs S design?

        w_e = w_e + w_eng_calc(T_0)-w_eng_calc(T_0_design);

        ff = ff_func_S_calc(S);

        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);

        delta = abs(w_0_new-w_0)/abs(w_0_new);
        w_0 = w_0_new;
    end
    
    togw = w_0;
end