function TW_corrected = T_W_climb_calc(aircraft, W_S, i)
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

CL = aircraft.mission.climb.CL_max(i)/(aircraft.mission.climb.ks(i))^2;

T_W = (aircraft.mission.climb.CD0(i) + ( CL^2/(pi*aircraft.geometry.AR*aircraft.mission.climb.e(i))))/CL + aircraft.mission.climb.G(i);

TW_corrected = aircraft.mission.climb.TW_corrections(i) * T_W;

end