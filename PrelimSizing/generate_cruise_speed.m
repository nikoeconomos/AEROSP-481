% Aerosp 481 Group 3 - Libellula 
function thrust_weight = generate_cruise_speed(aircraft, wing_loading)
% Description: This function generates a thrust to weight ratio based on
% the aircraft struct and wing loading
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    wing_loading for the aircraft
% 
% OUTPUTS:
% --------------------------------------------
%    thrust_weight of the aircraft at cruise speed
%                       
% 
% See also: None
% Author:                          Victoria
% Version history revision notes:
%                                  v1: 9/22/2024

    % Similar to maneuver, but set n=1
    aircraft.aerodynamics.parasitic_drag_coeff_est = aircraft.aerodynamics.skin_friction_coefficient*aircraft.aerodynamics.Swet/(aircraft.aerodynamics.Sref);
    [t,p,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*aircraft.performance.max_sustained_turn_mach)^2/2; % Pa
    n = 1; % For cruise
    thrust_weight = (q*aircraft.aerodynamics.parasitic_drag_coeff_est./wing_loading) + (wing_loading*(n/(q*pi*aircraft.geometry.aspect_ratio*aircraft.aerodynamics.span_efficiency)));

end