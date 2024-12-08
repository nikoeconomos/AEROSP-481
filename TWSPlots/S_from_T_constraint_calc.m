function [S] = S_from_T_constraint_calc(aircraft, Tin, f, k)
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

    S_guess = 42; %m2, initial guess for f35
    S = zeros(1,k);
    g = 9.8066;
    
    for i = 1:length(S)

        T_0 = Tin(i);         % Prescribe wing area
        S(i) = S_guess;     % Initial thrust guess (N); based on F-35, reasoning in notes
        tolerance = 0.1;    % Convergence tolerance
        converged = false;
    
        iter = 0;
        while ~converged

            [W_0, ff] = togw_as_func_of_T_S_calc(aircraft, T_0, S(i)); % Compute TOGW
            aircraft.weight.ff = ff;

            if isnan(W_0)
                S(i) = NaN;
                break;
            end

            T_W_new = T_0/(W_0*g);  
            W_S_new = f(aircraft, T_W_new);      % Compute W/S from constraint equation TODO 
            S_new   = W_0/W_S_new; 
            
            if abs(S_new - S(i)) <= tolerance % Check for convergence
                converged = true;
            end
    
            alpha = 0.5; % RELAXATION FACTOR
            S(i)  = alpha*S_new + (1 - alpha)*S(i);
            
            iter = iter + 1;
        end
    end

end    