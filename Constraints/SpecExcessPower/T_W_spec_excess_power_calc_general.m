function [T_W] = T_W_spec_excess_power_calc_general(aircraft, W_S, alt, mach, CD0, e, n, Ps)
%
% function [T_W] = SpecExcessPower(W_S,Alt,M,CD0,AR,n,Ps,ff)
%
% Calculate required thrust-to-weigth ratio from a given wing-loading for a
% sustained turn at a specific excess power Ps, (along with flight 
% conditions and aircraft specs: parasitic drag coefficient and aspect 
% ratio).
%
% Parameter = Description [units]
%   
% INPUTS:
%   W_S = Wing loading (at takeoff)          [N/m^2]
%   Alt = Cruise Altitude                    [m]
%   M   = Cruise Mach Number                 []
%   CDO = Current Parasitic Drag Coefficient []
%   n   = load factor (g's)                  []
%   Ps  = Specific Excess Power              [m/s]
%   ff = fuel fraction (total)               []
%
% OUTPUTS:
%   T_W = Thrust-to-weight ratio             []
% -------------------------------------------------------------------------

% Aircraft struct vars
ff = aircraft.weight.ff;
AR = aircraft.geometry.AR;

% Change units to force vs kg
g = 9.8067;
W_S_force = W_S*g;

% update sls wingloading to reflect 50% fuel
W_S_mw = W_S_force * (1 + (1-ff))/2 * n;

% get air temperature and density
[~,~,rho,a] = standard_atmosphere_calc(alt);
v = mach * a;

% calculate dynamic pressure
q = 0.5 * rho * v^2;

% Calculate the lift coefficient
CL = W_S_mw / q;

% calculate drag coefficient
CD = CD0 + CL^2 / (pi * AR * e);

% Calculate T_W by rearranging Ps = V(T-D)/W
T_W = Ps / v + q * CD / W_S_mw;

end % End