function segment_fuel_fraction = cruise_fuel_fraction_calc(range,SFC,flight_velocity,LD)
% Description: This function calculates the fuel fraction between two mission segments
% where steady flight can be assumed. It uses equation 2.7 from the 
% metabook meant to calculate cruise  fuel fraction
% 
% INPUTS:
% --------------------------------------------
%    range - Double defined in fuel_weight function. Segment/maneuver's range [m] 
% 
%    SFC - Double defined in section 1 of main.m 
%    Assumed specific fuel consumption for the PW F100-229 engine [kg/(kg*hr)]
% 
%    flight_velocity - Double defined in fuel_weight fucntion after calling 
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
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

segment_fuel_fraction = exp(-range*SFC/(flight_velocity*LD));

end