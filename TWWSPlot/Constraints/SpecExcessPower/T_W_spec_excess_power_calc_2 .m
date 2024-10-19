function [T_W] = T_W_spec_excess_power_1_calc(aircraft, W_S)
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
%   AR  = Wing Aspect Ratio                  []
%   n   = load factor (g's)                  []
%   Ps  = Specific Excess Power              [m/s]
%   ff = fuel fraction (total)               []
%
% OUTPUTS:
%   T_W = Thrust-to-weight ratio             []
% -------------------------------------------------------------------------



% Spec Excess Power calculated at 50% internal fuel (maneuver weight)

ff = aircraft.weight.ff;

% update sls wingloading to reflect 50% fuel
W_S_mw = W_S * (1 + (1-ff))/2 * n;

% get air temperature and density
[Temp,~,Dens] = standard_atmosphere_calc(alt);

% calculate speed using mach number and air temperature
R = 287; Gam = 1.4; % Gas constant and ratio of specific heats for air
v = M * sqrt(Gam * R * Temp);

% calculate dynamic pressure
q = 0.5 * Dens * v^2;

% calculate Oswald Efficiency
e = Utility.Oswald(AR);

% Calculate the lift coefficient
CL = W_S_mw / q;

% calculate drag coefficient
CD = CD0 + CL^2 / (pi * AR * e);

% Calculate T_W by rearranging Ps = V(T-D)/W
T_W = Ps / v + q * CD / W_S_mw;




end % End Constraints.SpecExcessPower





