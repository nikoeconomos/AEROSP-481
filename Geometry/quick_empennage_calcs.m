clear
close all
clc

AR = 3.068;
S_W = 41;
b_W = sqrt(AR*S_W);
lambda = 0.35; % taper ratio

c_root_W = 25 / ( (1+lambda) * b_W);
c_tip_W = lambda * c_root_W;
c_bar_W = 3.5; % [m]

L_F = 16;
L_HT = 0.5 * L_F;
L_VT = L_HT + 0.4;

c_VT = 0.07;
c_HT = 0.4;

S_VT = c_VT * b_W * S_W / L_VT;
S_HT = c_HT * c_bar_W * S_W / L_HT;

gamma_vtail = atand(S_VT/S_HT); % degrees