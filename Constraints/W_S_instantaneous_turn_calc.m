function [W_S] = W_S_instantaneous_turn_calc(aircraft, T_W)
% Description: This function generates T/W for a given W/S value for the
% aircraft's max sustained turn, mach 1.2. this is derived from equation 4.33
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    ws - inputted wing loading in kg/m2
% 
% OUTPUTS:
% --------------------------------------------
%    T_W - outputted thrust to weight constraint
%                       
% 
% See also: generate_prelim_sizing_params.m - required to run prior to this
% script
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 9/21/2024

%% Define variables

    g = 9.8067;

    CL_combat = aircraft.aerodynamics.CL.combat;

    [~,~,rho,~] = standard_atmosphere_calc(10668); %35000ft = 10668m

    corner_speed = aircraft.performance.corner_speed;

    n = aircraft.performance.n_inst; %calculated in performance

%% calculation

    q   = rho*(corner_speed)^2/2; 
    W_S = q*CL_combat/n; %raymer 5.20

end