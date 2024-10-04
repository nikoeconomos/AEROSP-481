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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set constants
    g = 9.80665;
    wing_area_density = aircraft.weight.wing_area_density; % 44 [kg/m^2]

    w_0       = aircraft.weight.togw; % set the w0 to our initial guess calculated earlier
    w_crew    = aircraft.weight.crew;
    w_payload = aircraft.weight.payload;

    % Regression constant, assuming jet fighter, from Raymer table 3.1, conventional metallic structure
    A = 2.11; % unitless parameters, metric
    C = -0.13; % unitless, metric

    TW_design = aircraft.sizing.TW_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM
    WS_design = aircraft.sizing.WS_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM

    epsilon = 10e-3; % error for convergence
    delta   = 2*epsilon; % the amount the we are off from converging

    % DEBUGGING PARAMS
    iteration = 0;
    debug_w0_array = zeros(1, 300);
    it = 1:300;

    %% Start the convergence loop. Based on alg 2, section 4.12 %%
    while delta > epsilon
        % Recalculate S and T design
        S_design    = w_0/WS_design;     % [m2] W / W/S = S
        T_0_design  = (w_0*g)*TW_design; % [kg*m/s2 = N * N/N = [N]] W * T/W = T

        % Recalculate Swet and Swetrest
        S_wet_curr = S_wet_calc(w_0);
        S_wet_rest = S_wet_curr - 2*S_design; % from metabook 4.58

        % Calculate empty weight fraction and empty weight
        empty_weight_fraction = A * w_0^C; % w_e/w_0

        w_e = empty_weight_fraction * w_0; % we/w0 * w0

        % Calculate we and recalculate w0
        w_e = w_e + wing_area_density * (S-S_design); % kg + kg/m^2 * m^2
        w_e = w_e + w_eng_calc(T_0) - w_eng_calc(T_0_design); % kg + kg
        
        % Calculate fuel fraction for this S and T
        ff = ff_total_func_S_calc(aircraft, w_0, S_wet_rest, S, T_0);

        % Update the togw
        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);

        delta = abs(w_0_new-w_0)/abs(w_0_new);

        %%%%%%%%%%%%%%%%
        % DEBUGGING PRINT
        if w_0 < 1 %DEBUG
            disp('W_0 < 1')
        end
        %%%%%%%%%%%%%%%%
        % DEBUGGING PRINT
        if (ff + empty_weight_fraction) > 1
            disp('ff + empty weight frac > 1')
        end
        %%%%%%%%%%%%%%%%%
        % DEBUGGING PRINTS
        if isnan(w_0_new) || isinf(w_0_new) %DEBUG
            error("w_0_new is NaN or Inf at iteration %d", iteration);
        end
        if mod(iteration, 500) == 0 % FOR DEBUGGING
            disp(['delta:',delta])
        end
        %%%%%%%%%%%%%%%%%%


        alpha = 1; % RELAXATION FACTOR
        w_0   = alpha*w_0_new + (1 - alpha)*w_0;
        %w_0 = w_0_new;

        %%%% DEBUGGING %%
        iteration = iteration+1; % FOR DEBUGGING
        debug_w0_array(iteration) = w_0;
        if iteration == 300
            figure();
            plot(it, debug_w0_array)
            disp('plotting');
            break
        end
    end
    
    togw = w_0;
end