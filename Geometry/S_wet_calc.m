function S_wet = S_wet_calc(w0)
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
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/29/2024
% Calculate stall speed in m/s 

    kg_to_lb = 2.20462;
    ft2_to_m2 = 0.092903;

    c = -0.1289; %table 3.5 Roskam, values for clean MTOW, for fighter jet / figure 3.22
    d = 0.7506;

    S_wet = 10^(c)*(w0*kg_to_lb)^d; % [ft^2] %Wetted surface area estimate, eq metabook 4.9

    S_wet = S_wet*ft2_to_m2; % [m^2]

end



