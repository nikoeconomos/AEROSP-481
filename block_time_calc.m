function [block_time] = block_time_calc()
% Description: This function calculates the total sum of hours spent to fly
% each mission - AKA the block time.
%
% This parameter will feed into calculations for several other cost
% functions.
%
% INPUTS:
% --------------------------------------------
%    
%
% OUTPUTS:
% --------------------------------------------
%    
% 
% See also: 
% Author:                          shay
% Version history revision notes:
%                                  v1: 9/13/2024


% mission 1
mission1_time = DCA_mission.start_takeoff.time + DCA_mission.climb.time + ...
DCA_mission.cruise_out.time + DCA_mission.loiter.time + DCA_mission.dash.time ...
+ DCA_mission.combat1.time + DCA_mission.combat2.time + DCA_mission.cruise_in.time + DCA_mission.decent.time;

% mission 2 
mission2_time = 0;

% mission 3
mission3_time = 0;

% total block time
block_time = mission1_time + mission2_time + mission3_time;