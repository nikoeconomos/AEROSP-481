function TW_corrected = T_W_climb_calc_4(aircraft, W_S)
% Description: 
% Function calculates T_W climb for various values
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specifications
%
% OUTPUTS:
% --------------------------------------------
%    TW_corrected - correct thrust to weight ratio
% 
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/22/2024

CL = aircraft.mission.climb.CL_max(4)/(aircraft.mission.climb.ks(4))^2;

T_W = (aircraft.mission.climb.CD0(4) + ( CL^2/(pi*aircraft.geometry.wing.AR*aircraft.mission.climb.e(4))))/CL + aircraft.mission.climb.G(4);

TW_corrected = aircraft.mission.climb.TW_corrections(4) * T_W;

end