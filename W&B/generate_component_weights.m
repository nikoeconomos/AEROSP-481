function aircraft = generate_component_weights(aircraft)
% Description: This function follows after algorithm 5 in the metabook.
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
   

    %% FORMULAS AND CALCULATIONS %%

    MAC_calc = @(c_root, c_tip) 2/3*(c_root + c_tip - (c_root*c_tip)/(c_root + c_tip));

    xMAC_calc = @(xRLE, b, c_root, c_tip, sweep_LE) xRLE + b/6 * (c_root + 2*c_tip)/(c_root + c_tip) + tan(sweep_LE);

    x40MAC_calc = @(xMAC, MAC) xMAC + 0.4*MAC;

    %% FUDGE FACTORS %% 
   
    % (Metabook 7.3.4)

    aircraft.weight.wing_fudge_factor = 0.85;
    aircraft.weight.tail_fudge_factor = 0.83;
    aircraft.weight.fuselage_fudge_factor = 0.9;

    %%%%%%%%%%%%%%
    %% FUSELAGE %%
    %%%%%%%%%%%%%%

    aircraft.geometry.fuselage.S_wet = 90.9387; % m2 from CAD

    aircraft.weight.fuselage_area_density = 23; %kg/m2 metabook p76

    aircraft.weight.fuselage = (aircraft.geometry.fuselage.S_wet*aircraft.weight.fuselage_area_density) * aircraft.weight.fuselage_fudge_factor;

    %%%%%%%%%%
    %% WING %%
    %%%%%%%%%%

    aircraft.geometry.wing.AR = aircraft.geometry.AR; % not changing in the rest of the code for convience. Note

    % for convenience
    wing = aircraft.geometry.wing;

    wing.S_ref = 24.5; %m2

    wing.S_wet = wing.S_ref*2; %m2 APPROXIMATION, UPDATE WITH A BETTER ONE
    wing.b = sqrt(wing.AR*wing.S_ref);

    wing.c_root = 4.187;
    wing.taper_ratio = 0.35;

    wing.c_tip = wing.c_root*wing.taper_ratio;

    wing.xRLE = 7.175; %m positino of leading edge of the root chord
  
    %% WING MASS AND CG %%

    % AREA DENSITY ALREADY DEFINED IN GEOMETRY

    % weight
    aircraft.weight.wing = (wing.S_ref * aircraft.weight.wing_area_density) * aircraft.weight.wing_fudge_factor; % 44 * S

    % MAC and wing
    wing.MAC = MAC_calc(wing.c_root, wing.c_tip);

    wing.xMAC = xMAC_calc(wing.xRLE, wing.b, wing.c_root, wing.c_tip, wing.sweep_LE);

    x40MAC_wing = x40MAC_calc(wing.xMAC, wing.MAC);
    
    % re update
    aircraft.geometry.wing = wing;

    %%%%%%%%%%%%
    %% H TAIL %%
    %%%%%%%%%%%%

    aircraft.geometry.htail.AR = 5; % TODO: UPDATE

    % for convenience
    htail = aircraft.geometry.htail;

    % geometry
    htail.S_ref = 2*3.2601; %m2 1 triangle from cad * 2
    htail.S_wet = 2*htail.S_ref; %m2 APPROXIMATION, UPDATE WITH A BETTER ONE
    
    htail.b = sqrt( htail.AR * htail.S_ref);

    htail.c_root = 0.807; % m
    htail.taper_ratio = 0.5;

    htail.c_tip = htail.c_root*htail.taper_ratio;

    htail.sweep_LE = deg2rad(49.9); % radians

    htail.xRLE = 14.575; % x from the nose tip

    %% HTAIL MASS AND CG %%

    % density
    aircraft.weight.htail_area_density = 20; % kg/m2
    
    % weight calc
    aircraft.weight.htail = (htail.S_ref*aircraft.weight.htail_area_density) * aircraft.weight.tail_fudge_factor;

    % MAC and CG = at 0.4MAC
    htail.MAC  = MAC_calc(htail.c_root, htail.c_tip);

    htail.xMAC = xMAC_calc(htail.xRLE, htail.b, htail.c_root, htail.c_tip, htail.sweep_LE);

    x40MAC_htail = x40MAC_calc(htail.xMAC, htail.MAC);
    
    % re update
    aircraft.geometry.htail = htail;

    %%%%%%%%%%%%
    %% V TAIL %%
    %%%%%%%%%%%%

    aircraft.geometry.vtail.AR = 2; % TODO: UPDATE

    % for convenience
    vtail = aircraft.geometry.vtail;

    vtail.S_ref = 1.5488*2; %m2, 1 triangle from cad * 2
    vtail.S_wet = 2*vtail.S_ref; %m2 APPROXIMATION, UPDATE WITH A BETTER ONE

    vtail.b = sqrt(vtail.AR * vtail.S_ref);

    vtail.c_root = 0.977;
    vtail.taper_ratio = 0.35;

    vtail.c_tip = vtail.c_root*vtail.taper_ratio;   

    vtail.sweep_LE = deg2rad(55); % radians
    
    vtail.xRLE = htail.xRLE; %m same as htail TODO UPDATE IF NECESSARY

    %% VTAIL MASS AND CG %%

    % density
    aircraft.weight.vtail_area_density = 26; %kg/m2
    
    % weight calc
    aircraft.weight.vtail = (vtail.S_ref*aircraft.weight.vtail_area_density) * aircraft.weight.tail_fudge_factor;

    % MAC and CG = at 0.4MAC
    vtail.MAC = MAC_calc(vtail.c_root, vtail.c_tip);

    vtail.xMAC = xMAC_calc(vtail.xRLE, vtail.b, vtail.c_root, vtail.c_tip, vtail.sweep_LE);

    x40MAC_vtail = x40MAC_calc(vtail.xMAC, vtail.MAC);

    % re update struct
    aircraft.geometry.vtail = vtail;
      
    %%%%%%%%%%%%%%%%%%%
    %% ENGINE WEIGHT %%
    %%%%%%%%%%%%%%%%%%%

    aircraft.weight.engine_dry = 1800; %kg, the f110

    theoretical_engine_weight     = w_eng_calc(aircraft.propulsion.T_max);
    theoretical_engine_dry_weight = ConvMass((0.521*ConvForce(aircraft.propulsion.T_max, 'N', 'lbf')^0.9),'lbm', 'kg');
    aircraft.weight.engine_total  = theoretical_engine_weight - theoretical_engine_dry_weight  + aircraft.weight.engine_dry;

    %%%%%%%%%%%%
    %% CANNON %%
    %%%%%%%%%%%%
    
    % after firing everything
    aircraft.weight.m61a1.lost_mass     = aircraft.weight.m61a1.bullet*aircraft.weight.m61a1.num_rounds;
    aircraft.weight.m61a1.returned_mass = aircraft.weight.m61a1.feed_system + aircraft.weight.m61a1.casing*aircraft.weight.m61a1.num_rounds;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% TOGW UPDATE, ALGORITHM 5 (METABOOK) %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % for convenience
    w = aircraft.weight;

    %% ALGORITHM %%    

    % intial estimate
    [W_0, ff] = togw_as_func_of_T_S_calc(aircraft, aircraft.propulsion.T_max, aircraft.geometry.wing.S_ref);

    tol = 1e-3;
    converged = false;
    while converged == false
        
        w.fuel = ff    * W_0;
        w.lg   = 0.043 * W_0;
        w.xtra = 0.17  * W_0;

        W_0_new = w.engine_total + w.wing + w.htail + w.vtail + w.fuselage + w.xtra + w.lg + w.fuel + w.payload;

        if abs(W_0_new - W_0) <= tol
            converged = true;
        end

        W_0 = W_0_new;
    end

    %% UPDATE VALUES %%

    % re update with new vals
    w.ff   = ff;
    w.fuel = ff    * W_0;
    w.lg   = 0.043 * W_0;
    w.xtra = 0.17  * W_0;

    % togw, empty weight, landing weight
    w.togw = W_0;
    w.empty = W_0*w.W_e_regression_calc(w.togw);
    w.max_landing_weight = (1-(w.PDI_ff/2))* w.togw;

    %%%%%%%%%%%%%%%%%
    %% FUEL VOLUME %%
    %%%%%%%%%%%%%%%%%

    w.fuel_vol.total_used  = w.fuel/w.fuel_density; %m3

    f = w.fuel_vol;
    
    f.nose            = 1.474; %m3
    f.cannon          = 1.204;
    f.left_wing       = 1.478;
    f.right_wing      = f.left_wing; 
    f.left_conformal  = 0.571;
    f.right_conformal = f.left_conformal;
    f.engine          = 1.267;

    f.total_available = sum([f.nose, f.cannon, f.left_wing, f.right_wing, f.left_conformal, f.right_conformal, f.engine]);

    if f.total_available-f.total_used < 0
        error('Not enough fuel available silly!')
    end

    f.nose_pct            = f.nose           / f.total_used; % percent
    f.cannon_pct          = f.cannon         / f.total_used;
    f.engine_pct          = f.engine         / f.total_used;
    f.left_wing_pct       = f.left_wing      / f.total_used;
    f.right_wing_pct      = f.right_wing     / f.total_used;
    f.left_conformal_pct  = f.left_conformal / f.total_used; 
    f.right_conformal_pct = f.right_conformal/ f.total_used; 

    w.fuel_vol = f;
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %% CENTER OF GRAVITY %%
    %%%%%%%%%%%%%%%%%%%%%%%

    %% CG LOCATIONS %%  

    w.cg_pos.engine = [14.32, 0, 0.724];

    w.cg_pos.vtail  = [x40MAC_vtail, 0, 0];
    w.cg_pos.htail  = [x40MAC_htail, 0, 0];
    w.cg_pos.wing   = [x40MAC_wing, 0, 0.863];

    w.cg_pos.fuselage = [10.634, 0, 0.517]; % m, CENTROID OF THE FUSELAGE FROM CAD

    w.cg_pos.cannon             = [7.124, 0.661, 0.957];
    w.cg_pos.cannon_feed_system = [7.5445, 0.411, 0.957]; 

    w.cg_pos.missile_1 = [8.065, -0.47,  0.367];
    w.cg_pos.missile_2 = [8.065, 0.47,  0.367];

    w.cg_pos.missile_3 = [8.065, -0.74, 0.627];
    w.cg_pos.missile_4 = [8.065, 0.74, 0.627];

    w.cg_pos.missile_5 = [8.065, -0.2, 0.627];
    w.cg_pos.missile_6 = [8.065, 0.2, 0.627];

    w.cg_pos.xtra = [7.9029, 0, 0]; % 45% of fuse lngth (raymer table)

    w.cg_pos.nose_fuel            = [5.876, -0.084,  0.743];
    w.cg_pos.cannon_fuel          = [7.78,  -0.096,  1.135];
    w.cg_pos.engine_fuel          = [12.989, 0,      0.459];
    w.cg_pos.left_wing_fuel       = [10.505, -2.395, 0.861];
    w.cg_pos.right_wing_fuel      = [10.505, 2.395,  0.861]; 
    w.cg_pos.left_conformal_fuel  = [10.726, -0.699, 1.307];
    w.cg_pos.right_conformal_fuel = [10.726, 0.699,  1.307];

    %w.cg_pos.lg_main = [?,?,?];
    %w.cg_pos.lg_nose = [?,?,?];

    %% MAKE EMPTY ARRAYS %%


    %% CALCULATE OVERALL CG %%
  
    cg_sum = zeros(3, 1);
    % for each coordinate, multiply component weight by cg position
    for i = 1:3
        
        cg_sum(i) = sum([...
            w.cg_pos.engine(i)       * w.engine_total; 
            w.cg_pos.vtail(i)        * w.vtail;
            w.cg_pos.htail(i)        * w.htail; 
            w.cg_pos.wing(i)         * w.wing;
            w.cg_pos.fuselage(i)     * w.fuselage; 
            w.cg_pos.cannon(i)       * w.m61a1.cannon; 
            w.cg_pos.cannon_feed_system(i) * w.m61a1.returned_mass; 
            w.cg_pos.cannon_feed_system(i) * w.m61a1.lost_mass; 
            w.cg_pos.missile_1(i)    * w.missile; 
            w.cg_pos.missile_2(i)    * w.missile; 
            w.cg_pos.missile_3(i)    * w.missile; 
            w.cg_pos.missile_4(i)    * w.missile; 
            w.cg_pos.missile_5(i)    * w.missile; 
            w.cg_pos.missile_6(i)    * w.missile; 
            w.cg_pos.xtra(i)         * w.xtra; 
            w.cg_pos.nose_fuel(i)            * w.fuel * w.fuel_vol.nose_pct; 
            w.cg_pos.cannon_fuel(i)          * w.fuel * w.fuel_vol.cannon_pct; 
            w.cg_pos.engine_fuel(i)          * w.fuel * w.fuel_vol.engine_pct; 
            w.cg_pos.left_wing_fuel(i)       * w.fuel * w.fuel_vol.left_wing_pct; 
            w.cg_pos.right_wing_fuel(i)      * w.fuel * w.fuel_vol.right_wing_pct; 
            w.cg_pos.left_conformal_fuel(i)  * w.fuel * w.fuel_vol.left_conformal_pct; 
            w.cg_pos.right_conformal_fuel(i) * w.fuel * w.fuel_vol.right_conformal_pct; 
            %w.cg_pos.lg_nose(i) * w.lg_nose ...
            %w.cg_pos.lg_main(i) * w.lg_main ...
        ]);

        w.cg(i) = cg_sum(i)/(w.togw-w.lg); % switch out when placed LG
        %w.cg(i) = cg_sum(i)/(w.togw);
    end
    w.cg

    %%%%%%%%%%%%%%%%%%%
    %% UPDATE STRUCT %%
    %%%%%%%%%%%%%%%%%%%

    aircraft.weight = w;
    aircraft.weight

    %% COST UPDATE %%
    aircraft.cost.avg_flyaway_cost = avg_flyaway_cost_calc(aircraft.weight.togw);
    

end
    