function S_ref = S_ref_from_S_wet_calc(aircraft, S_wet)
%Description:
% Calculates Swet, from metabook 4.9
%
% INPUTS:
% --------------------------------------------
%    S_wet - previously calculated  SWet [m2]
%
% OUTPUTS:
% --------------------------------------------
%    
%      S_ref - wing ref area [m^2]
%
% 
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/29/2024

    % CURRENTLY DEPRECATED
    S_ref = S_wet / aircraft.geometry.S_wet_over_S_ref;

end



