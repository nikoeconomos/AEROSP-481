clear
close all
clc

% set initial simulation settings
N = 20;

%% Simulate NACA 64A210

% set mach number range
mach = linspace(0,0.8,N);

% set AOA range
alpha = [linspace(0,8.5,N); linspace(0,3.57,N); linspace(0,3.57,N)];

%set alpha for takeoff and 2 cruise speeds
mach_to_c = [0.2, 0.7, 0.73];
N_mach_to_c = length(mach_to_c);

% import NACA 64A210 airfoil coordinates 
X = load('NACA_64A210_mfoil.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',50)

% introduce a flap at x=0.8, y=0, 10deg down  
%m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate
m.param.verb = 0;

% create empty arrays to store plotting parameters
cl_alpha_64A210 = zeros(N_mach_to_c,N);
cd_alpha_64A210 = zeros(N_mach_to_c,N);
cl_polar_64A210 = zeros(1,N);
cd_polar_64A210 = zeros(1,N);
cm_alpha_64A210 = zeros(N_mach_to_c,N);

for k = 1:N

        % set operating conditions 
        m.setoper('alpha',0,'Ma',mach(k),'Re',10^6);

        % run the solver, plot the results 
        m.solve 

        cl_polar_64A210(k) = m.post.cl;
        cd_polar_64A210(k) = m.post.cd;
end

for j = 1:N_mach_to_c
    for i = 1:N

        % set operating conditions 
        m.setoper('alpha',alpha(j,i),'Ma',mach_to_c(j), 'Re',10^6);
        
        % run the solver, plot the results 
        m.solve
       
        cl_alpha_64A210(j,i) = m.post.cl;
        cd_alpha_64A210(j,i) = m.post.cd;
        cm_alpha_64A210(j,i) = m.post.cm;
    end
end

%% Simulate NACA 64A208

% set mach number range
mach = linspace(0,0.8,N);

% set AOA range
alpha = [linspace(0,8.5,N); linspace(0,3.57,N); linspace(0,3.57,N)];

%set alpha for takeoff and 2 cruise speeds
mach_to_c = [0.2, 0.7, 0.72];
N_mach_to_c = length(mach_to_c);

% import NACA 64A210 airfoil coordinates 
X = load('NACA_64A210_mfoil.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',50);

% introduce a flap at x=0.8, y=0, 10deg down  
%m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate

% create empty arrays to store plotting parameters
cl_alpha_64A208 = zeros(N_mach_to_c,N);
cd_alpha_64A208 = zeros(N_mach_to_c,N);
cl_polar_64A208 = zeros(1,N);
cd_polar_64A208 = zeros(1,N);
cm_alpha_64A208 = zeros(N_mach_to_c,N);

for k = 1:N

        % set operating conditions 
        m.setoper('alpha',0,'Ma',mach(k),'Re',10^6);

        % run the solver, plot the results 
        m.solve 

        cl_polar_64A208(k) = m.post.cl;
        cd_polar_64A208(k) = m.post.cd;
end

for j = 1:N_mach_to_c
    for i = 1:N

        % set operating conditions 
        m.setoper('alpha',alpha(j,i),'Ma',mach_to_c(j), 'Re',10^6);

        % run the solver, plot the results 
        m.solve
       
        cl_alpha_64A208(j,i) = m.post.cl;
        cd_alpha_64A208(j,i) = m.post.cd;
        cm_alpha_64A208(j,i) = m.post.cm;
    end
end


%% Simulate NACA 64A206

% set mach number range
mach = linspace(0,0.8,N);

% set AOA range
alpha = [linspace(0,8.5,N); linspace(0,3.57,N); linspace(0,3.57,N)];

%set alpha for takeoff and 2 cruise speeds
mach_to_c = [0.2, 0.7, 0.72];
N_mach_to_c = length(mach_to_c);

% import NACA 64A210 airfoil coordinates 
X = load('NACA_64A210_mfoil.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',50);

% introduce a flap at x=0.8, y=0, 10deg down  
%m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate

% create empty arrays to store plotting parameters
cl_alpha_64A206 = zeros(N_mach_to_c,N);
cd_alpha_64A206 = zeros(N_mach_to_c,N);
cl_polar_64A206 = zeros(1,N);
cd_polar_64A206 = zeros(1,N);
cm_alpha_64A206 = zeros(N_mach_to_c,N);

