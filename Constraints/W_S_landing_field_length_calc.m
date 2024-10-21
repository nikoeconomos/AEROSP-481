function W_S = W_S_landing_field_length_calc(aircraft, T_W)
% Description: This function generates a W/S  value for a
% constraint diagram that is based on our landing distance requirement.
% Note that this equation is independent of T/W. Also note that the value
% of 80 in the equation below was not assumed, but rather is a part of the
% equation straight from the textbook.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    W_S - a single wing loading value that must be met in order to land in
%    a distance of 8,000 ft (given current CL_max)
%                       
% 
% See also: generate_prelim_sizing_params.m 
% script
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/22/2024

s_land = 2438.4; %[m] which is = 8,000 ft (from RFP)
s_a = 305; %[m] - 1000 ft, commercial aircraft Sa distance according to raymer txtbook (essentially an "error" factor)

rho_SL_30C = aircraft.environment.rho_SL_30C; %[kg/m^3]
[~,~, rho_1219_MSL, ~] = standard_atmosphere_calc(1219.2); %[kg/m^3] - calculating this at 4000 ft MSL, 1219.2 m, per RFP

sigma = rho_SL_30C/rho_1219_MSL;

CL_max = aircraft.aerodynamics.CL_landing_flaps;  

%% Hamburg

kl = .107; %[kg/m^3] - comes from raymer textbook LDG equation

W_S_L = kl*sigma*CL_max*(s_land-s_a); %[kg/m^2]

aircraft = generate_PDI_mission(aircraft);
ff = ff_total_calc(aircraft);

ac_50_fuel = 1-(ff/2);

W_S = W_S_L / ac_50_fuel; % factor of 0.85 is Mlanding/Mtakeoff (90%)

%% Raymer 5.5
%W_S = sigma*CL_max*(s_land-s_a)/5; % raymer 5.5

%% Roskam 3.1

%{
va_kt = sqrt(27000); %kts
vs_kts = va_kt/1.2; %kts
vs_fts = vs_kts*1.688; %ft/s

rho_imp = rho_SL_30C/515.379; %slug/ft^3 from m/kg^3

W_S_L = vs_fts^2*rho_imp*CL_max/2; %ft2/s2*slug/ft3

W_S_TO = W_S_L/0.8;%lb/ft2

W_S = W_S_TO*4.88243; %kg/m2 
%}

end
