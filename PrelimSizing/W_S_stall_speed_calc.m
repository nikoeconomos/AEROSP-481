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


[~, ~, Rho, a] = standard_atmosphere_calc(alt);

cruise_speed = a*aircraft.performance.cruise_speed_mach;
stall_speed = cruise_speed/1.25; %from metabook, cruise speed = 1.25 * stall


W_S = 0.5*Rho*stall_speed^2*aircraft.aerodynamics.CL_cruise;

end