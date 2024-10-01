function TW_corrected = T_W_climb5_calc(aircraft, W_S)
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

TW = ((aircraft.mission.climb.ks(5)).^2 .* aircraft.mission.climb.CD0(5) ./ aircraft.mission.climb.CL_max(5)) + ...
        (aircraft.mission.climb.CL_max(5) ./ (pi * aircraft.geometry.AR .* aircraft.mission.climb.e(5) ...
     .* (aircraft.mission.climb.ks(5))).^2) + aircraft.mission.climb.G(5);

TW_corrected = aircraft.mission.climb.TW_corrections(5) .* TW;

end