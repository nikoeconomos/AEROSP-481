function segment_fuel_fraction = ff_cruise_improved_calc(range, TSFC, velocity, LD)
% Description: from slide 45 of lecture 13
% 
% INPUTS:
% --------------------------------------------
%    range - Double defined in fuel_weight function. Segment/maneuver's range [m] 
% 
%    TSFC - Double defined in section 1 of main.m 
%    Assumed specific fuel consumption for the PW F100-229 engine [kg/(kg*hr)]
% 
%    velocity - Double defined in fuel_weight fucntion after calling 
%    velocity_from_flight_cond function. 
%    Velocity of the aircraft corrected for the segment altitude [m/s]
% 
%    LD -  Double defined in max_lift_to_drag function. 
%    Aircraft lift to drag ratio [unitless]
%
% OUTPUTS:
% --------------------------------------------
%    segment_fuel_fraction - Double. Fuel fraction calculated for mission 
%    segment [unitless]
% 
% See also: fuel_weight(), velocity_from_flight_cond(), max_lift_to_drag(), main.m
% Author:                          Niko
% Version history revision notes:
%                                  v1: 11/3/2024


% TODO MAKE ITERATIVE
g = 9.81;
segment_fuel_fraction = exp( (-range*TSFC*g)/(velocity*LD));

end