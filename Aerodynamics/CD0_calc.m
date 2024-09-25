function CD0 = CD0_calc(Cf, S_wet, S)
% Description: This function calculates the parasitic drag coefficient
% based off of metabook eq 4.8
% 
% 
% INPUTS:
% --------------------------------------------
%    Cf - skin friction coefficient
%    Swet = wetted area, m^2
%    S - wing area, m^2
% 
% OUTPUTS:
% --------------------------------------------
%    CD0 - parasitce drag coefficient
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024
    CD0 = Cf * (S_wet / S);
end