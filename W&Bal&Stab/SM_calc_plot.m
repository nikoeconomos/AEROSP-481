function [sm_arr,np_arr] = SM_calc_plot(aircraft, cg_excursion_arr,mach)
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

    AR_w = aircraft.geometry.wing.AR;
    AR_h = aircraft.geometry.htail.AR;
    
    eta   = aircraft.aerodynamics.eta.wing; %wing efficiency (NOT OSWALD): usually 0.97
    eta_h = aircraft.aerodynamics.eta.htail; %tail efficiency: taking into account downwash
    
    Lambda_w = aircraft.geometry.wing.sweep_QC; 
    Lambda_h = aircraft.geometry.htail.sweep_QC;
    
    C_L_alpha_w = 2*pi*AR_w./(2+sqrt((AR_w/eta)^2*(1+tan(Lambda_w)^2 - mach.^2)+4)); % Metabook 8.18
    C_L_alpha_h_0 = 2*pi*AR_w./(2+sqrt((AR_h/eta)^2*(1+tan(Lambda_h)^2 - mach.^2)+4)); % 8.19
    C_L_alpha_h = C_L_alpha_h_0.*(1 - 2*C_L_alpha_w / (pi*AR_w) ).*eta_h; % 8.21
    

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
    
    l_h = aircraft.geometry.htail.xMAC - cg_excursion_arr(:,1); % Distance between CG and tail MAC

    C_M_fus_CL = K_f * w_f^2 * L_f ./ (S_w * MAC * C_L_alpha_w);
    
    sm_arr = -((cg_excursion_arr(:,1)-x25MAC)./MAC - C_L_alpha_h*S_h*l_h./(C_L_alpha_w*S_w*MAC) + C_M_fus_CL); %metabook 8.23
    np_arr = sm_arr*MAC + cg_excursion_arr(:,1);
    
    np_mach_arr = np_arr(1,:);
    
    %% PLOT %%
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