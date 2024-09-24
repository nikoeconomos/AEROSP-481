% Aerosp 481 Group 3 - Libellula 
function [W_S] = W_S_stall_speed_calc(aircraft, alt)
% Description: 
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
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


[~, ~, Rho, ~] = standard_atmosphere_calc(alt);
stall_speed = sqrt(2*aircraft.weight.togw*9.807/(Rho*aircraft.aerodynamics.CL_takeoff*aircraft.aerodynamics.Swet)); %Assume takeoff CL, at takeoff weight, at some higher altitude for buffer
W_S = 0.5*Rho*stall_speed^2*aircraft.aerodynamics.CL_takeoff/9.807;

end