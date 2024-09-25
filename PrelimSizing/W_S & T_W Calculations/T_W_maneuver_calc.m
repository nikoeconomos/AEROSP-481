function [T_W] = T_W_maneuver_calc(aircraft, W_S)
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
    AR = aircraft.geometry.AR;
    
    e_maneuver = aircraft.aerodynamics.e_maneuver;

    n = aircraft.performance.g_force_upper_limit; % load factor, AKA max sustained g force, n
    max_sustained_turn_mach = aircraft.performance.max_sustained_turn_mach;

    CD0_clean = aircraft.aerodynamics.CD0_clean;

    [~,~,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m

%% calculation
    q   = rho*(a*max_sustained_turn_mach)^2/2; % Pa
    T_W = q*CD0_clean/W_S + (n^2/(q*pi*AR*e_maneuver))*W_S;
end