function [segment_fuel_fraction] = ff_loiter_improved_calc(endurance,TSFC)
% Description: From slide 56 in lecture
% 
% INPUTS:
% --------------------------------------------
%    segment_endurance - Double defined in fuel_weight function. 
%    Loitering time range [s] 
% 
%    SFC - Double defined in section 1 of main.m 
%    Assumed specific fuel consumption for the PW F100-229 engine [kg/(kg*hr)]
% 
%    LD -  Double defined in max_lift_to_drag function. 
%    Aircraft lift to drag ratio [unitless]
% 
% OUTPUTS:
% --------------------------------------------
%    segment_fuel_fraction - Double. Fuel fraction calculated for mission 
%    segment [unitless]
% 
% Author:                          Niko
% Version history revision notes:
%                                  v1: 11/3/2024


% Calculate new Lift to drag, maximum
% TODO New formula

g = 9.81;
%segment_fuel_fraction = exp( (-endurance*TSFC*g)/LD);

end