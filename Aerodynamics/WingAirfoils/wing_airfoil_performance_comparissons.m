clear
close all
clc

%% Simulate NACA 64A210

% set number of simulations
N = 20;

% set mach number range
mach = linspace(0,0.8,N);

% set AOA range
alpha = linspace(0,8.5,N);

%set alpha for takeoff and 2 cruise speeds
alpha_to_c = [0.2, 0.7, 0.8];
N_alpha_to_c = length(alpha_to_c);

% import NACA 64A210 airfoil coordinates 
X = load('NACA_64A210_mfoil.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',50)

% introduce a flap at x=0.8, y=0, 10deg down  
%m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate

% create empty arrays to store plotting parameters
cl_alpha_64A210 = zeros(N_alpha_to_c,N);
cd_alpha_64A210 = zeros(N_alpha_to_c,N);
cl_polar_64A210 = zeros(1,N);
cd_polar_64A210 = zeros(1,N);
cm_alpha_64A210 = zeros(N_alpha_to_c,N);

for k = 1:N

        % set operating conditions 
        m.setoper('alpha',0,'Ma',mach(k),'Re',10^6);

        % run the solver, plot the results 
        m.solve 

        cl_polar_64A210(k) = m.post.cl;
        cd_polar_64A210(k) = m.post.cd;
end

for j = 1:N_alpha_to_c
    for i = 1:N

        % set operating conditions 
        m.setoper('alpha',alpha_to_c(j),'Ma',mach(i), 'Re',10^6);

        % run the solver, plot the results 
        m.solve
        
        cl_alpha_64A210(j,i) = m.post.cl;
        cd_alpha_64A210(j,i) = m.post.cd;
        cm_alpha_64A210(j,i) = m.post.cm;
    end
end




