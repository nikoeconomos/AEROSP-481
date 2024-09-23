function T_W = T_W_takeoff_field_length_calc(W_S_space(i))
% Description: This function generates a relationship of T/W vs W/S for a
% constraint diagram that is based on our takeoff distance requirement.
% 
% 
% INPUTS:
% --------------------------------------------
%    W_S - wing loading array
%    
% 
% OUTPUTS:
% --------------------------------------------
%    T_W - thrust to weight ratio as an array of values based on W_S array
%                       
% 
% See also: generate_prelim_sizing_params.m 
% script
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/22/2024

factor_of_safety = 1.5; %this is per our RFP requirements and should be used throughout
g = 9.81; %[m/s^2] - gravitational acceleration
rho_SL = 1.225; %[kg/m^3] - density at sea level
CL_max = 2; %This was from Cinar to use - estimated from similar aircraft with plain flaps and will be updated once we choose flaps to use
takeoff_distance = 2438.4; %[m] - takeoff distance per RFP
rho = rho_SL; %[kg/m^3] - this is bc we want to calculate these values at sea level per RFP

T_W = (factor_of_safety^2/(g*rho_SL))*(1/((rho/rho_SL)*CL_max*takeoff_distance))*W_S_space;

end