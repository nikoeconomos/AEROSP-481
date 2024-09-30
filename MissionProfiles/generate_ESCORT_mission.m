function [aircraft] = generate_ESCORT_mission(aircraft)
% Description: 
% This function is to calculate the different parameters 
% (TSFC, range, flight velocity) needed for the ESCORT_mission 
% fuel fraction calculation (in ESCORT_fuel_fraction_calc.m). Each paramter
% is calculated according to the mission segment (takeoff, climb, dash,
% escort, cruise, decent, reserve) that correspond with the ESCORT mission
% description in the RFP.
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
% using, loiter_fuel_fraction_calc(), cruise_fuel_fraction_calc()
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%

%TODO RFP says climb back to altitude. labeled OPTIMIZE. UNSURE IF NEEDED
mission.segments = ["start", "takeoff", "climb", "dash",...
                    "escort", "optimize", "cruise", ...
                    "descent", "reserve"]; 

%% MACH NUMBER %%
%%%%%%%%%%%%%%%%%

mission.mach = [NaN, NaN, NaN, 1.8,...
                0.7, NaN, aircraft.performance.cruise_mach ...
                NaN, 0.16]; % from RFP

%% ALTITUDE %%
%%%%%%%%%%%%%%

mission.alt = [0, 0, NaN, 10668,...
               10668, NaN, 10668, ... % TODO: DETERMINE "OPTIMUM" SPEED AND ALTITUDE
               NaN, 0]; % [m]


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

mission.range_type = ["NA", "NA", "NA", "range",...
                      "range", "NA", "range", ...
                      "NA", "endurance"];

mission.range = [NaN, NaN, NaN, 370400,...
                 555600, NaN, 926000 ...
                 NaN, NaN]; % [m] or , depending on type

mission.endurance = [NaN, NaN, NaN, NaN,...
                     NaN, NaN, NaN, ...
                     NaN, 1800]; %[s]

%% FLIGHT TIME %%
%%%%%%%%%%%%%%%%%

% Takeoff is averaged from data online (~6 min)
% Climb is an overestimate from data online (~1 min)
% Second climb/optimize is currently undefined
% Descent comes from averaged historical data for deccent time

time_dash = time_from_range_flight_cond(mission.range(1,3), mission.mach(1,3), mission.alt(1,3));
time_escort = time_from_range_flight_cond(mission.range(1,4), mission.mach(1,4), mission.alt(1,4));
time_cruise_in = time_from_range_flight_cond(mission.range(1,5), mission.mach(1,5), mission.alt(1,5));

mission.time = [900, 60, 360, time_dash, ...
                time_escort, NaN, time_cruise_in ...
                240, mission.endurance(1,7)]; %[s]

mission.time_total = sum(mission.time(~isnan(mission.time)));

%% TSFC %%
%%%%%%%%%%

% pulled from figure 2.3

conversion_factor = 2.838*10^-5; %lbm/s/lbf to kg/s/N

TSFC_idle = 0.7 * conversion_factor; 
TSFC_takeoff = 0.8 * conversion_factor; % ESTIMATED FROM ONLINE
TSFC_dash = 1.2 * conversion_factor; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_escort = 0.8 * conversion_factor; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_cruise_in = 0.86 * conversion_factor; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s
TSFC_reserve = 0.71 * conversion_factor; % [kg/kg*s] First number from left to right is TSFC in lbm/hr*lbf, next rumber is conversion factor to 1/s

mission.TSFC = [TSFC_idle, TSFC_takeoff, NaN, TSFC_dash, ...
                TSFC_escort, NaN, TSFC_cruise_in ... 
                NaN, TSFC_reserve];

%% SAVE TO AIRCRAFT %%
%%%%%%%%%%%%%%%%%%%%%%

aircraft.mission = mission;

end