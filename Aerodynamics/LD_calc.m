function [LD_max, LD_cruise] = LD_calc()
% Description: This function returns the maximum and cruise Lift to Drag ratio (L/D)
% of our aircraft by using drag polar values and aircraft geometry. This
% function will be used to refine the L/D parameter as the design matures.
%
% INPUTS:
% --------------------------------------------
%    Currently not taking any inputs since the formula for L/D max isn't
%    being used
% 
%    c_d_0 - Zero lift drag coefficient; corresponds to parasitic drag [-]
%    e - Oswald efficiency parameter (between [0,1]) [-]
%    AR - aspect ratio (wingspan/mean chord) [-]
% OUTPUTS:
% --------------------------------------------
%    LD_max - max L/D
%    LD_cruise - optimal cruise L/D
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/10/2024
%   NOTE: As of v1, there are no available parameters for effective
%   calculation. The returned values are estimations, derived from analysis
%   of the geometry of a Lockheed Martin F-35 Lightning II. Once all
%   necessary parameters are available, replace the max_lift_to_drag
%   lines.
%
    LD_max = 12; % TODO: UPDATE, ESTIMATION, from hand calculation & graph
    % max_lift_to_drag = 0.5*sqrt(pi*e*a_r/c_d_0);
    LD_cruise = 0.943*LD_max;
end
