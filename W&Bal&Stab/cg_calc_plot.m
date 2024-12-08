function aircraft = cg_calc_plot(aircraft)
% Description: This function generates the cg and cg excursion plots for
% our aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft
%                       
% 
% See also: 
% script
% Author:                          Niko
% Version history revision notes:
%                                  v1: 10/20/24    


    w = aircraft.weight;
    c = w.components;
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %% CENTER OF GRAVITY %%
    %%%%%%%%%%%%%%%%%%%%%%%

     %% CG LOCATIONS %%  

    w.cg_pos = struct();

    w.cg_pos.engine = [13.353, 0, 0.27];

    w.cg_pos.vtail  = [aircraft.geometry.vtail.x40MAC, 0, 1.566];
    w.cg_pos.htail  = [aircraft.geometry.htail.x40MAC, 0, 0.065];
    w.cg_pos.wing   = [aircraft.geometry.wing.x40MAC,  0, 0.863];

    w.cg_pos.fuselage = [8.97, 0, 0.801]; % m, CENTROID OF THE FUSELAGE FROM CAD

    w.cg_pos.cannon             = [5.46, 0.661, 0.59];
    w.cg_pos.cannon_feed_system = [6.083, 0.411, 0.59]; 

    w.cg_pos.missile_1 = [7.172, -0.741,  -0.03];
    w.cg_pos.missile_2 = [7.172, 0.741,  -0.03];

    w.cg_pos.missile_3 = [7.172, -0.251, -0.18];
    w.cg_pos.missile_4 = [7.172, 0.251, -0.18];

    w.cg_pos.xtra = [aircraft.geometry.fuselage.length*0.45, 0, 0]; % 45% of fuselage length (raymer table)
    
    w.cg_pos.fore_fuel       = [4.9, -0.091,  0.269];
    w.cg_pos.center_fuel     = [8.295,  -0.022,  0.515];
    w.cg_pos.aft_fuel        = [11.125, 0.002, 0.667];
    w.cg_pos.right_wing_fuel = [9.498, -2.316,  0.279]; 
    w.cg_pos.left_wing_fuel  = [9.498, 2.316,  0.279];

    w.cg_pos.ICNIA   = [3.375, 0.246, 0.145];
    w.cg_pos.databus = [2.782, -0.365, 0.268];
    w.cg_pos.INEWS   = [3.37, -0.249, 0.14];
    w.cg_pos.VMS     = [3.829, 0.002, 0.29];
    w.cg_pos.IRSTS   = [3.41, 0, 0.63];
    w.cg_pos.AESA    = [2.695, 0, 0.12];
    w.cg_pos.EES     = [12.325, 0.74, 0.25];
    w.cg_pos.APU     = [11.906, -0.689, -0.08];

    w.cg_pos.lg_main = [10.209,0,0]; % Not actually 0 0, but we can't as accurately say where the Z will be placed. 10.209 is v approximate.
    w.cg_pos.lg_nose = [3.999,0,0];
 
    %% EMPTY CG %%

    g = w.gfe; %TODO ensure ALL GFE IS CAPTURED

    empty_comp_weight = [c.engine,...
                         c.vtail,...
                         c.htail,...
                         c.wing,...
                         c.fuselage,...
                         c.xtra,...
                         g.ICNIA,...
                         g.databus,...
                         g.INEWS,...
                         g.VMS,...
                         g.IRSTS,...
                         g.AESA,...
                         g.EES,...
                         g.APU,...
                         w.weapons.m61a1.cannon,...
                         c.lg * 0.85,... % metabook table 7.1
                         c.lg * 0.15]; % metabook 7.1
    
    empty_cg_pos = [w.cg_pos.engine; 
                    w.cg_pos.vtail; 
                    w.cg_pos.htail; 
                    w.cg_pos.wing; 
                    w.cg_pos.fuselage;
                    w.cg_pos.xtra;
                    w.cg_pos.ICNIA;
                    w.cg_pos.databus;
                    w.cg_pos.INEWS;
                    w.cg_pos.VMS;
                    w.cg_pos.IRSTS;
                    w.cg_pos.AESA;
                    w.cg_pos.EES;
                    w.cg_pos.APU;
                    w.cg_pos.cannon;
                    w.cg_pos.lg_main;
                    w.cg_pos.lg_nose;];
    
    w.cg_sum.empty = sum(empty_comp_weight);
    w.cg_pos_weighted.empty = empty_comp_weight * empty_cg_pos;
    
    w.cg.empty = w.cg_pos_weighted.empty./w.cg_sum.empty;    

                    
    %% FUEL CG %%

    fuel_comp_weight = [c.fuel * w.fuel_vol.fore_pct,...
                        c.fuel * w.fuel_vol.center_pct,...
                        c.fuel * w.fuel_vol.aft_pct,...  
                        c.fuel * w.fuel_vol.right_wing_pct,...
                        c.fuel * w.fuel_vol.left_wing_pct];
    
    fuel_cg_pos = [w.cg_pos.fore_fuel;         
                   w.cg_pos.center_fuel;                
                   w.cg_pos.aft_fuel;      
                   w.cg_pos.right_wing_fuel;     
                   w.cg_pos.left_wing_fuel;];

    w.cg_sum.fuel = sum(fuel_comp_weight);
    w.cg_pos_weighted.fuel = fuel_comp_weight * fuel_cg_pos;

    w.cg.fuel = w.cg_pos_weighted.fuel./w.cg_sum.fuel;


    %% WEAPONS CG %%

    w.cg_pos_weighted.loaded_feed_system  = w.cg_pos.cannon_feed_system * w.weapons.m61a1.loaded_feed_system; 
    w.cg_pos_weighted.bullets = w.cg_pos.cannon_feed_system * w.weapons.m61a1.bullets; 

    w.cg_pos_weighted.missiles12 = (w.cg_pos.missile_1 * w.weapons.missile) + (w.cg_pos.missile_2 * w.weapons.missile); 
    w.cg_pos_weighted.missiles34 = (w.cg_pos.missile_3 * w.weapons.missile) + (w.cg_pos.missile_4 * w.weapons.missile); 
  

    %% TOGW CG, FULLY LOADED AIRCRAFT %%

    w.cg.togw = (w.cg_pos_weighted.empty...
              + w.cg_pos_weighted.fuel...
              + w.cg_pos_weighted.loaded_feed_system...
              + w.cg_pos_weighted.missiles12...
              + w.cg_pos_weighted.missiles34)...
              / ...
              (w.cg_sum.empty...
              + w.cg_sum.fuel...
              + w.weapons.m61a1.loaded_feed_system...
              + w.weapons.missile*4);
                            
    %% RE ASSIGN AIRCRAFT STRUCT %%

    aircraft.weight = w;
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CG EXCURSION PLOTTING %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1 - empty weight
    % 2 - fuel - 100%
    % 3 - missiles 1 / 2 (bottom)
    % 4 - missiles 3 / 4 (
    % 5 - missiles 5 / 6 DEPRECATED DO NOT USE
    % 6 - loaded feed system (bullets + casings + feed system)
    % 7 - cannon bullets (firing all bullets but keeping the casings/feed system)
    % 8 - fuel - 50%
    % 9 - fuel - 25%
    % In order to "drop" one of the above (e.g. fire a missile) make the index negative in the array

    %% Ground loading sequence %%

    ground_loading = [1,2,3,4,6];

    % where excursions are calculated. the cg_excursion_dx_arr gives the x axis as a delta x, reference point the initial x
    [cg_excursion_arr, cg_excursion_dx_arr, cg_weight_arr] = cg_excursion_calc(aircraft, ground_loading); 
    figure();
    hold on;
    plot(cg_excursion_arr(:,1), cg_weight_arr, '-o', 'MarkerFaceColor', 'k')

    xlabel('Position of CG Relative to Nose [m]'); % TODO FIX COORDINATE SYSTEM
    ylabel('Aircraft Weight [kg]');
    title('CG Excursion Plot for Loading of Aircraft on the Ground');
    hold off; 

    %% Full mission sequence %%

    full_mission = [1, 2, 3, 4, 6, -8, -4, -3, -7, -8]; % negative values mean subtracting the weight

    [cg_excursion_arr_full_mission, cg_excursion_dx_arr, cg_weight_arr_full_mission] = cg_excursion_calc(aircraft, full_mission); 
    figure();
    hold on;

    % Define colors from the palette
    dark_blue = [0.20, 0.30, 0.40];  % Dark bluish-gray for the line
    light_blue = [0.70, 0.80, 0.90];  % Soft light blue for the marker face
    
    % Plot the data with the specified colors
    plot(cg_excursion_arr_full_mission(:,1), cg_weight_arr_full_mission, ...
    '-o', 'MarkerFaceColor', light_blue, 'MarkerEdgeColor', dark_blue, 'LineWidth', 1, 'Color', dark_blue);
    
    xlabel('Position of CG Relative to Nose [m]');
    ylabel('Aircraft Weight [kg]');
    title(['CG Excursion Plot for Full Mission:', newline(), 'Loading payload & fuel, Firing weapons, Using all fuel']);
    hold off; 

    aircraft.weight.cg.excursion_arr_full_mission = cg_excursion_arr_full_mission; % update aircraft struct


end