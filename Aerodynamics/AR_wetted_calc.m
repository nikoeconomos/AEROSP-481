% Aerosp 481 Group 3 - Libellula 
function [AR_wetted] = AR_wetted_calc(LD_max)
% Description:  3.12 in Raymer new edition book. Equation. Calculates AR wetted
% based on a regression with LD max. THis is b^2/swet
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with aerodynamics
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%%

KLD = 14; % from raymer new edition pg 40, for military aircraft

AR_wetted = (LD_max/KLD)^2 ; %

end