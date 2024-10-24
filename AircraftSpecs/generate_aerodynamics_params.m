% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_aerodynamics_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the aerodynamics system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with aerodynamics
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Lift to Drag %%
%%%%%%%%%%%%%%%%%%

aircraft.aerodynamics.Cf = 0.0035; % skin friction coefficient estimate figure 4.4 meta 

%% Functions %%
%%%%%%%%%%%%%%%

aircraft.aerodynamics.CD_parabolic_drag_polar_calc = @(CD0, CL, e) CD0 + CL^2/(pi * aircraft.geometry.AR * e); %metabook 4.7

aircraft.aerodynamics.CD0_calc = @(S_wet, S) aircraft.aerodynamics.Cf * (S_wet / S); % metabook 4.8

aircraft.aerodynamics.LD_max_calc = @ (e, CD0) 0.5*sqrt((pi*e*aircraft.geometry.AR)/CD0); % metabook 2.15

aircraft.aerodynamics.k_calc = @(e) 1/(pi*aircraft.geometry.AR*e); % standard

aircraft.aerodynamics.CL_from_CD0_calc = @(CD0, k) sqrt(CD0 / k); % 4.12.1 algorithm 3

aircraft.aerodynamics.LD_from_CL_and_CD0_calc = @ (CL, CD0, k) 0.94*CL/(CD0 + k * CL^2);  % 4.12.1 algorithm 3


%% Drag polar %%
%%%%%%%%%%%%%%%%

aircraft = generate_drag_polar_params(aircraft);
aircraft.aerodynamics.LD_max = aircraft.aerodynamics.LD_max_cruise/0.943; % next to eq 2.15 in metabook
aircraft.aerodynamics.LD_dash = 0.93 * aircraft.aerodynamics.LD_max_cruise; 

%% AR wetted (STORES IN GEOMETRY)

aircraft.geometry.AR_wetted = (aircraft.aerodynamics.LD_max/14)^2 ; % from raymer new edition pg 40, for military aircraft, KLD = 14

%% Stall Speed at takeoff 

aircraft.environment.rho_SL_15C = 1.225; %[kg.m^3]  % 15 degrees celsius, sea level
aircraft.environment.rho_SL_30C = 1.1644; % [kg/m^3] % 45 degrees celsius, sea level. Calculated from an online calc

aircraft.performance.max_alt = 15240; %[m], got this from f35 guess (50,000 feet). Needs to be updated with our actual max altitude. TOD UPDATE

[~, ~, rho_max_alt, ~] = standard_atmosphere_calc(aircraft.performance.max_alt);
aircraft.environment.rho_max_alt = rho_max_alt;

end