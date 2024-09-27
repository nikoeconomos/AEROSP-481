function [S] = S_from_T_constraint_calc(T)
% Description: This function returns an array of S values from T inputs
% based on a constraint function f
%
% INPUTS:
% --------------------------------------------%
%
%   f - function handle for the calculation of T/W
%   k - number of data points for the plot
%   s_min - minimum value of s for our input array
%   s_max - maximum value of s for our input array
%
% OUTPUTS:
% --------------------------------------------
%    S - array of length k with input S values
%    T - array of length k with output T values from f
%
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/24/2024

    S = zeros(k);
    
    for i = 1:length(S)
        T0 = T(i);          % Prescribe thrust area
        S(i) = 42;     % Initial wing area guess (m2); based on F-35, slightly above; reasoning in notes
        tolerance = 0.1;    % Convergence tolerance
        converged = false;
    
        while ~converged
            W = togw_as_func_of_T_S_calc(S(i), T0);      % Compute TOGW TODO FINISH THIS FUNC
            thrust_to_weight =  T0/W;                    % Compute T/W
            wing_loading_new = f(thrust_to_weight);      % Compute W/S from constraint equation TODO 
            S_new = W/wing_loading_new;                  % Compute new wing area
            
            if abs(S_new - S(i)) <= tolerance            % Check for convergence
                converged = true;
            end
    
            S(i) = S_new;   % Update wing area value
        end
    end

end

