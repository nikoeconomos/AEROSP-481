function [turn_range] = basic_360_turn_distance(flight_velocity,bank_ang)
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

g = 9.81; 

radius = flight_velocity^2/(g*tand(bank_ang));

turn_range = 2*pi*radius;

end