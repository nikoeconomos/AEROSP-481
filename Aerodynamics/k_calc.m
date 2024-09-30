function [k] = k_calc(AR, e)
% Description: calculates k.
%
% INPUTS:
% --------------------------------------------
%    e - oswald efficiency
%   AR - aspect ratio
% 
% OUTPUTS:
% --------------------------------------------
%    k
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/23/2024
%

k = 1/(pi*AR*e);

end
