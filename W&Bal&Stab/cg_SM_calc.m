function aircraft = cg_SM_calc(aircraft)
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

    w.cg_pos.engine = [14.32, 0, 0.724];

    w.cg_pos.vtail  = [aircraft.geometry.vtail.x40MAC, 0, 0];
    w.cg_pos.htail  = [aircraft.geometry.htail.x40MAC, 0, 0];
    w.cg_pos.wing   = [aircraft.geometry.wing.x40MAC,  0, 0.863];

    w.cg_pos.fuselage = [10.634, 0, 0.517]; % m, CENTROID OF THE FUSELAGE FROM CAD

    w.cg_pos.cannon             = [7.124, 0.661, 0.957];
    w.cg_pos.cannon_feed_system = [7.5445, 0.411, 0.957]; 

    w.cg_pos.missile_1 = [8.065, -0.47,  0.367];
    w.cg_pos.missile_2 = [8.065, 0.47,  0.367];

    w.cg_pos.missile_3 = [8.065, -0.74, 0.627];
    w.cg_pos.missile_4 = [8.065, 0.74, 0.627];

    w.cg_pos.missile_5 = [8.065, -0.2, 0.627];
    w.cg_pos.missile_6 = [8.065, 0.2, 0.627];

    w.cg_pos.xtra = [7.9029, 0, 0]; % 45% of fuselage length (raymer table)

    w.cg_pos.nose_fuel            = [5.876, -0.084,  0.743];
    w.cg_pos.cannon_fuel          = [7.78,  -0.096,  1.135];
    w.cg_pos.engine_fuel          = [12.989, 0,      0.459];
    w.cg_pos.left_wing_fuel       = [10.505, -2.395, 0.861];
    w.cg_pos.right_wing_fuel      = [10.505, 2.395,  0.861]; 
    w.cg_pos.left_conformal_fuel  = [10.726, -0.699, 1.307];
    w.cg_pos.right_conformal_fuel = [10.726, 0.699,  1.307];

    %w.cg_pos.lg_main = [?,?,?];
    %w.cg_pos.lg_nose = [?,?,?];
 
    %% EMPTY CG %%

    empty_comp_weight = [c.engine,...
                         c.vtail,...
                         c.htail,...
                         c.wing,...
                         c.fuselage,...
                         c.xtra,...
                         w.weapons.m61a1.cannon]; % NOTE: ADD LANDING GEAR WHEN SIZED/PLACED
    
    empty_cg_pos = [w.cg_pos.engine; 
                    w.cg_pos.vtail; 
                    w.cg_pos.htail; 
                    w.cg_pos.wing; 
                    w.cg_pos.fuselage;
                    w.cg_pos.xtra;
                    w.cg_pos.cannon;]; % TODO ADD LANDING GEAR
    
    w.cg_sum.empty = sum(empty_comp_weight);
    w.cg_pos_weighted.empty = empty_comp_weight * empty_cg_pos;
    
    w.cg.empty = w.cg_pos_weighted.empty./w.cg_sum.empty;    

                    
    %% FUEL CG %%

    fuel_comp_weight = [c.fuel * w.fuel_vol.nose_pct,...
                        c.fuel * w.fuel_vol.cannon_pct,...
                        c.fuel * w.fuel_vol.engine_pct,...
                        c.fuel * w.fuel_vol.left_wing_pct,...  
                        c.fuel * w.fuel_vol.right_wing_pct,...
                        c.fuel * w.fuel_vol.left_conformal_pct,... 
                        c.fuel * w.fuel_vol.right_conformal_pct];
    
    fuel_cg_pos = [w.cg_pos.nose_fuel;         
                   w.cg_pos.cannon_fuel;         
                   w.cg_pos.engine_fuel;         
                   w.cg_pos.left_wing_fuel;      
                   w.cg_pos.right_wing_fuel;     
                   w.cg_pos.left_conformal_fuel; 
                   w.cg_pos.right_conformal_fuel;];

    w.cg_sum.fuel = sum(fuel_comp_weight);
    w.cg_pos_weighted.fuel = fuel_comp_weight * fuel_cg_pos; % NOTE: THIS CODE ASSUMES THAT ALL FUEL TANKS ARE FULL. MUST BE EDITED FOR DIFFERENT MISSIONS

    w.cg.fuel = w.cg_pos_weighted.fuel./w.cg_sum.fuel;


    %% WEAPONS CG %%

    w.cg_pos_weighted.loaded_feed_system  = w.cg_pos.cannon_feed_system * w.weapons.m61a1.loaded_feed_system; 
    w.cg_pos_weighted.bullets = w.cg_pos.cannon_feed_system * w.weapons.m61a1.bullets; 

    w.cg_pos_weighted.missiles12 = (w.cg_pos.missile_1 * w.weapons.missile) + (w.cg_pos.missile_2 * w.weapons.missile); 
    w.cg_pos_weighted.missiles34 = (w.cg_pos.missile_3 * w.weapons.missile) + (w.cg_pos.missile_4 * w.weapons.missile); 
    w.cg_pos_weighted.missiles56 = (w.cg_pos.missile_5 * w.weapons.missile) + (w.cg_pos.missile_5 * w.weapons.missile); 

    %% TOGW CG, FULLY LOADED AIRCRAFT %%

    w.cg.togw = (w.cg_pos_weighted.empty...
              + w.cg_pos_weighted.fuel...
              + w.cg_pos_weighted.loaded_feed_system...
              + w.cg_pos_weighted.missiles12...
              + w.cg_pos_weighted.missiles34...
              + w.cg_pos_weighted.missiles56)...
              / ...
              (w.cg_sum.empty...
              + w.cg_sum.fuel...
              + w.weapons.m61a1.loaded_feed_system...
              + w.weapons.missile*6);
                            
    %% RE ASSIGN AIRCRAFT STRUCT %%

    aircraft.weight = w;
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CG EXCURSION PLOTTING %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1 - empty weight
    % 2 - fuel - 100%
    % 3 - missiles 1 / 2 (bottom)
    % 4 - missiles 3 / 4 (
    % 5 - missiles 5 / 6
    % 6 - loaded feed system (bullets + casings + feed system)
    % 7 - cannon bullets (firing all bullets but keeping the casings/feed system)
    % 8 - fuel - 50%
    % 9 - fuel - 25%
    % In order to "drop" one of the above (e.g. fire a missile) make the index negative in the array

    %% Ground loading sequence %%

    ground_loading = [1,2,3,4,5,6];

    % where excursions are calculated. the cg_excursion_dx_arr gives the x axis as a delta x, reference point the initial x
    [cg_excursion_arr, cg_excursion_dx_arr, cg_weight_arr] = cg_excursion_calc(aircraft, ground_loading); 
    figure();
    hold on;
    plot(cg_excursion_arr(:,1), cg_weight_arr, '-o', 'MarkerFaceColor', 'k')
    xlabel('Delta X of CG [m]');
    ylabel('Position of CG Relative to Nose [kg]');
    title('CG Excursion Plot for Loading of Aircraft on the Ground');
    hold off; 

    %% Full mission sequence %%

    full_mission = [1, 2, 3, 4, 5, 6, -8, -5, -4, -3, -7, -8]; % negative values mean subtracting the weight

    [cg_excursion_arr, cg_excursion_dx_arr, cg_weight_arr] = cg_excursion_calc(aircraft, full_mission); 
    figure();
    hold on;
    plot(cg_excursion_arr(:,1), cg_weight_arr, '-o', 'MarkerFaceColor', 'k')
    xlabel('Position of CG Relative to Nose [m]');
    ylabel('Aircraft Weight [kg]');
    title(['CG Excursion Plot for Full Mission:', newline(), 'loading, dropping all payload, using all fuel']);
    hold off; 

    %%%%%%%%%%%%%%%%%%%%
    %% SM CALCULATION %%
    %%%%%%%%%%%%%%%%%%%%

    mach = [0.28,0.5,0.85,1.0,1.2]; % Find SM at various Mach numbers
    [sm_arr,np_arr] = SM_calc(aircraft, cg_excursion_arr, mach);
 
end