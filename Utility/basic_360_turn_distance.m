function [turn_range] = basic_360_turn_distance(bank_ang, mach, alt)
% Description: This function uses a basic equation to calculate the
% distance an aircraft will cover in a 360 degree turn depending on it's
% velocity and its bank angle. It's based on a simple force balance
% equation shown in ref. ___
% 
% INPUTS:
% --------------------------------------------
%    flight_velocity - Double. Flight velocity throughout turn maneuver [m/s]
%
%    bank_ang - Double. Aircraft's bank angle defined as the angle between [0;0;L] and [0;0;-g] in aricraft frame 
%    of reference [degrees]
%
% OUTPUTS:
% --------------------------------------------
%    turn_range - Double. Distance covered during turn with 89 degree bank angle [m]
% 
% See also: generate_DCA_mission(), generate_PDI_mission(), generate_Escort_mission()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

[~, ~, ~, a] = standard_atmosphere_calc(alt);

velocity = a*mach; % Solve for velocity from relationship with mach number and speed of sound

g = 9.81; 

radius = velocity^2/(g*tan(bank_ang));

turn_range = 2*pi*radius;

end