function TW_corrected = T_W_climb4_calc(aircraft, W_S)
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

TW = ((aircraft.mission.climb.ks(4)).^2 .* aircraft.mission.climb.CD0(4) ./ aircraft.mission.climb.CL_max(4)) + ...
        (aircraft.mission.climb.CL_max(4) ./ (pi * aircraft.geometry.AR .* aircraft.mission.climb.e(4) ...
     .* (aircraft.mission.climb.ks(4)).^2)) + aircraft.mission.climb.G(4);

TW_corrected = aircraft.mission.climb.TW_corrections(4) .* TW;

end