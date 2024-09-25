function [aircraft] = generate_climb_segments(aircraft)
% Description: 
% Inputs aircraft parameter values for climb TW calculations
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft struct updated with climb params
% 
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/22/2024

%% MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%

%TODO RFP says climb back to altitude. labeled OPTIMIZE. UNSURE IF NEEDED
aircraft.mission.climb.segment_names = ["takeoff climb", "transition climb", "second segment climb",...
                                        "enroute climb", "balked landing climb AEO", "balked landing climb OEI"]; 

%% CLIMB GRADIENT %%
%%%%%%%%%%%%%%%%%%%%
G_overshoot = 1;  % Given that we are often trying to complete interception missions, a larger climb gradient 
% may be desirable in climb scenarios when the aircraft is heading out to complete its mission 

aircraft.mission.climb.G = [0.012 * G_overshoot, 0*G_overshoot, 0.024*G_overshoot,...
                            0.012*G_overshoot, 0.032, 0.021]; % from FAR 25 requirements in metabook

%% STALL SPEED RATIO %%
%%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission.climb.ks = [1.2, 1.2, 1.2,...
                             1.25, 1.3, 1.5]; % from FAR 25 requirements in metabook

%% MAXIMUM LIFT COEFFICIENT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission.climb.CL_max = [aircraft.aerodynamics.CL_takeoff_flaps, aircraft.aerodynamics.CL_takeoff_flaps, aircraft.aerodynamics.CL_takeoff_flaps,...
                                 aircraft.aerodynamics.CL_cruise, aircraft.aerodynamics.CL_landing_flaps, 0.85*aircraft.aerodynamics.CL_landing_flaps]; % taken from table in Roskam textbook, OEI balked landing climb value is 0.85
                                                                                                                                                        % calculated following method in metabook page 40

%% ZERO LIFT DRAG COEFFICIENT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission.climb.CD0 = [aircraft.aerodynamics.CD0_takeoff_flaps_gear, aircraft.aerodynamics.CD0_takeoff_flaps_gear, aircraft.aerodynamics.CD0_takeoff_flaps,...
                              aircraft.aerodynamics.CD0_clean, aircraft.aerodynamics.CD0_landing_flaps_gear, (aircraft.aerodynamics.CD0_landing_flaps_gear+aircraft.aerodynamics.CD0_takeoff_flaps_gear)/2];
                              % metabook pg 40: OEI balked landing climb cd0 is mean of landing and takeoff values


%% WEIGHT %%
%%%%%%%%%%%%

% MOVED TO WEIGHTS --> aircraft.weight.max_landing_weight = 0.85 * aircraft.weight.togw;

aircraft.mission.climb.weight = [aircraft.weight.togw, aircraft.weight.togw, aircraft.weight.togw,...
                                 aircraft.weight.togw, aircraft.weight.max_landing_weight, aircraft.weight.max_landing_weight]; % [kg] from FAR 25 requirements in metabook

%% ACTIVE ENGINES %%
%%%%%%%%%%%%%%%%%%%%
aircraft.mission.climb.engines_active = [1, 1, 1,...
                                         1, 1, 1]; % from FAR 25 requirements in metabook. Our plane will only have 1 engine

%% THRUST CORRECTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%% 

OEI_correction = 2; % Using formula (N_engines/(N_engines-1)) for 2 engines
W_correction = aircraft.weight.max_landing_weight/aircraft.weight.togw; % Only applies for balked landing scenario with maximum landing weight
Temp_correction = 1/0.8;
Max_T_correction = 1/0.94;

aircraft.mission.climb.TW_corrections = [Temp_correction*OEI_correction, Temp_correction*OEI_correction, Temp_correction*OEI_correction, ...
                                         Temp_correction*OEI_correction*Max_T_correction, Temp_correction*W_correction, Temp_correction*OEI_correction*W_correction, ...
                                         Temp_correction*Max_T_correction]; 

% always using the temperature correction given that the RFP says aircraft must be able 
% to complete the climb maneuver in all weather and we don't know if the increase in temperature 
% decreaes with altitude so it will be assumed to be present in all climb scenarios

end