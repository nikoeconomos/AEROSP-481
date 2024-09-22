function tw = calculate_maneuver_constraint(aircraft,ws)
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
%    ws - inputted wing loading in Pa
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

    aircraft.aerodynamics.parasitic_drag_coeff_est = aircraft.aerodynamics.skin_friction_coefficient*aircraft.aerodynamics.Swet/(aircraft.weight.togw*9.807/ws);
    [t,p,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*aircraft.performance.max_sustained_turn_mach)^2/2; % Pa
    tw = q*aircraft.aerodynamics.parasitic_drag_coeff_est/ws + (aircraft.performance.max_sustained_g_force^2/(q*pi*aircraft.geometry.aspect_ratio*aircraft.aerodynamics.span_efficiency))*ws;
end