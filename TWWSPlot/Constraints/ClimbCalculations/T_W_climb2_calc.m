function TW_corrected = T_W_climb2_calc(aircraft, W_S)
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

CL = aircraft.mission.climb.CL_max(2)/(aircraft.mission.climb.ks(2))^2;

T_W = (aircraft.mission.climb.CD0(2) + ( CL^2/(pi*aircraft.geometry.AR*aircraft.mission.climb.e(2))))/CL + aircraft.mission.climb.G(2);

TW_corrected = aircraft.mission.climb.TW_corrections(2) * T_W;

end