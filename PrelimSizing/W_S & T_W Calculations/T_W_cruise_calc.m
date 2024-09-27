% Aerosp 481 Group 3 - Libellula 
function T_W = T_W_cruise_calc(aircraft, W_S)
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

    cruise_mach = aircraft.performance.cruise_speed_mach;    

    AR = aircraft.geometry.AR;
    
    e_cruise = aircraft.aerodynamics.e_cruise; % span efficiency

    CD0_clean = aircraft.aerodynamics.CD0_clean;

    [~,~,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*cruise_mach)^2/2; % Pa

    % Similar to maneuver, but set n=1, 1 g
    T_W = (q*CD0_clean/W_S) + (W_S*(1/(q*pi*AR*e_cruise)));
end