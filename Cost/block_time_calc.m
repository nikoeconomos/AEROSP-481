function [block_time] = block_time_calc(aircraft)
% Description: This function calculates the total sum of seconds spent to fly
% each mission - AKA the block time. in hours
%
% This parameter will feed into calculations for several other cost
% functions.
%
% INPUTS: 
% --------------------------------------------
%    aircraft - struct with aircraft parameters
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


aircraft = generate_DCA_mission(aircraft);
block_time = aircraft.mission.time_total;

block_time = block_time/3600;

end