function [aircraft] = DCA_mission(aircraft)
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

%TODO RFP says climb back to altitude. labeled OPTIMIZE. UNSURE IF NEEDED
mission.segments = ["takeoff", "climb", "cruise", "loiter", "dash", "combat", ...
                    "combat", "optimize", "cruise", "descent", "reserve"]; 

%% MACH NUMBER %%
%%%%%%%%%%%%%%%%%

mission.mach = [NaN, NaN, 0.95, 0.95, 1.8, 1.2 ...
                0.9, NaN, 0.95, NaN, 0.16]; % from RFP

%% ALTITUDE %%
%%%%%%%%%%%%%%

mission.alt = [0, NaN, 10668, 10668, 10668, 10668 ... % TODO: DETERMINE "OPTIMUM" SPEED AND ALTITUDE
               10668, NaN, 10668, NaN, 0]; % [m]

%% VELOCITY %%
%%%%%%%%%%%%%%

mission.velocity = NaN(size(mission.segments)); %TODO CHECK MATRIX STUFF
for i = 1:length(mission.segments)
    if ~isnan(mission.mach(1,i))
        mission.velocity(i) = velocity_from_flight_cond(mission.mach(i),mission.alt(i)); % [m/s]
    end
end

%% RANGE AND ENDURANCE %%
%%%%%%%%%%%

mission.range_type = ["NA", "NA", "range", "endurance", "range", "range", ...
                      "range", "NA", "range", "NA", "endurance"];

combat1_range = basic_360_turn_distance(mission.velocity(1,6), 89); % accepts mission velocity [m/s] and [degrees] of bank angle TODO FIX
combat2_range = basic_360_turn_distance(mission.velocity(1,7), 89); % accepts mission velocity [m/s] and [degrees] of bank angle TODO FIX
mission.range = [NaN, NaN, 555600, NaN, 185200, combat1_range ...
                 combat2_range, NaN, 740800, NaN, NaN]; % [m] or , depending on type

mission.endurance = [NaN, NaN, NaN, 14400, NaN, NaN, ...
                     NaN, NaN, NaN, NaN, 1800]; %[s]

%% FLIGHT TIME %%
%%%%%%%%%%%%%%%%%

% Takeoff is averaged from data online (~6 min)
% Climb is an overestimate from data online (~1 min)
% Second climb is currently undefined
% Descent comes from averaged historical data for deccent time

time_cruise_out = time_from_range_flight_cond(mission.range(3), mission.mach(3), mission.alt(3));
time_dash = time_from_range_flight_cond(mission.range(5), mission.mach(5), mission.alt(5));
time_combat1 = time_from_range_flight_cond(mission.range(6), mission.mach(6), mission.alt(6));
time_combat2 = time_from_range_flight_cond(mission.range(7), mission.mach(7), mission.alt(7));
time_cruise_in = time_from_range_flight_cond(mission.range(9), mission.mach(9), mission.alt(9));

mission.time = [360, 60, time_cruise_out, mission.range(4), time_dash, time_combat1 ...
                time_combat2, NaN, time_cruise_in, 240, mission.range(11)]; %[s]

%% TSFC %%
%%%%%%%%%%

TSFC_cruise_out = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_loiter = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_dash = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_combat1 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to kgm/s*kgf
TSFC_combat2 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to kgm/s*kgf
TSFC_cruise_in = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_reserve = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s

mission.TSFC = [NaN, NaN, TSFC_cruise_out, TSFC_loiter, TSFC_dash, TSFC_combat1 ... 
                TSFC_combat2, NaN, TSFC_cruise_in, NaN, TSFC_reserve];

%% SAVE TO AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission = mission;

end