function tw = T_W_maneuver_calc(ws)
% Description: This function generates a plot of T/W vs W/S as part of a
% constraint diagram in relation to the maneuvering requirement. If
% desired, assigning this function to the aircraft will add the parasitic
% drag coefficient estimate and arrays for sample W/S values and their
% corresponding minimum T/W requirements.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    ws - inputted wing loading in kg/m2
% 
% OUTPUTS:
% --------------------------------------------
%    tw - outputted thrust to weight constraint
%                       
% 
% See also: generate_prelim_sizing_params.m - required to run prior to this
% script
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 9/21/2024
    ws = ws*9.807; %Pa
    togw = 9005; %kg, based on DCA mission
    Swet = 10^(-.1289)*(togw)^0.7506; %Wetted surface area estimate, ft2
    Swet = Swet*0.092903; %Wetted surface area estimate, m2
    skin_friction_coefficient = 0.0035; % skin friction coefficient estimate
    aspect_ratio = 2.66; %Assumed from F-35
    Sref = 0.75*Swet/aspect_ratio; % Estimated from wetted aspect ratio graph (fig 2.4)
    span_efficiency = 0.85;
    max_sustained_g_force = 3.5;
    max_sustained_turn_mach = 1.2;
    parasitic_drag_coeff_est = skin_friction_coefficient*Swet/(Sref);
    [t,p,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*max_sustained_turn_mach)^2/2; % Pa
    tw = q*parasitic_drag_coeff_est/ws + (max_sustained_g_force^2/(q*pi*aspect_ratio*span_efficiency))*ws;
end