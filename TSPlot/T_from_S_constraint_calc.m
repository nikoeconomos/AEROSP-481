function [T] = T_from_S_constraint_calc(aircraft, Sin, f, k)
% Description: This function returns an array of T values from S inputs
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
    T_guess = 100000; %[N]
    T = zeros(1,k);
    g = 9.8066;
    
    for i = 1:length(Sin)
        
        S_0  = Sin(i);          % Prescribe wing area
        T(i) = T_guess;      % Initial thrust guess (N); based on F-35, reasoning in notes
        tolerance = 1;    % Convergence tolerance
        converged = false;
    
        iter = 0;
        while ~converged

            W_0 = togw_as_func_of_T_S_calc(aircraft, T(i), S_0); % Compute TOGW TODO FINISH THIS FUNC
            
            if isnan(W_0)
                T(i) = NaN;
                break;
            end

            W_S_new  = W_0/S_0;        % Compute wing loading
            T_W_new  = f(aircraft, W_S_new); % Compute T=W from constraint equation TODO 
            T_new    = T_W_new*(W_0 * g);    % Compute new total thrust T / W * W [N][kg*m/s^2]
            
            if abs(T_new - T(i)) <= tolerance % Check for convergence
                converged = true;
            end
    
            alpha = 0.5; % RELAXATION FACTOR
            T(i)   = alpha*T_new + (1 - alpha)*T(i);
            
            iter = iter + 1;
        end

    end

end

