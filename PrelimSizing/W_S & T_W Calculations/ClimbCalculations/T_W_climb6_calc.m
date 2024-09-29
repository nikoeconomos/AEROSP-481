function TW_corrected = T_W_climb6_calc(aircraft, W_S)
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

TW = ((aircraft.mission.climb.ks(6)).^2 .* aircraft.mission.climb.CD0(6) ./ aircraft.mission.climb.CL_max(6)) + ...
        (aircraft.mission.climb.CL_max(6) ./ (pi * aircraft.geometry.AR .* aircraft.mission.climb.e(6) ...
     .* (aircraft.mission.climb.ks(6)).^2)) + aircraft.mission.climb.G(6);

TW_corrected = aircraft.mission.climb.TW_corrections(6) .* TW;

end