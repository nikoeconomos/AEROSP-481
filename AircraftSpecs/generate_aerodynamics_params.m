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

aircraft.aerodynamics.CD_parabolic_drag_polar_calc = @(CD0, CL, e) CD0 + CL^2/(pi * aircraft.geometry.wing.AR * e); %metabook 4.7

aircraft.aerodynamics.CD0_calc = @(S_wet, S) aircraft.aerodynamics.Cf * (S_wet / S); % metabook 4.8

aircraft.aerodynamics.LD_max_calc = @ (e, CD0) 0.5*sqrt((pi*e*aircraft.geometry.wing.AR)/CD0); % metabook 2.15

aircraft.aerodynamics.k_calc = @(e) 1/(pi*aircraft.geometry.wing.AR*e); % standard

aircraft.aerodynamics.CL_from_CD0_calc = @(CD0, k) sqrt(CD0 / k); % 4.12.1 algorithm 3

aircraft.aerodynamics.LD_from_CL_and_CD0_calc = @ (CL, CD0, k) CL/(CD0 + k * CL^2);  % 4.12.1 algorithm 3

aircraft.aerodynamics.LD_cruise_from_CL_and_CD0_calc = @ (CL, CD0, k) 0.943 * aircraft.aerodynamics.LD_from_CL_and_CD0_calc(CL, CD0, k);


%% Drag polar %%
%%%%%%%%%%%%%%%%

aircraft.aerodynamics.LD.max = aircraft.aerodynamics.LD.max_clean/0.943; % next to eq 2.15 in metabook
aircraft.aerodynamics.LD.dash = 0.93 * aircraft.aerodynamics.LD.max_clean; 

aircraft = generate_drag_polar_params(aircraft, 0.0219); %intial guess of CD0

%% Efficiencies (not oswald)

aircraft.aerodynamics.eta.wing  = 0.97; % wing efficiency (NOT OSWALD): usually 0.97 from metabook
aircraft.aerodynamics.eta.htail = 0.8;  % tail efficiency: taking into account downwash from metabook
>>>>>>> main

%% AR wetted (STORES IN GEOMETRY)

%aircraft.geometry.AR_wetted = (aircraft.aerodynamics.LD.max/14)^2 ; % from raymer new edition pg 40, for military aircraft, KLD = 14

%% Stall Speed at takeoff 

aircraft.environment.rho_SL_15C = 1.225; %[kg.m^3]  % 15 degrees celsius, sea level
aircraft.environment.rho_SL_30C = 1.1644; % [kg/m^3] % 45 degrees celsius, sea level. Calculated from an online calc
aircraft.environment.rho_4000ft_30C = 1.013054; % kg/m3

aircraft.performance.max_alt = 15240; %[m], got this from f35 guess (50,000 feet). Needs to be updated with our actual max altitude. TOD UPDATE

[~, ~, rho_max_alt, ~] = standard_atmosphere_calc(aircraft.performance.max_alt);
aircraft.environment.rho_max_alt = rho_max_alt;

end