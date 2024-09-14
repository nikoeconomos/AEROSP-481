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
% See also: DCA_fuel_fraction_calc() for calculation of these parammeters
% using, loiter_fuel_fraction_calc(), cruise_fuel_fraction_calc()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

%% MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%

mission.segments = ["takeoff", "climb", "cruise", "loiter", "dash", "combat", ...
                    "combat", "climb", "cruise", "descent", "reserve"];

%% MACH NUMBER %%
%%%%%%%%%%%%%%%%%

mission.mach = [NaN, NaN, 0.95, 0.95, 1.8, 1.2 ...
                0.9, NaN, 0.95, NaN, 0.16];

%% ALTITUDE %%
%%%%%%%%%%%%%%

mission.alt = [0, NaN, 10668, 10668, 10668, 10668 ... % TODO: MUST DETERMINE OPTIMUM SPEED AND ALTITUDE
               10668, NaN, 10668, NaN, 0]; % [m]

%% VELOCITY %%
%%%%%%%%%%%%%%

mission.velocity = NaN(size(mission.segments));
for i = 1:size(mission.segments)
    
    if ~isnan(ission.mach(i))
        mission.veloctiy(i) = velocity_from_flight_cond(mission.mach(i),mission.alt(i)); % [m/s]
    end
end

%% RANGE %%
%%%%%%%%%%%

mission.range_type = ["NA", "NA", "range", "endurance", "range", "range", ...
                      "range", "NA", "range", "NA", "endurance"];

combat1_range = basic_360_turn_distance(mission.velocity(6), 89); % accepts mission velocity [m/s] and [degrees] of bank angle
combat2_range = basic_360_turn_distance(mission.velocity(7), 89); % accepts mission velocity [m/s] and [degrees] of bank angle
mission.range = [NaN, NaN, 555600, 14400, 185200, combat1_range ...
                 combat2_range, NaN, 740800, NaN, 1800]; % [m] or [s], depending on type

%% FLIGHT TIME %%
%%%%%%%%%%%%%%%%%

% Takeoff is averaged from data online (~6 min)
% Climb is an overestimate from data online (~1 min)
% Second climb is currently undefined
% Descent comes from averaged historical data for deccent time

time_cruise_out = time_from_range_flight_cond(mission.range(3), mission.mach(3), mision.alt(3));
time_dash = time_from_range_flight_cond(mission.range(5), mission.mach(5), mision.alt(5));
time_combat1 = time_from_range_flight_cond(mission.range(6), mission.mach(6), mision.alt(6));
time_combat2 = time_from_range_flight_cond(mission.range(7), mission.mach(7), mision.alt(7));
time_cruise_in = time_from_range_flight_cond(mission.range(9), mission.mach(9), mision.alt(9));

mission.time = [360, 60, time_cruise_out, mission.range(4), time_dash, time_combat1 ...
                time_combat2, NaN, time_cruise_in, 240, mission.range(11)]; %[s]

%% TSFC %%
%%%%%%%%%%

tsfc_cruise_out = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
tsfc_loiter = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
tsfc_dash = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
tsfc_combat1 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to kgm/s*kgf
tsfc_combat2 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to kgm/s*kgf
tsfc_cruise_in = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
tsfc_reserve = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s

mission.tsfc = [NaN, NaN, tsfc_cruise_out, tsfc_loiter, tsfc_dash, tsfc_combat1 ... 
                tsfc_combat2, NaN, tsfc_cruise_in, NaN, tsfc_reserve];


%% SAVE TO AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission = mission;

end