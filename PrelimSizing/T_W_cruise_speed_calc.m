% Aerosp 481 Group 3 - Libellula 
function thrust_weight = T_W_cruise_speed_calc(wing_loading)
% Description: This function generates a thrust to weight ratio based on
% wing loading
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

    wing_loading = wing_loading*9.807; % Pa
    TOGW = 9005; % kg based on DCA mission
    Swet = 10^(-.1289)*(TOGW)^0.7506; %Wetted surface area estimate, ft2
    Swet = Swet*0.092903; %Wetted surface area estimate, m2
    skin_friction_coefficient = 0.0035; % skin friction coefficient estimate
    aspect_ratio = 2.66; %Assumed from F-35
    Sref = 0.75*Swet/aspect_ratio; % Estimated from wetted aspect ratio graph (fig 2.4)
    span_efficiency = 0.85;
    cruise_mach = 0.8;    

    % Similar to maneuver, but set n=1
    parasitic_drag_coeff_est = skin_friction_coefficient*Swet/Sref;
    [t,p,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*cruise_mach)^2/2; % Pa
    n = 1; % For cruise
    thrust_weight = (q*parasitic_drag_coeff_est./wing_loading) + (wing_loading*(n/(q*pi*aspect_ratio*span_efficiency)));

end