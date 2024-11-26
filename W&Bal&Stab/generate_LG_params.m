function aircraft = generate_LG_params(aircraft)
% Description: This function generates the LG parameters for our aircraft.
% Tire loads, load distribution validation
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    cg_excursion_arr - cg excurison for a full mission demonstration
%    
%    
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft
%                       
% 
% See also: 
% script
% Author:                          Joon
% Version history revision notes:
%                                  v1: 11/16/24    
    W = aircraft.weight.togw;

    fwd_CGx  = min(aircraft.weight.cg.excursion_arr_full_mission(:,1)); % farthest forward CG value, x only
    rear_CGx = max(aircraft.weight.cg.excursion_arr_full_mission(:,1)); % farthest backward CG value, x only

    nose_LGx = 5.175;  %m; location of nose landing gear
    main_LGx = 11.375; %m; location of main landing gear

    B  = main_LGx-nose_LGx; %m; distance between landing gears

    Nf = fwd_CGx  - nose_LGx;
    Na = rear_CGx - nose_LGx;
    Mf = main_LGx - fwd_CGx;
    Ma = main_LGx - rear_CGx;

    H = 1.52; %m; height of the CG relative to ground

    max_static_load_main = W*Na/B;
    max_static_load_nose = W*Mf/B;
    min_static_load_nose = W*Ma/B;

    dynamic_braking_load_nose = 10*H*W/(9.807*B);

    if Ma/B > 0.05
        disp('Main landing gear location constraint (Ma) satisfied.');
    else
        disp('Main landing gear location constraint not satisfied. Consider moving landing gear backward.');
    end
    if Mf/B < 0.2
        disp('Main landing gear location constraint (Mf) satisfied.');
    else
        disp('Main landing gear location constraint not satisfied. Consider moving landing gear forward.');
    end

    main_wheel_load_min = max_static_load_main/2;
    main_wheel_load_15x = 1.5*main_wheel_load_min;

    nose_wheel_load_min = max_static_load_nose/2;
    nose_wheel_load_15x = 1.5*nose_wheel_load_min;

    nose_wheel_dyn_braking_load_min = dynamic_braking_load_nose/2;
    nose_wheel_dyn_braking_load_15x = 1.5*nose_wheel_dyn_braking_load_min;

    total_nose_load_15x = (nose_wheel_load_15x+nose_wheel_dyn_braking_load_15x)/1.3;
    total_nose_load_min = (nose_wheel_load_min+nose_wheel_dyn_braking_load_min)/1.3;

    aircraft.geometry.LG.main_tire_load_15x     = main_wheel_load_15x;
    aircraft.geometry.LG.main_tire_load_min     = main_wheel_load_min;
    aircraft.geometry.LG.nose_tire_load_min     = total_nose_load_min;
    aircraft.geometry.LG.nose_tire_dyn_load_min = nose_wheel_dyn_braking_load_min;

    disp('LG Requirements: ');
    disp(strcat('Main gear tire static load requirement: ', num2str(ConvMass(main_wheel_load_min,'kg','lbm')), 'lbs'));
    disp(strcat('Nose gear tire static load requirement: ', num2str(ConvMass(total_nose_load_min,'kg','lbm')), 'lbs'));
    disp(strcat('Nose gear tire dynamic load requirement: ', num2str(ConvMass(nose_wheel_dyn_braking_load_min,'kg','lbm')), 'lbs'));

end
