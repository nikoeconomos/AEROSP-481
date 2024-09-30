function [LD_max] = LD_max_calc(e, CD_0, AR)
% Description: This function returns the maximum and cruise Lift to Drag ratio (L/D)
% of our aircraft by using drag polar values and aircraft geometry. This
% function will be used to refine the L/D parameter as the design matures.
%
% INPUTS:
% --------------------------------------------
% 
%    CD_0 - Zero lift drag coefficient; corresponds to parasitic drag [-]
%    e - Oswald efficiency parameter (between [0,1]) [-]
%    AR - aspect ratio (wingspan/mean chord) [-]
%
% OUTPUTS:
% --------------------------------------------
%    LD_max - max L/D
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/29/2024
    
    LD_max = 0.5*sqrt(pi*e*AR/CD_0);

end
