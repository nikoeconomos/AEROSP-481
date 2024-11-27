function [aircraft] = plot_CL_design_space(aircraft)
% Description: 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    3 plots showing the corresponding change in CL from Sref, Sflapped, 
%    and Sslatted
%
%    A plot showing the change in this variable from all 3 variables 
%    combined                       
% 
% See also:
% Author:                          Juan
% Version history revision notes:
%                                  v1: 11/18/2024

% Define constant multiples for objective function
W = 1.8 * aircraft.weight.togw / (0.93 * 93.6^2);
W_sec = 2 * aircraft.weight.togw / (0.93 * 93.6^2);

k = 0.81 * cosd(0); % flap
h = 0.27 * cos(aircraft.geometry.wing.sweep_LE); % argument in radians % slat

Sref_fixed = 35%aircraft.geometry.wing.S_ref;

% Define ranges for changing lifting surface parameters
Sflapped = linspace(0,21.176,50);
Sslatted = linspace(0,21.176,50);

%% 3D plot accounting for changing flap & slat area - constant Sref

[Sf,Ss] = meshgrid(Sflapped,Sslatted);

% At aircraft AOA = 0 degrees, wing inccidence = 2 degrees
CL_attainable_cruise = 0.6305 * 0.9 + (k.*Sf + h.*Ss) / Sref_fixed;

figure()
surfl(Sf,Ss,CL_attainable_cruise)
hold on
contour3(Sf,Ss,CL_attainable_cruise,[1.2,1.37,1.6,1.9],'y',LineWidth=1.5)
hold off

title('Obtainable CL with Constant Sref & Changing Lifting Surface Areas - Cruise')
xlabel('T.E. Flapped Area')
ylabel('L.E. Flapped Area')
zlabel('Lift Coefficient')

% At wing AOA = 6 degrees
%CL_attainable_land = 0.89973 * 0.9 + k.*Sf / Sref_fixed + h.*Ss / Sref_fixed;

CL_attainable_land = 0.89973 * 0.9 + k.*10 / 24.5 + h.*2.06 / 24.5;

figure()
surfl(Sf,Ss,CL_attainable_land)
hold on
contour3(Sf,Ss,CL_req_land,[1.2,1.37,1.6,1.9],'y',LineWidth=1.5)
hold off

title('Obtainable CL with Constant Sref & Changing Lifting Surface Areas - Landing')
xlabel('T.E. Flapped Area')
ylabel('L.E. Flapped Area')
zlabel('Lift Coefficient')


%% 4D plot accounting for all areas changing

% Set changing variables with sppropriate sizes to limit computational
% expense:
Sref = linspace(20,40,30);
Sflapped = linspace(0,40,8);
Sslatted = linspace(0,40,8);

% Make 3 dimensional matrix
CL_req_4d = zeros(length(Sflapped),length(Sslatted),length(Sref));

% Fill each matrix index
for idR = 1:length(Sref)
    for idF = 1:length(Sflapped)
        for idS = 1:length(Sslatted)
            
            Fi = Sflapped(idF);
            Si = Sslatted(idS);
            Ri = Sref(idR);

            % Objective function
            CL_req_4d(idF, idS, idR) = (W_sec - k.*Fi - h.*Si) ./ (0.9 * Ri);

        end
    end
end

% Plot

plottool(2,'4D CL',10,'T.E. Flapped Surface Area','L.E. Flapped Surface Area','Reference Surface Area','Sectional Lift Coefficient Needed with Changing Wing Areas');
plot4D_spheres(Sflapped,Sslatted,Sref,CL_req_4d,1,30)

end