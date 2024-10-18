function T_W = T_W_takeoff_field_length_calc(aircraft, W_S)
% Description: This function generates a relationship of T/W vs W/S for a
% constraint diagram that is based on our takeoff distance requirement. The
% function takes in a W/S value and will output a single T/W value.
% 
% 
% INPUTS:
% --------------------------------------------
%    W_S - wing loading value
%    
% 
% OUTPUTS:
% --------------------------------------------
%    T_W - thrust to weight ratio
%                       
% 
% See also: generate_prelim_sizing_params.m 
% script
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/22/2024

% Your original code here
safety_factor = aircraft.safety_factor; % this is per our RFP requirements and should be used throughout

CL_max = aircraft.aerodynamics.CL_takeoff_flaps; %This was from Cinar to use - estimated from similar aircraft with plain flaps and will be updated once we choose flaps to use

takeoff_distance = 2438.4; %[m] - takeoff distance per RFP VERIFY

rho_SL_45C = aircraft.environment.rho_SL_45C; %[kg/m^3]
[~,~, rho_1219_MSL, ~] = standard_atmosphere_calc(1219.2); %[kg/m^3] - calculating this at 4000 ft MSL, 1219.2 m, per RFP

T_W = (safety_factor^2 / rho_1219_MSL)*((W_S)/((rho_1219_MSL/rho_SL_45C)*CL_max*takeoff_distance)); % Takeoff distance should be TOP25

%T_W = (factor_of_safety^2/(g*rho_SL))*(1/((rho/rho_SL)*CL_max*takeoff_distance))*W_S;
end