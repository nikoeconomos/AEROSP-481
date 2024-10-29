function [sm_arr,np_arr] = SM_calc(aircraft, cg_excursion_arr,mach)
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
    AR_w = aircraft.geometry.wing.AR;
    AR_h = aircraft.geometry.htail.AR;
    eta = 0.97; %wing efficiency (NOT OSWALD): usually 0.97
    eta_h = 0.8; %tail efficiency: taking into account downwash
    %Lambda_w = aircraft.geometry.wing.sweep_LE
    Lambda_w = 0.6984; %Based on quarter chord sweep, obtained geometrically from CAD
    Lambda_h = 0.8350;
    C_L_alphaw = 2*pi*AR_w./(2+sqrt((AR_w/eta)^2*(1+tan(Lambda_w)^2-mach.^2)+4))
    C_L_alphah = 2*pi*AR_w./(2+sqrt((AR_h/eta)^2*(1+tan(Lambda_h)^2-mach.^2)+4));
    C_L_alphah = C_L_alphah.*(1-2*C_L_alphaw/(pi*AR_w)).*eta_h
    K_f = 0.718; %found with linear interpolation from chart on Metabook
    w_f = 2.1;
    L_f = 17.576;
    S_w = aircraft.geometry.wing.S_ref;
    S_h = aircraft.geometry.htail.S_ref;
    MAC = aircraft.geometry.wing.MAC;
    x25MAC = aircraft.geometry.wing.xMAC+0.25*MAC;
    l_h = 5.401; %Distance between CG and tail
    C_M_fus_CL = K_f*w_f^2*L_f./(S_w*MAC*C_L_alphaw);
    sm_arr = (x25MAC-cg_excursion_arr(:,1))./MAC+C_L_alphah*S_h*l_h./(C_L_alphaw*S_w*MAC)-C_M_fus_CL;
    np_arr = sm_arr*MAC+cg_excursion_arr(:,1);
    np_mach_arr = np_arr(1,:);
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
    xlabel('Flight Stage'); ylabel('SM');
end