function aircraft = SM_calc_plot(aircraft, mach)
% Description: Using values obtained from cg_excursion_calc.m to find
% changes in static margin
% 
% 
% INPUTS:
% --------------------------------------------
%    cg_excursion_arr -- array of cg locations over an excursion
% 
% OUTPUTS:
% --------------------------------------------
%    sm_arr -- array of static margins over an excursion
%    np_arr -- array of neutral points over an excursion
%                       
% 
% See also: 
% script
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 10/27/24

    %% SET VALUES %%

    mach = aircraft.performance.mach.arr;

    cg_excursion_arr = aircraft.weight.cg.excursion_arr_full_mission; % Calculated previously in CG_calc_plot. Full mission start to finish

    AR_w = aircraft.geometry.wing.AR;
    AR_h = aircraft.geometry.htail.AR;
    
    eta_w   = aircraft.aerodynamics.eta.wing; %wing efficiency (NOT OSWALD): usually 0.97
    eta_h = aircraft.aerodynamics.eta.htail; %tail efficiency: taking into account downwash
    
    Lambda_HC_w = aircraft.geometry.wing.sweep_HC; 
    Lambda_HC_h = aircraft.geometry.htail.sweep_HC;

    C_L_alpha_w = zeros(1 , length(mach));
    C_L_alpha_h = zeros(1 , length(mach));

    C_L_alpha_w   = 2*pi*AR_w ./ (2+sqrt( (AR_w/eta_w)^2 * (1+tan(Lambda_HC_w)^2 - mach.^2) +4)); % Metabook 8.18
    
    C_L_alpha_h_0 = 2*pi*AR_h ./ (2+sqrt( (AR_h/eta_h)^2 * (1+tan(Lambda_HC_h)^2 - mach.^2) +4)); % 8.19
    de_da         = 2*C_L_alpha_w / (pi*AR_w);
    C_L_alpha_h   = C_L_alpha_h_0.*(1 - de_da).*eta_h; % 8.21

    %% TODO MAKE TRANSONIC AND SUPERSONIC UNIQUE --> Juan data?
    
    for i = 1:length(mach)
        if mach(i) <= 0.8

            C_L_alpha_w(i) = 2*pi*AR_w ./ (2+sqrt( (AR_w/eta_w)^2 * (1+tan(Lambda_HC_w)^2 - mach.^2) +4)); % Metabook 8.18
    
            C_L_alpha_h_0  = 2*pi*AR_h ./ (2+sqrt( (AR_h/eta_h)^2 * (1+tan(Lambda_HC_h)^2 - mach.^2) +4)); % 8.19
            de_da          = 2*C_L_alpha_w / (pi*AR_w);
            C_L_alpha_h(i) = C_L_alpha_h_0.*(1 - de_da).*eta_h; % 8.21

        elseif mach(i) > 0.8 && mach(i) < 1.4

            C_L_alpha_w(i) = 2*pi*AR_w ./ (2+sqrt( (AR_w/eta_w)^2 * (1+tan(Lambda_HC_w)^2 - mach.^2) +4)); % Metabook 8.18
    
            C_L_alpha_h_0  = 2*pi*AR_h ./ (2+sqrt( (AR_h/eta_h)^2 * (1+tan(Lambda_HC_h)^2 - mach.^2) +4)); % 8.19
            de_da          = 2*C_L_alpha_w / (pi*AR_w);
            C_L_alpha_h(i) = C_L_alpha_h_0.*(1 - de_da).*eta_h; % 8.21

        else % supersonic

            C_L_alpha_w(i) = 2*pi*AR_w ./ (2+sqrt( (AR_w/eta_w)^2 * (1+tan(Lambda_HC_w)^2 - mach.^2) +4)); % Metabook 8.18
    
            C_L_alpha_h_0  = 2*pi*AR_h ./ (2+sqrt( (AR_h/eta_h)^2 * (1+tan(Lambda_HC_h)^2 - mach.^2) +4)); % 8.19
            de_da          = 2*C_L_alpha_w / (pi*AR_w);
            C_L_alpha_h(i) = C_L_alpha_h_0.*(1 - de_da).*eta_h; % 8.21

            %C_L_alpha_w(i) = C_N_alpha_w * cos(alpha); %TODO INSERT ALPHA

        end
    end

    aircraft.stability.C_L_alpha.wing = C_L_alpha_w;
    aircraft.stability.C_L_alpha.htail = C_L_alpha_h;
    

    %% Finding Kf based on location of wing quarter chord

    % Values from metabook table 8.1
    x = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]; % 1/4 chord position
    y = [0.115, 0.172, 0.344, 0.487, 0.688, 0.888, 1.146]; % Kf values
    
    % Fit a polynomial to the data
    p = polyfit(x, y, 2); % Second-degree polynomial
    
    K_f = polyval(p, aircraft.geometry.wing.xR25/aircraft.geometry.fuselage.length);


    %% More values

    w_f = aircraft.geometry.fuselage.width; % max width of fuselage
    L_f = aircraft.geometry.fuselage.length; % length of fuselage
    
    S_w = aircraft.geometry.wing.S_ref;
    S_h = aircraft.geometry.htail.S_ref;
    
    MAC    = aircraft.geometry.wing.MAC;
    x25MAC = aircraft.geometry.wing.xMAC+0.25*MAC;
    x50MAC = aircraft.geometry.wing.xMAC+0.5*MAC;
    l_h    = aircraft.geometry.htail.xMAC - cg_excursion_arr(:,1); % Distance between CG and tail MAC

    C_M_fus_CL = K_f * w_f^2 * L_f ./ (S_w * MAC * C_L_alpha_w);

    if mach > 1
        x_cg_dist_from_ac = cg_excursion_arr(:,1)-x50MAC;
    else
        x_cg_dist_from_ac = cg_excursion_arr(:,1)-x25MAC;
    end

    sm_arr = -( x_cg_dist_from_ac./MAC - (C_L_alpha_h .*S_h .*l_h) ./ (C_L_alpha_w .* S_w .*MAC) + C_M_fus_CL); %metabook 8.23
    aircraft.stability.static_margin_arr = sm_arr;
    
    np_arr = sm_arr*MAC + cg_excursion_arr(:,1);
    aircraft.stability.neutral_point_arr = np_arr;
    
    np_mach_arr = np_arr(1,:);
    
    %% PLOT %%
    figure;
    plot(mach,np_mach_arr,'-o', 'MarkerFaceColor', 'k');
    title('Neutral Point location at varying Mach numbers');
    xline(1,'--');
    xlabel('Mach'); ylabel('x_n_p (m, from nose tip)');
    
    figure;
    hold on;
    for i = 1:length(sm_arr(1,:))
        plot(6:1:length(cg_excursion_arr),sm_arr(6:end,i)','-o', 'MarkerFaceColor', 'k');
    end
    yline(0,'--');
    lgndstr = "M = " + string(mach);
    legend(lgndstr);
    title('Static Margin Excursion Plot for varying Mach numbers');
    xlabel('Flight Stage'); 
    ylabel('SM');

end