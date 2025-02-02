function [aircraft] = generate_DCA_mission(aircraft)
% Description: 
% Function parameteizes aircraft and environment states for Direct
% Counter-Air Patrol (DCA) mission and stores them in a struct following
% the sequence Mission.Mission_Segment.Parameter. Struct will be indexed
% into for fuel fraction calculations.
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specifications
%
% OUTPUTS:
% --------------------------------------------
%    ESCORT_mission - 3 layer struct.
%    Stores values for parameters relevant to the aircraft's state at each segment of the
%    mission.
% 
% See also: ff_calc() for calculation of these parammeters
% using, loiter_fuel_fraction_calc(), cruise_fuel_fraction_calc()
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%

% TODO RFP says climb back to altitude. labeled OPTIMIZE. UNSURE IF NEEDED
mission.segments = [ "start",    "takeoff",   ...
                     "climb",    "cruise",    ...
                     "loiter",   "dash",      ...
                     "combat",   "combat",    ...
                     "optimize", "cruise",    ...
                     "descent",  "reserve" ];

%% MACH NUMBER %%
%%%%%%%%%%%%%%%%%

cruise_mach             = aircraft.performance.mach.cruise;
dash_mach               = aircraft.performance.mach.dash;
max_sustained_turn_mach = aircraft.performance.mach.max_sustained_turn;
min_sustained_turn_mach = aircraft.performance.mach.min_sustained_turn;
endurance_mach          = aircraft.performance.mach.endurance;

mission.mach = [  NaN,                      NaN,   ... 
                  NaN,                      cruise_mach, ...
                  cruise_mach,              dash_mach,   ...
                  max_sustained_turn_mach,  min_sustained_turn_mach,   ...
                  NaN,                      cruise_mach, ...
                  NaN,                      endurance_mach]; % from RFP

%% ALTITUDE %%
%%%%%%%%%%%%%%

mission.alt = [ 0,     0,     ...
                NaN,   10668,  ...
                10668, 10668,  ...
                10668, 10668,  ...
                NaN,   10668,  ...
                NaN,   0 ]; % [m]


%% VELOCITY %%
%%%%%%%%%%%%%%

mission.velocity = NaN(size(mission.segments));
for i = 1:length(mission.segments)
    if ~isnan(mission.mach(1,i))
        mission.velocity(i) = velocity_from_flight_cond(mission.mach(i),mission.alt(i)); % [m/s]
    end
end

%% RANGE AND ENDURANCE %%
%%%%%%%%%%%%%%%%%%%%%%%%%

mission.range_type = [ "NA",        "NA",      ... 
                       "NA",        "range",   ...
                       "endurance", "range",   ...
                       "range",     "range",   ...
                       "NA",        "range",   ...
                       "NA",        "endurance" ];

bank_angle = aircraft.performance.bank_angle_360;

range_combat1 = basic_360_turn_distance(bank_angle, mission.mach(7), mission.alt(7));  % accepts mission velocity [m/s] and [degrees] of bank angle TODO FIX
range_combat2 = basic_360_turn_distance(bank_angle, mission.mach(8), mission.alt(8));  % accepts mission velocity [m/s] and [degrees] of bank angle TODO FIX

mission.range     = [ NaN,              NaN,        ...
                      NaN,              555600,     ...
                      NaN,              185200,     ...
                      range_combat1,    range_combat2, ...
                      NaN,              740800,     ...
                      NaN,              NaN ];      % [m]

mission.endurance = [ NaN,        NaN,        ...
                      NaN,        NaN,        ...
                      14400,      NaN,        ...
                      NaN,        NaN,        ...
                      NaN,        NaN,        ...
                      NaN,        1800 ];     %[s]

%% FLIGHT TIME %%
%%%%%%%%%%%%%%%%%

% Startup is an estimate from metabook algorithm
% Takeoff is averaged from data online (~1 min)
% Climb is an overestimate from data online (~10 min) TODO UPDATE
% Second climb is currently undefined
% Descent comes from averaged historical data for descent time


time_cruise_out = time_from_range_flight_cond(mission.range(4),  mission.mach(4),  mission.alt(4));
time_dash       = time_from_range_flight_cond(mission.range(6),  mission.mach(6),  mission.alt(6));
time_combat1    = time_from_range_flight_cond(mission.range(7),  mission.mach(7),  mission.alt(7));
time_combat2    = time_from_range_flight_cond(mission.range(8),  mission.mach(8),  mission.alt(8));
time_cruise_in  = time_from_range_flight_cond(mission.range(10), mission.mach(10), mission.alt(10));

mission.time    = [ 900,                  60,          ... % 15 minutes for startup
                    600,                  time_cruise_out, ... %600 seconds comes from online for climb
                    mission.endurance(5), time_dash, ...
                    time_combat1,         time_combat2, ...
                    0,                    time_cruise_in, ... % optimize still not used
                    240,                  mission.endurance(12) ]; % [s]

mission.time_total = sum(mission.time(~isnan(mission.time)));

%% TSFC %%
%%%%%%%%%%

% pulled from figure 2.3 UPDATE 

TSFC_idle         = ConvTSFC(0.20, 'Imp', 'SI');  % estimated from slides 13 page 42
TSFC_takeoff      = ConvTSFC(0.64, 'Imp', 'SI');  % from wikipedia value on TSFC
TSFC_cruise       = ConvTSFC(0.80, 'Imp', 'SI');  % Estimate from Raymer table 3.3 page 36
TSFC_loiter       = ConvTSFC(0.50, 'Imp', 'SI');  % 
TSFC_dash         = ConvTSFC(1.90, 'Imp', 'SI');  % from wikipedia on TSFC
TSFC_combat1      = ConvTSFC(1.20, 'Imp', 'SI');  % 
TSFC_combat2      = ConvTSFC(1.00, 'Imp', 'SI');  % 
TSFC_reserve      = ConvTSFC(0.70, 'Imp', 'SI');  % 

mission.TSFC      = [ TSFC_idle,    TSFC_takeoff, ...
                      NaN,          TSFC_cruise, ...
                      TSFC_loiter,  TSFC_dash, ...
                      TSFC_combat1, TSFC_combat2, ...
                      NaN,          TSFC_cruise, ...
                      NaN,          TSFC_reserve ];

%% SAVE TO AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission = mission;


end