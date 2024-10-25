% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_performance_params()
% Description: This function generates a struct that holds parameters used in
% calculating the initial weight estimate of our aircraft
% 
% 
% INPUTS:
% --------------------------------------------
%    None
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft -struct containing aircraft specifications given by RFP
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/10/2024
%                                  v1.1: 9/15/2024 - Added tentative
%                                  parameters based on the F100-PW-229.

aircraft.name = 'Libellula';

%% OUR DESIGN POINTS

aircraft.performance.TW_design_military = 0.55; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM [N/N]
aircraft.performance.TW_design = 1.05; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM [N/N]
aircraft.performance.WS_design = 525; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM, [N/m^2]

%% loads
aircraft.performance.load_factor.upper_limit = 7; % [g's] with 50% fuel
aircraft.performance.load_factor.lower_limit = -3; % [g's]  with 50% fuel
aircraft.performance.dynamic_pressure_load = 102128.48; %[Pa], 2133 psf in rfp

%% altitude
aircraft.performance.cruise_alt = 10668; % [m]

%% mach numbers
aircraft.performance.mach.cruise = 0.85; % TODO UPDATE --> estimate from online
aircraft.performance.mach.dash = 1.6; % from rfp
aircraft.performance.mach.max_alt = 1.6; %[Mach number], at 35000 feet
aircraft.performance.mach.endurance = 0.4; % estimate from online

%% SUSTAINED TURN
aircraft.performance.mach.max_sustained_turn = 1.2; %[Mach] from RFP
aircraft.performance.mach.min_sustained_turn = 0.9; %[Mach] from RFP

aircraft.performance.bank_angle_360 = deg2rad(60); %[rad] ESTIMATE FROM ONLINE

%% INST TURN

g = 9.8067;

aircraft.performance.max_instantaneous_turn_rate = deg2rad(18); %rad/s
aircraft.performance.corner_speed = 155.556; % m/s, 550 km/hr in raymer page 138

aircraft.performance.n_inst = sqrt( ((aircraft.performance.max_instantaneous_turn_rate*aircraft.performance.corner_speed)/g)^2+1); %raymer 5.19

%% MISC

aircraft.safety_factor = 1.5;

aircraft.service_life = 2000; %[hours]

end