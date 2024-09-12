function [max_lift_to_drag, cruise_lift_to_drag] = lift_to_drag_calc(c_d_0,e,AR)
% Description: This function returns the maximum and cruise Lift to Drag ratio (L/D)
% of our aircraft by using drag polar values and aircraft geometry. This
% function will be used to refine the L/D parameter as the design matures.
%
% INPUTS:
% --------------------------------------------
%    c_d_0 - Zero lift drag coefficient; corresponds to parasitic drag [-]
%    e - Oswald efficiency parameter (between [0,1]) [-]
%    AR - aspect ratio (wingspan/mean chord) [-]
% OUTPUTS:
% --------------------------------------------
%    max_LD - max L/D
%    cruise_LD - optimal cruise L/D
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/10/2024
%   NOTE: As of v1, there are no available parameters for effective
%   calculation. The returned values are estimations, derived from analysis
%   of the geometry of a Lockheed Martin F-35 Lightning II. Once all
%   necessary parameters are available, replace the max_lift_to_drag
%   lines.
%
    max_lift_to_drag = 12; %ESTIMATION, from hand calculation & graph
    % max_lift_to_drag = 0.5*sqrt(pi*e*a_r/c_d_0);
    cruise_lift_to_drag = 0.943*max_lift_to_drag;
end
