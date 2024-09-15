function [block_time] = block_time_calc(DCA_mission, PDI_mission, ESCORT_mission)
% Description: This function calculates the total sum of hours spent to fly
% each mission - AKA the block time.
%
% This parameter will feed into calculations for several other cost
% functions.
%
% INPUTS: 
% --------------------------------------------
%    mission struct variables
%
% OUTPUTS:
% --------------------------------------------
%    block_time - the total time in hours spent completing all 3 missions
% 
% See also: generate_DCA_mission, generate_PDI_mission and
% generate_ESCORT_mission for calculations of the time for each mission
% segment respectively
%
% Author:                          shay
% Version history revision notes:
%                                  v1: 9/13/2024


% mission 1
mission1_time = DCA_mission.start_takeoff.time + DCA_mission.climb.time + ...
DCA_mission.cruise_out.time + DCA_mission.loiter.time + DCA_mission.dash.time ...
+ DCA_mission.combat1.time + DCA_mission.combat2.time + DCA_mission.cruise_in.time + DCA_mission.decent.time;

% mission 2 
mission2_time = PDI_mission.start_takeoff.time + PDI_mission.climb.time + ...
PDI_mission.dash.time + PDI_mission.combat1.time + PDI_mission.combat2.time...
+ PDI_mission.cruise_in.time + PDI_mission.descent.time;

% mission 3
mission3_time = ESCORT_mission.start_takeoff.time + ESCORT_mission.climb.time...
    + ESCORT_mission.dash.time + ESCORT_mission.escort.time + ...
    ESCORT_mission.cruise_in.time +ESCORT_mission.descent.time;

% total block time
block_time = mission1_time + mission2_time + mission3_time;

end