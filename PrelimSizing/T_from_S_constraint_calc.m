function [T] = T_from_S_constraint_calc(aircraft, S, f, k)
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
    T = zeros(1,k);
    
    for i = 1:length(S)
        S0 = S(i);          % Prescribe wing area
        T(i) = 100000;      % Initial thrust guess (N); based on F-35, reasoning in notes
        tolerance = 0.1;    % Convergence tolerance
        converged = false;
    
        iteration = 0;
        while ~converged
            w_0           = togw_as_func_of_T_S_calc(aircraft, T(i), S0);      % Compute TOGW TODO FINISH THIS FUNC
            wing_loading = w_0/S0;                                  % Compute wing loading
            T_W_new      = f(aircraft, wing_loading);      % Compute T=W from constraint equation TODO 
            T_new        = T_W_new*w_0;                       % Compute new total thrust T / W * W
            
            if abs(T_new - T(i)) <= tolerance                      % Check for convergence
                converged = true;
            end
    
            alpha = 0.5; % FOR DEBUGGING, RELAXATION FACTOR
            T(i)   = alpha*T_new + (1 - alpha)*T(i);
            %T(i) = T_new;   % Update thrust value
            
            iteration = iteration + 1;
        end
        fprintf('Converged for S = %d\n', S0)
        fprintf('T = %d\n', T(i))
        fprintf('TOGW: %d\n', w_0)
    end

end

