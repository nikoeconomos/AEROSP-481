function [T_W] = T_W_sustained_turn_09_calc(aircraft, W_S)
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

    AR = aircraft.geometry.wing.AR;
    e = aircraft.aerodynamics.e.supersonic;

    turn_mach = aircraft.performance.mach.min_sustained_turn; % mach 1.2
    [~, ~, rho, ~] = standard_atmosphere_calc(10668); %35000ft = 10668m
    turn_velocity = velocity_from_flight_cond(turn_mach, 10668); %35000 ft

    n = 1/cos(aircraft.performance.bank_angle_360); %raymer 5.19

    CD0_clean = aircraft.aerodynamics.CD0.clean;

%% calculation
    q   = rho*(turn_velocity)^2/2; % Pa
    T_W = q*CD0_clean/(W_S*g) + (n^2/(q*pi*AR*e))* (W_S*g);
end