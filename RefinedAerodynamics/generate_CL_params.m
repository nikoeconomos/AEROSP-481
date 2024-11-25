function [aircraft] = generate_CL_params(aircraft)
% Description: 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    plugs in Cl max values and gets CL for different conditions                   
% 
% See also:
% Author:                          Juan
% Version history revision notes:
%                                  v1: 11/24/2024


%% Define constant parameters

sectional_clean_Cl = ; % From simulation at AOA = 2
sectional_TO_Cl = ; % From simulation at AOA = 6
sectional_L_Cl = ; % From simulation at AOA = 10

del_Cl_TO = abs(sectional_clean_Cl - sectional_TO_Cl);
del_Cl_L = abs(sectional_clean_Cl - sectional_L_Cl);

S_flapped = 21.176; % From CAD, S_flapped_leading_edge = S_flapped_trailing_edge
S_ref = aircraft.geometry.wing.S_ref;



%% Calculate change in wing CL

end