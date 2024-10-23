% Aerosp 481 Group 3 - Libellula 
function [togw, ff] = togw_as_func_of_T_S_calc(aircraft, Tin, Sin)
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
    
    itermax = 1000;
    
    % Set constants
    g = 9.80665;
    wing_area_density = aircraft.weight.density.wing_area; % 44 [kg/m^2]

    W_0       = aircraft.weight.togw; % set the w0 to our initial guess calculated earlier
    W_crew    = aircraft.weight.components.crew;
    W_payload = aircraft.weight.components.payload;

    TW_design = aircraft.performance.TW_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM
    WS_design = aircraft.performance.WS_design; % A SPOT WE CHOOSE FROM THE TW-WS DIAGRAM

    epsilon = 1e-4; % error for convergence
    delta   = 2; % the amount the we are off from converging
    iter = 0;

    %% Start the convergence loop. Based on alg 2, section 4.12 %%
    while delta > epsilon && iter < itermax

        % Calculate empty weight fraction and empty weight
        W_e_frac = aircraft.weight.W_e_regression_calc(W_0); % w_e/w_0
        
        % Calculate new empty weight from fraction
        W_e = W_e_frac * W_0; % we/w0 * w0

        % calculate deltas vs the 
        wing_delta   = wing_area_density * (Sin - W_0/(WS_design));
        engine_delta = w_eng_calc(Tin) - w_eng_calc(TW_design*W_0*g); 

        % update W_e and the oew fraction
        W_e = W_e + wing_delta + engine_delta;
        W_e_frac_updated = W_e/W_0;
 
        % Calculate fuel fraction for this S and T
        ff = ff_total_func_S_calc(aircraft, W_0, Sin);

        % Update the togw
        W_0_new = (W_crew + W_payload)/(1 - ff - W_e_frac_updated);

        % Calculate new delta and update W_0
        delta = abs(W_0_new-W_0)/abs(W_0_new);

        alpha = 0.2; % RELAXATION FACTOR
        W_0   = alpha*W_0_new + (1 - alpha)*W_0;

        iter = iter+1;
    end
    
    if isnan(W_0_new) || W_0_new == inf|| iter >= itermax || imag(W_0_new)
        togw = NaN;
        ff = NaN;
        return
    end

    togw = W_0;
end