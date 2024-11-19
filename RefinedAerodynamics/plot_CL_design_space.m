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
k = 0.81 * cosd(20.4);
h = 0.27 * cos(aircraft.geometry.wing.sweep_LE); % argument in radians
Sref_fixed = aircraft.geometry.wing.S_ref;

% Define ranges for changing lifting surface parameters
Sflapped = linspace(0,49,50);
Sslatted = linspace(0,49,50);

%% 3D plot accounting for changing flap & slat area - constant Sref

[Sf,Ss] = meshgrid(Sflapped,Sslatted);

CL_req_ls = (W + k.*Sf + h.*Ss) / Sref_fixed;

% At wing AOA = 0 degrees
surfl(Sf,Ss,CL_req_ls)
hold on
contour3(Sf,Ss,CL_req_ls,[1.2,1.37,1.6,1.9],'y',LineWidth=1.5)
hold off

title('Obtainable CL with Constant Sref & Changing Lifting Surface Areas')
xlabel('T.E. Flapped Area')
ylabel('L.E. Flapped Area')
zlabel('Lift Coefficient')

% At wing AOA = 6 degrees
surfl(Sf,Ss,CL_req_ls)
hold on
contour3(Sf,Ss,CL_req_ls,[1.2,1.37,1.6,1.9],'y',LineWidth=1.5)
hold off

title('Obtainable CL with Constant Sref & Changing Lifting Surface Areas')
xlabel('T.E. Flapped Area')
ylabel('L.E. Flapped Area')
zlabel('Lift Coefficient')


%% 4D plot accounting for all areas changing

% Set changing variables with sppropriate sizes to limit computational
% expense:
Sref = linspace(20,40,30);
Sflapped = linspace(0,49,8);
Sslatted = linspace(0,49,8);

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