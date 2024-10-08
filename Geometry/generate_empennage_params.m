function [aircraft] = generate_empennage_params(aircraft)
%Description:
% Calculates Swet, from metabook 4.9
%
% INPUTS:
% --------------------------------------------
%    w0 - kg
%
% OUTPUTS:
% --------------------------------------------
%    
%
%
% 
% Author:                          Juan
% Version history revision notes:
%                                  v1: 10/7/2024
% Calculate stall speed in m/s 

aircraft.geometry.empennage.L_HT = 0.5 * aircraft.geometry.fusselage.L_F;
L_VT = L_HT + 0.4;
S_W = 41;
c_bar_W = 3.5; % [m]
b_W = 10;
c_VT = 0.07;
c_HT = 0.4;
S_VT = c_VT * b_W * S_W / L_VT;
S_HT = c_HT * c_bar_W * S_W / L_HT;
gamma_vtail = atand(S_VT/S_HT); % degrees


end