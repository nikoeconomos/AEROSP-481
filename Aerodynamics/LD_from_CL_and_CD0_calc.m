function [LD] = LD_from_CL_and_CD0_calc(CL, CD0, k)
% Description: Calculate the lift-to-drag ratio optimal CL for a given CD0
% and k. FROM meta 4.12.1 algorithm 3
%
% INPUTS:
% --------------------------------------------
%   CL - lift coeff optimal   
% CD0 - Parasite drag coefficient.
%    k   - Lift-induced drag constant.
%
% OUTPUTS:
% --------------------------------------------
%    LD_ratio - Lift-to-drag ratio.
% Calculate optimal CL that maximizes L/D

LD = 0.94*CL/(CD0 + k*CL^2);

end