% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_init_weight_params(aircraft)
% Description: This function generates a struct for the weights of aircraft
% using various helper methods
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with weight
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% CREW WEIGHTS %%
%%%%%%%%%%%%%%%%%%

% Number of crew members to include onboard [TODO update if remote piloting]
aircraft.weight.components.crew = 0; % [number]

%% EMPTY WEIGHT %%
%%%%%%%%%%%%%%%%%%

% A guess weight for the start of the togw calculation. The empty weight of an F-35
aircraft.weight.guess = 15000; % [kg]

aircraft.weight.W_e_regression_calc = @ (W_0) 0.882*(ConvMass(W_0,'kg','lbm')^-0.055);

%% PAYLOAD WEIGHTS %%
%%%%%%%%%%%%%%%%%%%%%

% Weight of the missile we are tasked with using, AIM120 327 lb from RFP
aircraft.weight.weapons.num_missiles = 4;
aircraft.weight.weapons.missile = ConvMass(327, 'lbm', 'kg'); %[kg]

% Weight of the cannon we are tasked with using, 275LB from RFP. not part of payload
aircraft.weight.weapons.m61a1.cannon = ConvMass(275, 'lbm', 'kg'); %[kg]

% Weight of the cannon we are tasked with using not ammo weight. 300 lbs from RFP
aircraft.weight.weapons.m61a1.feed_system = ConvMass(300, 'lbm', 'kg'); %[kg]

aircraft.weight.weapons.m61a1.num_rounds = 500;
aircraft.weight.weapons.m61a1.round = ConvMass(0.58, 'lbm', 'kg'); 
aircraft.weight.weapons.m61a1.casing = ConvMass(0.26, 'lbm', 'kg'); 
aircraft.weight.weapons.m61a1.bullet = aircraft.weight.weapons.m61a1.round - aircraft.weight.weapons.m61a1.casing;

aircraft.weight.weapons.m61a1.ammo = aircraft.weight.weapons.m61a1.round*aircraft.weight.weapons.m61a1.num_rounds;

aircraft.weight.weapons.m61a1.total_loaded = aircraft.weight.weapons.m61a1.feed_system + aircraft.weight.weapons.m61a1.cannon + aircraft.weight.weapons.m61a1.ammo;

% Weight of all usable weapons systems aboard. Missile weight*num missiles + weight of cannon ammo
aircraft.weight.components.payload = aircraft.weight.weapons.num_missiles*aircraft.weight.weapons.missile + ...
                          aircraft.weight.weapons.m61a1.feed_system + aircraft.weight.weapons.m61a1.ammo + aircraft.weight.weapons.m61a1.cannon; %aircraft.weight.weapons.m61a1.total_loaded;  %[kg]



%% Initial Weight Calculations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aircraft.weight.ff = ff_total_calc(aircraft);

% INITIAL GUESS, TO BE UPDATED LATER IN PRELIM SIZING
[togw,w_e] = togw_and_w_empty_calc(aircraft);

aircraft.weight.togw = togw;
aircraft.weight.empty = w_e;

aircraft.weight.components.fuel = aircraft.weight.ff*aircraft.weight.togw;

aircraft.weight.PDI_ff = 0.1530;
aircraft.weight.max_landing_weight = 1-(aircraft.weight.PDI_ff/2)* aircraft.weight.togw; % Googled common share of togw that is max landing weight

%% COMPONENT DENSITIES %%
%%%%%%%%%%%%%%%%%%%%%%%%%

aircraft.weight.density.wing_area = 44; % kg/m^2, from Metabook pg 76

aircraft.weight.density.fuel = 802.837; %[kg/m^3] 6.7 lb per gal from RFP

aircraft.weight.density.oil = 1003.55; % kg/m3

end