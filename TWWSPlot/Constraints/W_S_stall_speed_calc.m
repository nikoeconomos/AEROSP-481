% Aerosp 481 Group 3 - Libellula 
function [W_S] = W_S_stall_speed_calc(aircraft, T_W)
% Description: 
% calculates stall speed and then on a hot day at sea level
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
%    rho - air density of stall conditions (alt, temp, etc)
% 
% OUTPUTS:
% --------------------------------------------
%    W_S
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% DEPRECATED DO NOT USE%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = aircraft.environment.rho_SL_45C; % stall speed at landing/takeoff on a hot day

v_stall = NaN; % THIS FUNCTION IS DEPCRETATED. CAN BE USED ONCE STALL SPEED IS CALCULATED.

W_S = 0.5 * rho * v_stall^2 * aircraft.aerodynamics.CL_takeoff_flaps;

end