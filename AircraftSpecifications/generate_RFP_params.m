% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_RFP_params()
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

%% %% %% %% WEIGHTS %% %% %% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CREW WEIGHTS %
%%%%%%%%%%%%%%%%

% Average weight of crew member and carry on luggage given by the metabook. No checked baggage included in this.
aircraft.weight.crew_member = 82; % [kg]

% Number of crew members to include onboard [TODO update if remote piloting]
aircraft.weight.num_crew_members = 0; % [number]

% Total weight of crew members. Crew weight * num of crew members aboard
aircraft.weight.crew = aircraft.weight.num_crew_members*aircraft.weight.w_crew_member; % [kg]

% PAYLOAD WEIGHTS %
%%%%%%%%%%%%%%%%%%%

% Weight of the missile we are tasked with using, 327 lb from RFP
aircraft.weight.aim120 = 148.325; %[kg]

% Number of missiles aboard the plane when taking off
aircraft.weight.num_aim120 = 6; % [number]

% Weight of the cannon we are tasked with using TODO if this value is
% not ammo weight. 300 lbs from RFP
aircraft.weight.m61a1_feed_system = 136.078; %[kg]

% Weight of all usable weapons systems aboard. Missile weight*num missiles + weight of cannon ammo
aircraft.weight.payload = aircraft.weight.num_aim120*aircraft.weight.aim120 + aircraft.weight.m61a1_feed_system; %[kg]

% EMPTY WEIGHT %
%%%%%%%%%%%%%%%%%

% Weight of the cannon we are tasked with using, 275 from RFP
aircraft.weight.m61a1 = 124.738; %[kg]

% A guess weight for the start of the togw calculation. The empty
% weight of an F-35
aircraft.weight.guess = 13290; % [kg]


%% PERFORMANCE %%
%%%%%%%%%%%%%%%%%

% max mach number at altitude
aircraft.performance.mach_max_alt = 1.6; %[Mach number], at 35000 feet

% max mach number at sea level
aircraft.performance.mach_max_SL = NaN; %[Mach number]

% g force limit, upper
aircraft.performance.g_force_upper_limit = 7; % [g's]

% g force limit, upper
aircraft.performance.g_force_lower_limit = -3; % [g's]    

end