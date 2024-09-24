function T_W = T_W_takeoff_field_length_calc(W_S)
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

factor_of_safety = 1.5; %this is per our RFP requirements and should be used throughout
g = 9.81; %[m/s^2] - gravitational acceleration

CL_max = 1.7; %This was from Cinar to use - estimated from similar aircraft with plain flaps and will be updated once we choose flaps to use

takeoff_distance = 2438.4; %[m] - takeoff distance per RFP

rho_SL = 1.225; %[kg/m^3] - density at sea level
rho = 1.056; %[kg/m^3] - this is bc we want to calculate these values at 4000 ft MSL per RFP

%T_W = (factor_of_safety^2/(g*rho_SL))*(1/((rho/rho_SL)*CL_max*takeoff_distance))*W_S;

T_W = (factor_of_safety^2 / rho)*((W_S)/((rho/rho_SL)*CL_max*takeoff_distance)); % Takeoff distance should be TOP25

end