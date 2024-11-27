function ff_cruise = ff_cruise_improved_calc(aircraft, range, TSFC, velocity, altitude, e, W_curr)
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


g = 9.81;

k = aircraft.aerodynamics.k_calc(e);

CD0 = aircraft.aerodynamics.CD0.cruise;

n = 100;
segment_range = range / n;  % Range of each segment

[~, ~, rho, ~] = standard_atmosphere_calc(altitude);

ff_segments = zeros(1,n);
% Loop over each segment
for i = 1:n
    CL = (2 * W_curr * g / (rho * velocity^2 * aircraft.geometry.wing.S_ref)); 

    LD = aircraft.aerodynamics.LD_from_CL_and_CD0_calc(CL, CD0, k);
    
    ff_segments(i) = exp((-segment_range * (TSFC * g) ) / (velocity * LD));

    W_curr = ff_segments(i)*W_curr;
end

ff_cruise = 1;
for i = 1:length(ff_segments) %start at the second index
    ff_cruise = ff_cruise*ff_segments(i);
end

%old_ff = exp( (-range*TSFC*g)/(velocity*aircraft.aerodynamics.LD_cruise_from_CL_and_CD0_calc(aircraft.aerodynamics.CL.cruise, CD0, k)));

end