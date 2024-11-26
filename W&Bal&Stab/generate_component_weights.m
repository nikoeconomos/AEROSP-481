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

    aircraft.weight.func.MAC_calc   = @(c_root, c_tip) 2/3*(c_root + c_tip - (c_root*c_tip)/(c_root + c_tip));
    aircraft.weight.func.y_MAC_calc = @(taper_ratio, b) b * ( (1 + 2*taper_ratio) / (1 + taper_ratio))/6;

    aircraft.weight.func.xMAC_calc = @(xRLE, b, c_root, c_tip, sweep_LE) xRLE + b/6 * (c_root + 2*c_tip)/(c_root + c_tip) + tan(sweep_LE);

    aircraft.weight.func.x40MAC_calc = @(xMAC, MAC) xMAC + 0.4*MAC;

    %% FUDGE FACTORS %% 
   
    % (Metabook 7.3.4)
    % Chose upper end of fudge factors given that the lightest possible
    % strucutre may also be the most expensive one but it would be
    % unreasonable not to include modern weight saving materials and
    % configurations at all

    aircraft.weight.fudge_factor.wing = 0.9;
    aircraft.weight.fudge_factor.tail = 0.88;
    aircraft.weight.fudge_factor.fuselage = 0.95;

    %%%%%%%%%%%%%%
    %% FUSELAGE %%
    %%%%%%%%%%%%%%

    aircraft.geometry.fuselage.S_wet = 90.9387; % m2 from CAD

    aircraft.geometry.fuselage.width = 2.1; % max width of fuselage from CAD
    aircraft.geometry.fuselage.length = 17.576; % length of fuselage from CAD
    aircraft.geomtery.fuselage.A_max = NaN; % TODO UPDATE

    aircraft.weight.density.fuselage_area = 23; %kg/m2 metabook p76

    aircraft.weight.components.fuselage = (aircraft.geometry.fuselage.S_wet*aircraft.weight.density.fuselage_area)...
                                          *aircraft.weight.fudge_factor.fuselage;

    %%%%%%%%%%%%%%%%%%%
    %% WING GEOMETRY %%
    %%%%%%%%%%%%%%%%%%%

    aircraft.geometry.wing.AR = aircraft.geometry.wing.AR; % AR was already set in geometry

    % for convenience
    wing = aircraft.geometry.wing;

    wing.S_ref = aircraft.geometry.wing.S_ref; %m2, updated in geometry

    %wing.S_wet = wing.S_ref*2; %m2 TODO APPROXIMATION, UPDATE WITH A BETTER ONE
    wing.S_wet = 24.716*2;
    wing.b = sqrt(wing.AR*wing.S_ref);

    wing.taper_ratio = 0.35;

    wing.c_root = 2*wing.S_ref / ( (1+wing.taper_ratio) * wing.b); % TODO where does this come from? - CAD ACCURATE
    wing.c_tip = wing.c_root*wing.taper_ratio;

    wing.t_c_root                    = 0.05; % 5% tc ratio, from our design airfoil
    wing.chordwise_loc_max_thickness = 0.50; % pulled from cad

    %sweeps
    wing.sweep_LE = aircraft.geometry.wing.sweep_LE; % in radians, set in generate_geometry
    wing.sweep_QC = atan( tan(wing.sweep_LE) - (4 / wing.AR) * ((0.25 * (1 - wing.taper_ratio)) / (1 + wing.taper_ratio)) ); % formula from aerodynamics slide 24
    wing.sweep_HC = atan( tan(wing.sweep_LE) - (4 / wing.AR) * ((0.50 * (1 - wing.taper_ratio)) / (1 + wing.taper_ratio)) );
    wing.sweep_TE = atan( tan(wing.sweep_LE) - (4 / wing.AR) * ((1.00 * (1 - wing.taper_ratio)) / (1 + wing.taper_ratio)) );

    % locations/MAC
    wing.xRLE = 7.175; %m positino of leading edge of the root chord, from CAD
    wing.xR25 = wing.xRLE + 0.25*wing.c_root; % position of quarter chord at root of wing

    wing.MAC   = aircraft.weight.func.MAC_calc  (wing.c_root, wing.c_tip);
    wing.y_MAC = aircraft.weight.func.y_MAC_calc(wing.taper_ratio, wing.b);

    wing.xMAC   = aircraft.weight.func.xMAC_calc(wing.xRLE, wing.b, wing.c_root, wing.c_tip, wing.sweep_LE);
    wing.x40MAC = aircraft.weight.func.x40MAC_calc(wing.xMAC, wing.MAC);

    % Flaps and slats
    
    wing.S_ctrl_surf = 3.39*2; % from CAD TODO UPDATE

    wing.S_flapped = 10.588*2; % TODO UPDATE
    wing.S_slatted = 10.588*2; % TODO UPDATE

    wing.sweep_flap_hinge = 0;

    wing.c_flapped_over_c = 0.3; % ratio of flapped chord to chord
    wing.c_slatted_over_c = 0.1; % TODO Verify/update

    wing.flap_deflect_takeoff = deg2rad(15);
    wing.flap_deflect_landing = deg2rad(30);
    wing.slat_deflect_takeoff = deg2rad(7);
    wing.slat_deflect_landing = deg2rad(16);
    
    % re update aircraft struct
    aircraft.geometry.wing = wing;
  
    %%%%%%%%%%%%%%%
    %% WING MASS %%
    %%%%%%%%%%%%%%%

    % AREA DENSITY ALREADY DEFINED IN GEOMETRY

    % Area based calculation
    aircraft.weight.func.wing_weight_area = @(S_ref) (S_ref * aircraft.weight.density.wing_area) * aircraft.weight.fudge_factor.wing; % 44 * S

    % RAYMER METABOOK 7.11, cargo/transport
    N_z = aircraft.performance.load_factor.ultimate_upper_limit;
    aircraft.weight.func.wing_weight_raymer = @(W_0) ConvMass( 0.0051 * ( ConvMass(W_0, 'kg', 'lbm') * N_z)^0.557 ...
                                                                    * ConvArea(wing.S_ref, 'm2', 'ft2')^0.649 * wing.AR^0.5 ... 
                                                                    * (wing.t_c_root)^(-0.4) * (1 + wing.taper_ratio)^0.1 * (cos(wing.sweep_QC))^(-1) ...
                                                                    * ConvArea(wing.S_ctrl_surf, 'm2', 'ft2')^0.1, ...
                                                                    'lbm', 'kg'); % metabook 7.11  
    
    % KROO METABOOK 7.12, general?
    n = aircraft.performance.load_factor.ultimate_upper_limit;
    aircraft.weight.func.wing_weight_kroo   = @(W_0, W_zf) ConvMass( 4.22 * ConvArea(wing.S_ref, 'm2', 'ft2') ... 
                                                                        + 1.642e-6 * (n * ConvLength(wing.b^3, 'm', 'ft') * sqrt(ConvMass(W_0, 'kg', 'lbm') * ConvMass(W_zf, 'kg', 'lbm'))...
                                                                            * (1 + 2 * wing.taper_ratio)) ...
                                                                          / ( ConvArea(wing.S_ref, 'm2', 'ft2') * (wing.t_c_root) ...
                                                                            * cos(wing.sweep_QC)^2 * (1 + wing.taper_ratio)), ...
                                                                            'lbm', 'kg'); % sweep QC should be of the structural elastic axis
    
    % ROSKAM PART 5, 5.9 USAF
    % A = Aspect ratio AR
    % S = wing area in ft^2
    K_w = 1; %for fixed wing aircraft
    n_ult = aircraft.performance.load_factor.ultimate_upper_limit;
    aircraft.weight.func.wing_weight_roskam_USAF = @(WTO) ...
                                                        ConvMass( 3.08 * ( ...
                                                                         ( (K_w * n_ult * ConvMass(WTO, 'kg', 'lbm') ) / (wing.t_c_root) ) ...
                                                                         * ( ( tan(wing.sweep_LE) - 2 * (1 - wing.taper_ratio) / (wing.AR * (1 + wing.taper_ratio) ) )^2 + 1) * 10^-6 ...
                                                                         )^0.593 ...
                                                                         * ( wing.AR*( 1 + wing.taper_ratio ) )^0.89 * ( ConvArea(wing.S_ref, 'm2', 'ft2') )^0.741 ...
                                                                         * aircraft.weight.fudge_factor.wing, ...
                                                                         'lbm', 'kg');

    % ROSKAM PART 5, 5.10 USN
    % A = Aspect ratio AR
    % S = wing area in ft^2
    K_w = 1; %for fixed wing aircraft
    n_ult = aircraft.performance.load_factor.ultimate_upper_limit;
    aircraft.weight.func.wing_weight_roskam_USN = @(WTO) ...
                                                       ConvMass( 19.29 * ( ...
                                                                         ( (K_w * n_ult * ConvMass(WTO, 'kg', 'lbm') ) / (wing.t_c_root) ) ...
                                                                         * ( ( tan(wing.sweep_LE) - 2 * (1 - wing.taper_ratio) / (wing.AR * (1 + wing.taper_ratio) ) )^2 + 1) * 10^-6 ...
                                                                         )^0.464 ...
                                                                         * ( wing.AR*( 1 + wing.taper_ratio ) )^0.70 * ( ConvArea(wing.S_ref, 'm2', 'ft2') )^0.58 ...
                                                                         * aircraft.weight.fudge_factor.wing, ...
                                                                         'lbm', 'kg');

    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% GENERATE EMPENNAGE PARAMETERS %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    aircraft = generate_empennage_params(aircraft);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% EMPENNAGE MASS AND CG %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% HTAIL MASS AND CG %%

    htail = aircraft.geometry.htail;

    % density and weight calc
    aircraft.weight.density.htail_area = 20; % kg/m2
    aircraft.weight.components.htail   = (htail.S_ref*aircraft.weight.density.htail_area) * aircraft.weight.fudge_factor.tail;
    
    % re update
    aircraft.geometry.htail = htail;

    %% VTAIL MASS AND CG %%

    vtail = aircraft.geometry.vtail;

    % density and weight calc
    aircraft.weight.density.vtail_area = 26; %kg/m2
    aircraft.weight.components.vtail   = (vtail.S_ref*aircraft.weight.density.vtail_area) * aircraft.weight.fudge_factor.tail;

    % re update struct
    aircraft.geometry.vtail = vtail;
      
    %%%%%%%%%%%%%%%%%%%
    %% ENGINE WEIGHT %%
    %%%%%%%%%%%%%%%%%%%

    aircraft.weight.components.engine_dry = 1800; %kg, the f110

    theoretical_engine_weight          = w_eng_calc(aircraft.propulsion.T_max);
    theoretical_engine_dry_weight      = ConvMass((0.521*ConvForce(aircraft.propulsion.T_max, 'N', 'lbf')^0.9),'lbm', 'kg');
    aircraft.weight.components.engine  = theoretical_engine_weight - theoretical_engine_dry_weight  + aircraft.weight.components.engine_dry;

    %%%%%%%%%%%%
    %% CANNON %%
    %%%%%%%%%%%%
    
    aircraft.weight.weapons.m61a1.loaded_feed_system = aircraft.weight.weapons.m61a1.feed_system + aircraft.weight.weapons.m61a1.ammo;

    % after firing everything
    aircraft.weight.weapons.m61a1.bullets       = aircraft.weight.weapons.m61a1.bullet*aircraft.weight.weapons.m61a1.num_rounds;
    aircraft.weight.weapons.m61a1.returned_mass = aircraft.weight.weapons.m61a1.feed_system + aircraft.weight.weapons.m61a1.casing*aircraft.weight.weapons.m61a1.num_rounds;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% GOVERNMENT FURNISHED EQUIPMENT %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    w = aircraft.weight;

    % Define mass of each component in kg
    w.gfe.ICNIA    = ConvMass(100, 'lbm', 'kg');
    w.gfe.data_bus = ConvMass(10, 'lbm', 'kg');
    w.gfe.INEWS    = ConvMass(100, 'lbm', 'kg');

    w.gfe.vehicle_management_system = ConvMass(50, 'lbm', 'kg');

    w.gfe.electrical_system  = ConvMass(300, 'lbm', 'kg');
    w.gfe.APU                = ConvMass(100, 'lbm', 'kg');

    w.gfe.IRSTS               = ConvMass(50, 'lbm', 'kg');
    w.gfe.active_array_radar  = ConvMass(450, 'lbm', 'kg');

       
    % Calculate the total mass of all components
    w.components.gfe_total = w.gfe.ICNIA + w.gfe.data_bus + w.gfe.INEWS + ...
                             w.gfe.vehicle_management_system + w.gfe.electrical_system + ...
                             w.gfe.APU + w.gfe.IRSTS + w.gfe.active_array_radar;

    aircraft.weight = w;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% TOGW UPDATE, ALGORITHM 5 (METABOOK) %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % for convenience
    w = aircraft.weight;

    %% ALGORITHM 5 %%    
    
    % intial estimate FOR THE REPORT, VALUES NOT USED
    [W_0, ff] = togw_as_func_of_T_S_calc(aircraft, aircraft.propulsion.T_max, aircraft.geometry.wing.S_ref);
    W_e_init  = W_0*aircraft.weight.W_e_regression_calc(W_0);
    W_f_init  = ff * W_0;
    % [avg_flyaway_cost_250, ~]  = avg_flyaway_cost_calc(W_0, 250)
    % [avg_flyaway_cost_500, ~]  = avg_flyaway_cost_calc(W_0, 500)
    % [avg_flyaway_cost_1000, ~] = avg_flyaway_cost_calc(W_0, 1000)

    tol = 1e-3;
    converged = false;

    aircraft.weight.ff = ff_total_improved_calc(aircraft, W_0);

    while converged == false
        
        w.ff = ff_total_improved_calc(aircraft, W_0);
        
        w.components.fuel = ff    * W_0;
        w.components.lg   = 0.043 * W_0;
        w.components.xtra = 0.17  * W_0 - w.components.gfe_total;

        % Use Roskam; It is the most viable for fighters
        %w.components.wing = w.func.wing_weight_raymer(W_0);
        %w.components.wing = w.func.wing_weight_kroo(W_0, w.components.fuel);
        %w.components.wing = w.func.wing_weight_roskam_USN(W_0);
        w.components.wing = w.func.wing_weight_roskam_USAF(W_0);
        

        W_0_new = w.components.engine ...
                + w.components.wing ...
                + w.components.htail ...
                + w.components.vtail ...
                + w.components.fuselage ...
                + w.components.gfe_total ...
                + w.components.xtra ...
                + w.components.lg ...
                + w.components.fuel ...
                + w.components.payload;

        if abs(W_0_new - W_0) <= tol
            converged = true;
        end

        W_0 = W_0_new;
    end

    %% UPDATE VALUES %%

    % re update with new vals
    w.ff   = ff;
    w.components.fuel = ff    * W_0;
    w.components.lg   = 0.043 * W_0;
    w.components.xtra = 0.17  * W_0 - w.components.gfe_total;

    %w.components.wing = aircraft.weight.func.wing_weight_area(aircraft.geometry.wing.S_ref);
    %w.components.wing = w.func.wing_weight_raymer(W_0);
    %w.components.wing = w.func.wing_weight_kroo(W_0, w.components.fuel);
    %w.components.wing = w.func.wing_weight_roskam_USN(W_0);
    w.components.wing = w.func.wing_weight_roskam_USAF(W_0);

    % togw, empty weight, landing weight
    w.togw = W_0;
    w.empty = w.togw - w.components.fuel - w.components.payload;
    w.max_landing_weight = (1-(w.PDI_ff/2))* w.togw;

    w.half_fuel = (1-(w.ff/2))* w.togw;

    %%%%%%%%%%%%%%%%%
    %% FUEL VOLUME %%
    %%%%%%%%%%%%%%%%%

    w.fuel_vol.total_used  = w.components.fuel/w.density.fuel; %m3

    f = w.fuel_vol;
    
    f.nose            = 0.90; %m3
    f.cannon          = 3.608;
    f.left_wing       = 0.976;
    f.right_wing      = f.left_wing; 
    f.rear            = 1.735;

    f.total_available = sum([f.nose, f.cannon, f.left_wing, f.right_wing,f.rear]);

    if f.total_available-f.total_used < 0
        %error('Not enough fuel available silly!')
    end

    f.nose_pct            = f.nose           / f.total_used; % percent
    f.cannon_pct          = f.cannon         / f.total_used;
    f.left_wing_pct       = f.left_wing      / f.total_used;
    f.right_wing_pct      = f.right_wing     / f.total_used;
    f.rear_pct            = f.rear           / f.total_used;

    w.fuel_vol = f;

    %%%%%%%%%%%%%%
    %% MISC GFE %%
    %%%%%%%%%%%%%%

    w.components.ICNIA = ConvMass(100,'lbm','kg');
    w.components.databus = ConvMass(10,'lbm','kg');
    w.components.INEWS = w.components.ICNIA;
    w.components.VMS = ConvMass(50,'lbm','kg');
    w.components.IRSTS = w.components.VMS;
    w.components.AESA = ConvMass(450,'lbm','kg');
    w.components.EES = ConvMass(220,'lbm','kg');
    w.components.APU = ConvMass(100,'lbm','kg');

    %%%%%%%%%%%%%%%%%%%
    %% UPDATE STRUCT %%
    %%%%%%%%%%%%%%%%%%%

    aircraft.weight = w;
    plot_weight_pie_chart(aircraft);

    %%%%%%%%%%%%%%%%%%%%
    %% CG AND SM CALCULATION %%
    %%%%%%%%%%%%%%%%%%%%

    aircraft = cg_calc_plot(aircraft); % TODO UPDATE MISSION PROFILE IF MISSILES CHANGE
    
    mach = [0.28, 0.5, 0.85, 1.0, 1.2]; % Find SM at various Mach numbers TODO why can't 1.4 and 1.6 work
    aircraft = SM_calc_plot(aircraft, mach); % sets the np and sm arrays for a full mission profile.

    %aircraft = empennage_aerodynamics_calc(aircraft);

    %%%%%%%%%%%%%%%%%
    %% COST UPDATE %%
    %%%%%%%%%%%%%%%%%

    aircraft.cost.avg_flyaway_cost = avg_flyaway_cost_calc(aircraft.weight.togw, 1000);
    

end
    