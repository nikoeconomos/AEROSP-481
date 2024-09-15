% Aerosp 481 Group 3 - Libellula 
function [togw, w_empty] = togw_and_w_empty_calc(aircraft)
% Description: This function generates a the TOGW of our aircraft by calling
% another function, togw_regression_loop. It runs the regression loop 3 times for all 
% three missions and returns three separate TOGWs.
% 
% INPUTS:
% --------------------------------------------
%    weight_params - Struct defined in generate_weight_params function.
%    Contains necessary parameters for the calculation.
% 
% OUTPUTS:
% --------------------------------------------
%    togw_DCA - TOGW for DCA [kg]
%    togw_PDI - TOGW for PDI [kg]
%    togw_ESCORT - TOGW for escort mission [kg]
% 
% See also: togw_regression_loop()
% Latest author:                   Niko/Victoria
% Version history revision notes:
%                                  v1: 9/10/2024

    w_0 = aircraft.weight.guess; % set the w0 to our initial guess
    w_crew = aircraft.weight.crew;
    w_payload = aircraft.weight.payload;
    ff = aircraft.weight.ff; % calculate the fuel fraction
 
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
        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);
        delta = abs(w_0_new-w_0)/abs(w_0_new);
        w_0 = w_0_new;
    end
    
    togw = w_0;
    w_empty = empty_weight_fraction*togw;

end