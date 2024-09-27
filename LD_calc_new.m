function LD_ratio = LD_calc_new(CD0, k)
% Description: Calculate the lift-to-drag ratio (L/D) for a given CD0 and k.
%
% INPUTS:
% --------------------------------------------
%    CD0 - Parasite drag coefficient.
%    k   - Lift-induced drag constant.
%
% OUTPUTS:
% --------------------------------------------
%    LD_ratio - Lift-to-drag ratio.

% Calculate optimal CL that maximizes L/D
CL_opt = sqrt(CD0 / k);

% Calculate lift-to-drag ratio at optimal CL
LD_ratio = (0.94 * CL_opt) / (CD0 + k * CL_opt^2);

end