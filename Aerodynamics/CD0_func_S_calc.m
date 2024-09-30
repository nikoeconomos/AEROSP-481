function [CD0] = CD0_func_S_calc(S_wet_rest, S, Cf)
% Description: This function calculates the zero lift drag CD_0 from wing
% area using the formula given in metabook 4.58, pg 49
%
% INPUTS:
% --------------------------------------------
%    S - wing area
% 
% OUTPUTS:
% --------------------------------------------
%    CD_0 - Zero lift drag coefficient; corresponds to parasitic drag [-]
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/23/2024
%

S_wet = S_wet_rest + 2*S; %from 4.58 in metabook

CD0 = Cf*(S_wet/S);

end
