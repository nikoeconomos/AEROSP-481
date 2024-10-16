clear
close all
clc

% import  airfoil coordinates 
X = load('rae.txt');

% make/panel an airfoil out of these coordinates  
m = mfoil('coords', X, 'npanel',199)

% introduce a flap at x=0.8, y=0, 10deg down  
m.geom_flap([0.8,0], 10)

% derotate: make the chord line horizontal 
m.geom_derotate
    
% set operating conditions 
m.setoper('alpha',1, 'Re',10^6);

% run the solver, plot the results 
m.solve 





