function TW_corrected = T_W_climb_calc_1(aircraft, W_S)
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

CL = aircraft.mission.climb.CL_max(1)/(aircraft.mission.climb.ks(1))^2;

T_W = (aircraft.mission.climb.CD0(1) + ( CL^2/(pi*aircraft.geometry.wing.AR*aircraft.mission.climb.e(1))))/CL + aircraft.mission.climb.G(1);

TW_corrected = aircraft.mission.climb.TW_corrections(1) * T_W;

end