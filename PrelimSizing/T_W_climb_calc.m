function TW_corrected = climb_TW_calc(aircraft)
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
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/22/2024

TW = (aircraft.mission.climb.ks.^2 .* aircraft.mission.climb.CD0 ./ aircraft.mission.climb.CL_max) + ...
(aircraft.mission.climb.CL_max ./ (pi * aircraft.geometry.aspect_ratio .* aircraft.aerodynamics.span_efficiency ...
.* aircraft.mission.climb.ks.^2)) + aircraft.mission.climb.G;

TW_corrected = aircraft.mission.climb.TW_corrections .* TW;

end