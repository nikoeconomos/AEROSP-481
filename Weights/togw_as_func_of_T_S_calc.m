% Aerosp 481 Group 3 - Libellula 
function [togw, w_e] = togw_as_func_of_T_S_calc(aircraft, T_0, S)
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

    g = 9.80665;
    wing_density = aircraft.weight.wing_density;

    w_0 = aircraft.weight.togw; % set the w0 to our initial guess calculated earlier
    w_crew = aircraft.weight.crew;
    w_payload = aircraft.weight.payload;

    % Regression constant, assuming jet fighter.
    % Pulled from Raymer table 3.1, assuming conventional metallic structure will be used
    A = 2.11; % unitless parameters, metric
    C = -0.13; % unitless, metric

    TW_design = aircraft.sizing.TW_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM
    WS_design = aircraft.sizing.WS_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM

    epsilon = 10e-6; % error for convergence
    delta = 2*epsilon; % the amount the we are off from converging

    % generates a the TOGW of our aircraft based on
    % the algorithm given in section 2.5 of the meta guide.
    k = 0;
    while delta > epsilon

        k = k+1;

        S_design = w_0/WS_design; %[m2]
        T_0_design = (w_0*g)*TW_design; % [kg*m/s2 = N * N/N = [N]]

        S_wet_curr = S_wet_calc(w_0);
        S_ref_curr = S_ref_from_S_wet_calc(aircraft, S_wet_curr);
        S_wet_rest = S_wet_curr - 2*S_ref_curr; % from metabook 4.58

        empty_weight_fraction = A * w_0^C; % w_e/w_0
        
        w_e = empty_weight_fraction * w_0;

        w_e = w_e + wing_density * (S-S_design);  %What is S vs S design?
        w_e = w_e + w_eng_calc(T_0)-w_eng_calc(T_0_design);
    
        ff = ff_total_func_S_calc(aircraft, w_0, S_wet_rest, S, T_0);

        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);

        delta = abs(w_0_new-w_0)/abs(w_0_new);

        if mod(k, 500) == 0
            disp(delta)
        end
        
        if abs(delta-0.3304) < 0.00001
            disp(delta)
        end

        w_0 = w_0_new;
    end
    
    togw = w_0;
end