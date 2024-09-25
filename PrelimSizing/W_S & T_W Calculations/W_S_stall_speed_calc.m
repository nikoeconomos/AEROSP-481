% Aerosp 481 Group 3 - Libellula 
function [W_S] = W_S_stall_speed_calc(aircraft, rho)
% Description: 
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    rho - air density of stall conditions (alt, temp, etc)
% 
% OUTPUTS:
% --------------------------------------------
%    W_S
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

% Assume takeoff CL, at takeoff weight, at some higher altitude for buffer
v_stall = sqrt(2 * aircraft.weight.togw * 9.807/(rho * aircraft.aerodynamics.CL_takeoff_flaps * aircraft.geometry.S_wet));

W_S = 0.5 * rho * v_stall^2 * aircraft.aerodynamics.CL_takeoff_flaps/9.807;

end