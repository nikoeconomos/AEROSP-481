function CD = CD_parabolic_drag_polar_calc(CD0, CL, AR, e)
% Description: This function generates calculated the drag coefficient
% based on parasitic drag and lift coefficients, From metabook eq 4.7,
% assuming a parabolic drag polar
% 
% 
% INPUTS:
% --------------------------------------------
%    CD0 - parasitic drag coeff
%    CL - coeff of lift
%    AR - aspect ratio
%    e - oswald efficiency factor
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with drag polar
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/23/2024
    
    % Parabolic drag polar equation, meta eq 2.10
    CD = CD0 + CL^2/(pi * AR * e);
end