function [T_W] = T_W_spec_excess_power_calc_1(aircraft, W_S)
%
% function [T_W] = SpecExcessPower(aircraft, W_S)
%
% Calculate required thrust-to-weigth ratio from a given wing-loading for a
% sustained turn at a specific excess power Ps, (along with flight 
% conditions and aircraft specs: parasitic drag coefficient and aspect 
% ratio). Feeds into the general calculation, this function is for deciding
% values.
%
% Parameter = Description [units]
%   
% INPUTS:
%   aircraft
%   W_S = Wing loading (at takeoff)          [N/m^2]
%
% OUTPUTS:
%   T_W = Thrust-to-weight ratio             []
% -------------------------------------------------------------------------

alt = 


% Calculate T_W by rearranging Ps = V(T-D)/W
T_W = T_W_spec_excess_power_calc_general(aircraft, W_S, alt, mach, CD0, e, n, Ps);

end 





