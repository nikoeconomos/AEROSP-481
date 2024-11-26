function T_W_ceiling_corrected = T_W_ceiling_calc(aircraft, W_S)
% Description: This function calculates the ceiling parameter. Independent
% of W_S.
% 
% 
% INPUTS:
% --------------------------------------------
%    none
% 
% OUTPUTS:
% --------------------------------------------
%    T_W_ceiling_constraint: Mimimum required T/W for ceiling operations.
%    For now, no specifications are given, so the absolute minimum is
%    calculated.
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/29/2024

G = 0.006; % assume G is half of enroute climb so 0.6%

TW_ceiling = 2*sqrt(aircraft.aerodynamics.CD0.clean/(pi * aircraft.geometry.wing.AR * aircraft.aerodynamics.e.clean)) + G; 

T_W_ceiling_corrected = aircraft.mission.climb.TW_ceiling_correction .* TW_ceiling;

end