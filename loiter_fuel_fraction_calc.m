function [segment_fuel_fraction] = loiter_fuel_fraction_calc(segment_endurance,SFC,LD)
% Description: This function calculates the fuel fraction for a given
% loiter time when steady flight can be assumed. It uses equation 2.8 from the 
% metabook meant to calculate loiter fuel fraction
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
% See also: fuel_weight(), max_lift_to_drag(), main.m
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

    segment_fuel_fraction = exp(-segment_endurance*SFC/LD);

end