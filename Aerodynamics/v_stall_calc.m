

function v_stall = v_stall_calc(W_S, rho, CL_max)
%Description:
% Function calculates the stall speed and related speeds (takeoff, approach, landing)
% for an aircraft based on wing loading, air density, and maximum lift coefficient. 
% These speeds are critical for determining safe operational speeds during different 
% flight phases such as takeoff, approach, and landing. 
%
% INPUTS:
% --------------------------------------------
%    W_S       - Wing loading (N/m²)
%    rho       - Air density (kg/m³)
%    CL_max    - Maximum lift coefficient (unitless)
%
% OUTPUTS:
% --------------------------------------------
%    V_stall   - Stall speed (knots)
%
%
% See also: generate_F35_params.m, generate_aerodynamics_params.m 
% 
% Author:                          Vienna
% Version history revision notes:
%                                  v1: 9/18/2024
% Calculate stall speed in m/s 

    v_stall = sqrt((2 * W_S) / (rho * CL_max));

end



