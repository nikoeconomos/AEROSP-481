function [aircraft] = generate_PDI_mission(aircraft)
% Description: 
% Function parameteizes aircraft and environment states for Point Defense Intercept 
% (PDI) mission and stores them in a struct. Each struct element is made up of an array
% with corresponding parts. Struct will be indexed into for fuel fraction calculations.
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specifications
%
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specifications, with mission struct
%    added
% 
% See also: ff_calc() for calculation of these parammeters
% using
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%

%TODO RFP says climb back to altitude. labeled OPTIMIZE. UNSURE IF NEEDED
mission.segments = ["takeoff", "climb", "dash",...
                    "combat", "combat", "optimize", ...
                    "cruise", "descent", "reserve"]; 

%% MACH NUMBER %%
%%%%%%%%%%%%%%%%%

mission.mach = [NaN, NaN, 1.8,...
                1.2, 0.9, NaN ...
                aircraft.performance.cruise_mach, NaN, 0.16]; % TODO fix reserve mach

%% ALTITUDE %%
%%%%%%%%%%%%%%

mission.alt = [0, NaN, 10668,...
               10668, 10668, NaN, ... % TODO: DETERMINE "OPTIMUM" SPEED AND ALTITUDE
               10668, NaN, 0]; % [m]

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

mission.range_type = ["NA", "NA", "range",...
                      "range", "range", "NA", ...
                      "range", "NA", "endurance"];

range_combat1 = basic_360_turn_distance(mission.velocity(4), 89); % [m] want to double chk this!!
range_combat2 = basic_360_turn_distance(mission.velocity(5), 89); % [m] want to double chk this!!
mission.range = [NaN, NaN, 370400,...
                 range_combat1, range_combat2, NaN ...
                 370400, NaN, NaN]; % [m] or , depending on type

mission.endurance = [NaN, NaN, NaN,...
                     NaN, NaN, NaN, ...
                     NaN, NaN, 1800]; %[s]

%% FLIGHT TIME %%
%%%%%%%%%%%%%%%%%

% Takeoff is averaged from data online (~6 min)
% Climb is an overestimate from data online (~1 min)
% Second climb/optimize is currently undefined
% Descent comes from averaged historical data for deccent time

time_dash = time_from_range_flight_cond(mission.range(1,3), mission.mach(1,3), mission.alt(1,3));
time_combat1 = time_from_range_flight_cond(mission.range(1,4), mission.mach(1,4), mission.alt(1,4));
time_combat2 = time_from_range_flight_cond(mission.range(1,5), mission.mach(1,5), mission.alt(1,5));
time_cruise_in = time_from_range_flight_cond(mission.range(1,7), mission.mach(1,7), mission.alt(1,7));

mission.time = [360, 60, time_dash, ...
                time_combat1, time_combat2, NaN ...
                time_cruise_in, 240, mission.endurance(1,9)]; %[s]

mission.time_total = sum(mission.time(~isnan(mission.time)));


%% TSFC %%
%%%%%%%%%%

TSFC_dash = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_combat1 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_combat2 = 1.2 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_cruise_in = 0.86 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_reserve = 0.71 / 7938; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s

mission.TSFC = [NaN, NaN, TSFC_dash, ...
                TSFC_combat1, TSFC_combat2, NaN ... 
                TSFC_cruise_in, NaN, TSFC_reserve];

%% SAVE TO AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission = mission;

end