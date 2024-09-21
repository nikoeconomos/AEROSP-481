function aircraft = plot_maneuver_constraint(aircraft)
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
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with prelim sizing
%    parameters
%                       
% 
% See also: generate_prelim_sizing_params.m - required to run prior to this
% script
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 9/21/2024

    aircraft.aerodynamics.wing_loading_maneuver = linspace(0,250,250); %psf
    aircraft.aerodynamics.wing_loading_maneuver_psi = aircraft.aerodynamics.wing_loading_maneuver/12^2; %psi, for calculations
    aircraft.aerodynamics.parasitic_drag_coeff_est = aircraft.aerodynamics.skin_friction_coefficient*aircraft.aerodynamics.Swet./(aircraft.weight.togw./aircraft.aerodynamics.wing_loading_maneuver_psi);
    [t,p,rho,a] = standard_atmosphere_calc(10668); %35000ft = 10668m
    q = rho*(a*aircraft.performance.max_sustained_turn_mach)^2/2; % Pa
    q = q*0.000145; %psi
    aircraft.aerodynamics.thrust_weight_maneuver = q*aircraft.aerodynamics.parasitic_drag_coeff_est./aircraft.aerodynamics.wing_loading_maneuver_psi + (aircraft.performance.max_sustained_g_force^2/(q*pi*aircraft.geometry.aspect_ratio*aircraft.aerodynamics.span_efficiency))*aircraft.aerodynamics.wing_loading_maneuver_psi;
    plot(aircraft.aerodynamics.wing_loading_maneuver,aircraft.aerodynamics.thrust_weight_maneuver);
    title('T/W vs W/S plot for maneuver requirement');
    xlabel('W/S (psi)'); ylabel('T/W');

end