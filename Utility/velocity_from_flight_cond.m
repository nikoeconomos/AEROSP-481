function [velocity] = velocity_from_flight_cond(mach,alt)
% Description: This function calculates the aircraft's velocity from its
% mach number and the flight altitude
% 
% INPUTS:
% --------------------------------------------
%    mach - Double defined in fuel_weight function. 
%    Aircraft Mach number [unitless] 
% 
%    alt - flight altitude for the calculation [m]
%
% OUTPUTS:
% --------------------------------------------
%    velocity - Double. Aircraft velocity at atmospheric conditions [m/s]
% 
% See also: main.m, fuel_weight()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

[~, ~, ~, a] = standard_atmosphere_calc(alt);
velocity = a*mach; % Solve for velocity from relationship with mach number and speed of sound

end