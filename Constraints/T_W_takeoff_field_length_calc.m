function T_W = T_W_takeoff_field_length_calc(aircraft, W_S)
% Description: This function generates a relationship of T/W vs W/S for a
% constraint diagram that is based on our takeoff distance requirement. The
% function takes in a W/S value and will output a single T/W value.
% 
% 
% INPUTS:
% --------------------------------------------
%    W_S - wing loading value
%    
% 
% OUTPUTS:
% --------------------------------------------
%    T_W - thrust to weight ratio
%                       
% 
% See also: generate_prelim_sizing_params.m 
% script
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/22/2024

CL_max_TO = aircraft.aerodynamics.CL.takeoff_flaps_slats; %This was from Cinar to use - estimated from similar aircraft with plain flaps and will be updated once we choose flaps to use
CD0_TO = aircraft.aerodynamics.CD0.takeoff_flaps_slats_gear;

[~, ~, rho_4000MSL, ~] = standard_atmosphere_calc(1219.2); %[kg/m^3]

BFL = 8000; %[ft] - takeoff distance per RFP, 8000 ft

%% Metabook 4.14

% [~,~, rho_1219_MSL, ~] = standard_atmosphere_calc(1219.2); %[kg/m^3] - calculating this at 4000 ft MSL, 1219.2 m, per RFP
% TOP25 = BFL/37.5;
% T_W = W_S/((rho_1219_MSL/rho_SL_30C)*CL_max_TO*TOP25); % 4.14 metabook

%% Roskam 3.9

W_S_imp = W_S*0.204816; % kg/m2 to lb/ft2

lambda = aircraft.propulsion.bypass_ratio; %

k1 = 0.0447;
k2 = 0.75*(5+lambda)/(4+lambda);
mu_G = 0.2; % ground friction coeff for ice, looked up online

rho_4000MSL_imp = rho_4000MSL*0.062428; %lb/ft^3

numerator = k1 * W_S_imp / (BFL * rho_4000MSL_imp * CL_max_TO) + mu_G + 0.72 * CD0_TO;

% Compute the (X/W)_TO term
T_W = numerator/k2;  % roskam 3.9, done with imperial units

end