for k = 1:N

        % set operating conditions 
        m.setoper('alpha',0,'Ma',mach(k),'Re',10^6);

        % run the solver, plot the results 
        m.solve 

        cl_polar_64A206(k) = m.post.cl;
        cd_polar_64A206(k) = m.post.cd;
end

for j = 1:N_mach_to_c
    for i = 1:N

        % set operating conditions 
        m.setoper('alpha',alpha(j,i),'Ma',mach_to_c(j), 'Re',10^6);

        % run the solver, plot the results 
        m.solve
       
        cl_alpha_64A206(j,i) = m.post.cl;
        cd_alpha_64A206(j,i) = m.post.cd;
        cm_alpha_64A206(j,i) = m.post.cm;
    end
end


%% Simulate NACA 64A204

% set mach number range
mach = linspace(0,0.8,N);

% set AOA range
alpha = [linspace(0,8.5,N); linspace(0,3.57,N); linspace(0,3.57,N)];

%set alpha for takeoff and 2 cruise speeds
mach_to_c = [0.2, 0.7, 0.72];
N_mach_to_c = length(mach_to_c);

% import NACA 64A210 airfoil coordinates 
X = load('NACA_64A210_mfoil.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',50);

% introduce a flap at x=0.8, y=0, 10deg down  
%m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate

% create empty arrays to store plotting parameters
cl_alpha_64A204 = zeros(N_mach_to_c,N);
cd_alpha_64A204 = zeros(N_mach_to_c,N);
cl_polar_64A204 = zeros(1,N);
cd_polar_64A204 = zeros(1,N);
cm_alpha_64A204 = zeros(N_mach_to_c,N);

for k = 1:N

        % set operating conditions 
        m.setoper('alpha',0,'Ma',mach(k),'Re',10^6);

        % run the solver, plot the results 
        m.solve 

        cl_polar_64A204(k) = m.post.cl;
        cd_polar_64A204(k) = m.post.cd;
end

for j = 1:N_mach_to_c
    for i = 1:N

        % set operating conditions 
        m.setoper('alpha',alpha(j,i),'Ma',mach_to_c(j), 'Re',10^6);

        % run the solver, plot the results 
        m.solve
       
        cl_alpha_64A204(j,i) = m.post.cl;
        cd_alpha_64A204(j,i) = m.post.cd;
        cm_alpha_64A204(j,i) = m.post.cm;
    end
end


%% Plot airfoil characteristics
figure()

% 0 AOA drag polar
subplot(2,2,1)

plot(cd_polar_64A210,cl_polar_64A210,'r',LineWidth=1.5);

legend('NACA 64A210')

xlabel('Drag Coefficicent');
ylabel('Lift Coefficicent');
title('Drag Polar at 0 AOA')

% CL vs alpha 3 speeds
subplot(2,2,2)

plot(alpha,cl_alpha_64A210(1,:),'r',LineWidth=1.5);
hold on
plot(alpha,cl_alpha_64A210(2,:),'r',LineWidth=1.5,LineStyle='--');
hold on
plot(alpha,cl_alpha_64A210(3,:),'r',LineWidth=1.5,LineStyle=':');
hold off

legend('NACA 64A210 TO','NACA 64A210 M-0.7','NACA 64A210 M-0.8')

xlabel('Angle of Attack (degrees)');
ylabel('Lift Coefficicent');

% CD vs alpha 3 speeds
subplot(2,2,3)

plot(alpha,cd_alpha_64A210(1,:),'r',LineWidth=1.5);
hold on
plot(alpha,cd_alpha_64A210(2,:),'r',LineWidth=1.5,LineStyle='--');
hold on
plot(alpha,cd_alpha_64A210(3,:),'r',LineWidth=1.5,LineStyle=':');
hold off

legend('NACA 64A210 TO','NACA 64A210 M-0.7','NACA 64A210 M-0.8')

xlabel('Angle of Attack (degrees)');
ylabel('Total Drag Coefficicent');

% CM vs alpha 3 speeds
subplot(2,2,4)

plot(alpha,cm_alpha_64A210(1,:),'r',LineWidth=1.5);
hold on
plot(alpha,cm_alpha_64A210(2,:),'r',LineWidth=1.5,LineStyle='--');
hold on
plot(alpha,cm_alpha_64A210(3,:),'r',LineWidth=1.5,LineStyle=':');
hold off

legend('NACA 64A210 TO','NACA 64A210 M-0.7','NACA 64A210 M-0.8')

xlabel('Angle of Attack (degres)');
ylabel('Moment Coefficicent');

