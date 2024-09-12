% Aerosp 481 Group 3 - Libellula 
function [togw_DCA, togw_PDI, togw_ESCORT] = togw_calculation(weight_params,constants)
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

    w_0_guess = weight_params.w_0_guess; % initial guess for the takeoff weight (TOGW)
    w_crew = weight_params.w_crew;
    w_payload = weight_params.w_payload;

    A = weight_params.a_jet_fighter; % unitless parameters
    C = weight_params.c_jet_fighter;
    
    % run the loop three times, one for each mission. The fuel fraction
    % changes, nothing else does.
    togw_DCA = togw_regression_loop(w_0_guess, w_crew, w_payload, A, C, "DCA",constants);
    togw_PDI = togw_regression_loop(w_0_guess, w_crew, w_payload, A, C, "PDI",constants);
    togw_ESCORT = togw_regression_loop(w_0_guess, w_crew, w_payload, A, C, "ESCORT",constants);
end

%%

function togw = togw_regression_loop(w_0_guess, w_crew, w_payload, A, C, mission,constants)
% Description: This function generates a the TOGW of our aircraft based on
% the algorithm given in section 2.5 of the meta guide.
% 
% INPUTS:
% --------------------------------------------
%    w_0_guess - initial guess for the TOGW [lbs]
%    w_crew - weight of crew on board, from the weight params struct [lbs]
%    w_payload - weight of payload on board, from the weight params struct [lbs]
%    A - unitless parameter from Raymer table 3.1
%    C - unitless parameter from Raymer table 3.1
%    mission - a string that indicates the type of mission run to distinguish when calculating fuel fraction
% 
% OUTPUTS:
% --------------------------------------------
%    togw_DCA - TOGW for the input configuration [lbs]
% 
% See also: None
% Author:                          Niko/Victoria
% Version history revision notes:
%                                  v1: 9/10/2024
    w_0 = w_0_guess;
    
    if mission == "DCA"
        mission_struct = generate_DCA_mission(constants.r_air);
    elseif mission == "PDI"
        mission_struct = generate_PDI_mission(constants.r_air);
    else % mission must equal escort
        mission_struct = generate_ESCORT_mission(constants.r_air);
    end

    epsilon = 10e-6; % error for convergence
    delta = 2*epsilon; % the amount the we are off from converging

    while delta > epsilon
        empty_weight_fraction = (A * w_0^C); % w_e/w_0
        
        % Calculates the fuel fraction depending on which mission we are
        % attempting to do calculations for. This is input in the calling function
        if mission == "DCA"
            ff = DCA_fuel_fraction_calc(mission_struct,lift_to_drag_calc,cruise_fuel_fraction_calc,loiter_fuel_fraction_calc);
        elseif mission == "PDI"
            ff = PDI_fuel_fraction_calc(mission_struct,lift_to_drag_calc,cruise_fuel_fraction_calc,loiter_fuel_fraction_calc);
        else % mission must equal escort
            ff = ESCORT_fuel_fraction_calc(mission_struct,lift_to_drag_calc,cruise_fuel_fraction_calc,loiter_fuel_fraction_calc);
        end

        w_0_new = (w_crew + w_payload)/(1 - ff - empty_weight_fraction);
        delta = abs(w_0_new-w_0)/abs(w_0_new);
        w_0 = w_0_new;
    end
    
    togw = w_0;
end