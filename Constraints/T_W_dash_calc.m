% Aerosp 481 Group 3 - Libellula 
function T_W = T_W_dash_calc(aircraft, W_S)
% Description: This function generates a thrust to weight ratio based on
% wing loading for cruise. Based on metabook eq 4.34
% 
% 
% INPUTS:
% --------------------------------------------
%    wing_loading for the aircraft
% 
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

    g = 9.8067;

    AR = aircraft.geometry.AR;
    e = aircraft.aerodynamics.e_supersonic; % span efficiency

    CD0_clean = aircraft.aerodynamics.CD0_clean;

    dash_mach = aircraft.performance.dash_mach;
    [~,~,rho,~] = standard_atmosphere_calc(10668); %35000ft = 10668m
    dash_velocity = velocity_from_flight_cond(dash_mach, 10668); %35000 ft

    n = 1; % straight and level flight

    %% Calculate

    q = rho*(dash_velocity)^2/2; % Pa
    T_W = q*CD0_clean/(W_S*g) + (n^2/(q*pi*AR*e))* (W_S*g);
end