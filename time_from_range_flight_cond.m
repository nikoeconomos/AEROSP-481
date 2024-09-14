function [time] = time_from_range_flight_cond(range, mach, alt)
% Description: This function calculates the time spent in a segment of a
% flight profile from the distance traveled, the mach number, and the
% altitude of the mission segment
% 
% INPUTS:
% --------------------------------------------
%    range - distance to be traveled in this segment [m]   
% 
%    mach - Double defined in fuel_weight function. 
%    Aircraft Mach number [unitless] 
% 
%    alt - flight altitude for the calculation [m]
%
% OUTPUTS:
% --------------------------------------------
%    time - time spent in this segment [s]
% 
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

[T, P, rho, a] = standard_atmosphere_calc(alt);

time = range/(a*mach); % Solve for velocity from relationship with mach number and speed of sound

end