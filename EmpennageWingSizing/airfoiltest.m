% viscous compressible flow over a NACA 2412 
% airfoil with a flap 

% create an airfoil class 
m = mfoil('naca','2412', 'npanel',199);

% introduce a flap 
m.geom_flap([0.85,0], 10);

% set operating conditions 
m.setoper('alpha',2,'Re',1e6, 'Ma',0.4);

% run the solver, plot the results (at right)  
m.solve

% for more boundary-layer plots  
m.plot_distributions 