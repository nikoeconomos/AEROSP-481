function TW_corrected = T_W_climb_calc(aircraft)
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
        (aircraft.mission.climb.CL_max ./ (pi * aircraft.geometry.AR .* aircraft.aerodynamics.e_cruise ...
     .* (aircraft.mission.climb.ks).^2)) + aircraft.mission.climb.G;

%% INCORPORATE CEILING %%
%%%%%%%%%%%%%%%%%%%%%%%%%

TW_ceiling = 2*sqrt(aircraft.aerodynamics.CD0_clean/(pi * aircraft.geometry.AR * aircraft.aerodynamics.e_cruise)) + 0.006; % assume G is half of enroute climb so 0.6%

TW = [TW, TW_ceiling];

%% INCLUDE THRUST CORRECTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TW_corrected = aircraft.mission.climb.TW_corrections .* TW;

end