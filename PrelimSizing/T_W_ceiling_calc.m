function T_W_ceiling_constraint = T_W_ceiling_calc()
% Description: This function generates a struct of aircraft parameters that
% relate to assignment 4, preliminary sizing.
% 
% 
% INPUTS:
% --------------------------------------------
%    none
% 
% OUTPUTS:
% --------------------------------------------
%    T_W_ceiling_constraint: Mimimum required T/W for ceiling operations.
%    For now, no specifications are given, so the absolute minimum is
%    calculated.
%                       
% 
% See also: None
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/22/2024
    togw = 9005; %kg, based on DCA mission
    Swet = 10^(-.1289)*(togw)^0.7506; %Wetted surface area estimate, ft2
    Swet = Swet*0.092903; %Wetted surface area estimate, m2
    skin_friction_coefficient = 0.0035; % skin friction coefficient estimate
    aspect_ratio = 2.66; %Assumed from F-35
    Sref = 0.75*Swet/aspect_ratio; % Estimated from wetted aspect ratio graph (fig 2.4)
    span_efficiency = 0.85;
    CD0 = skin_friction_coefficient*Swet/(Sref);
    G = 1/15; % 1 mile climb per 15 mile traveled; reasonable climb gradient at service ceiling
    T_W_ceiling_constraint = 2*sqrt(CD0/(pi*aspect_ratio*span_efficiency))+G;