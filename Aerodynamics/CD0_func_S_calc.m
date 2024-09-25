function [CD0] = CD0_func_S_calc(Cf, S)
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

%% NOT SURE IF THIS IS NEEDED. POTENTIALLY USE CD0_calc.m NOT SURE HOW TO GET SWET REST

S_wet = *S_wet_rest* + 2*S; %from 4.58 in metabook TODO UPDATE S_WET_REST WITH SOME PARAMETRIZED VALUE...

CD0 = Cf*S_wet/S; % TODO UPDATE C_f WITH SOME PARAMETRIZED VALUE

end
