function [cg_excursion_arr, cg_excursion_dx_arr, cg_weight_arr] = cg_excursion_calc(aircraft, load_order)
% Description: This function calculates the cg excursion, based on an array
% of what you're loading into the plane/releasing, in that specific order.
% Negative values in an array means you're unloading it/subtracting that
% value
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    load order - array identifying what components are being
%    loaded/unloaded, following:
%
%           % 1 - empty weight
            % 2 - fuel - 100%
            % 3 - missiles 1 / 2 (bottom)
            % 4 - missiles 3 / 4 
            % 5 - missiles 5 / 6 DEPRECATED
            % 6 - loaded feed system (bullets + casings + feed system)
            % 7 - cannon bullets (firing all bullets but keeping the casings/feed system)
            % 8 - fuel - 50%
            % 9 - fuel - 25%
%    
% 
% OUTPUTS:
% --------------------------------------------
%    cg_excursion_array - 2x(length of order) filled with cg pos, weight of
%    aircraft
%                       
% 
% See also: 
% script
% Author:                          Niko
% Version history revision notes:
%                                  v1: 10/24/24    

    %% FOR EASE %%

    w = aircraft.weight;

    %% DEFINE ARRAYS TO PULL FROM BASED ON THIS ORDER %%

    % 1 - empty weight
    % 2 - fuel - 100%
    % 3 - missiles 1 / 2 (bottom)
    % 4 - missiles 3 / 4 
    % 5 - missiles 5 / 6 DEPRECATED
    % 6 - loaded feed system (bullets + casings + feed system)
    % 7 - cannon bullets (firing all bullets but keeping the casings/feed system)
    % 8 - fuel - 50%
    % 9 - fuel - 25%
   
    cg_sums = [w.cg_sum.empty;
               w.cg_sum.fuel;
               w.weapons.missile*2;
               w.weapons.missile*2;
               NaN;                  %DEPRECATED
               w.weapons.m61a1.loaded_feed_system;
               w.weapons.m61a1.bullets;
               w.cg_sum.fuel*0.5;
               w.cg_sum.fuel*0.25;];

    cg_pos_weighted = [w.cg_pos_weighted.empty;           % 1
                       w.cg_pos_weighted.fuel;            % 2
                       w.cg_pos_weighted.missiles12;      % 3
                       w.cg_pos_weighted.missiles34;      % 4
                       [NaN, NaN, NaN];                   % 5 DEPRECATED
                       w.cg_pos_weighted.loaded_feed_system; % 6
                       w.cg_pos_weighted.bullets;         % 7
                       w.cg_pos_weighted.fuel*0.5;        % 8
                       w.cg_pos_weighted.fuel*0.25;];     % 9
    
    %% BEGIN CALCULATION BASED ON THE ORDER ARRAY %%

    scenario_pos_sum    = [0, 0, 0];
    scenario_weight_sum = 0;

    cg_excursion_arr = zeros(length(load_order), 3);
    cg_weight_arr    = zeros(length(load_order), 1);

    for i = 1:length(load_order)

        if load_order(i) > 0 % we are loading the object

           scenario_pos_sum    = scenario_pos_sum    + cg_pos_weighted(load_order(i), :);
           scenario_weight_sum = scenario_weight_sum + cg_sums(load_order(i));
        else % load order is a negative number

           scenario_pos_sum    = scenario_pos_sum    - cg_pos_weighted(abs(load_order(i)), :); % take absolute value of index
           scenario_weight_sum = scenario_weight_sum - cg_sums(abs(load_order(i)));
        end

        cg_excursion_arr(i, 1:3) = scenario_pos_sum ./ scenario_weight_sum;
        cg_weight_arr(i) = scenario_weight_sum;
    end

    cg_excursion_dx_arr = convert_cg_excursion_to_delta_x(cg_excursion_arr);

end