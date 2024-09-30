function [CL] = CL_from_CD0_calc(CD0, k)
% Description: Calculate the lift-to-drag ratio optimal CL for a given CD0
% and k. FROM meta 4.12.1 algorithm 3
%
% INPUTS:
% --------------------------------------------
%    CD0 - Parasite drag coefficient.
%    k   - Lift-induced drag constant.
%
% OUTPUTS:
% --------------------------------------------
%    LD_ratio - Lift-to-drag ratio.
% Calculate optimal CL that maximizes L/D

CL = sqrt(CD0 / k);

end