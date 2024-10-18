function TW_corrected = T_W_climb_general_calc(aircraft, W_S)
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

TW = ((aircraft.mission.climb.ks).^2 .* aircraft.mission.climb.CD0 ./ aircraft.mission.climb.CL_max) + ...
        (aircraft.mission.climb.CL_max ./ (pi * aircraft.geometry.AR .* aircraft.mission.climb.e ...
     .* (aircraft.mission.climb.ks).^2)) + aircraft.mission.climb.G;

TW_corrected = aircraft.mission.climb.TW_corrections .* TW;

end