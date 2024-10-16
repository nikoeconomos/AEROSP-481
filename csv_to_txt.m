
%% NACA 64A204 Airfoil txt

csv_filename = 'airfoil_NACA_64A204.csv';  % Path to your CSV file
data = readmatrix(csv_filename);

% Define the new name for the output text file
txt_filename = 'NACA_64A204_mfoil.txt';  % New name for the text file

% Write the data to a new text file
writematrix(data, txt_filename, 'Delimiter', ' ');

%%  NACA 64A206 Airfoil txt

csv_filename = 'airfoil_NACA_64A206.csv';  % Path to your CSV file
data = readmatrix(csv_filename);

% Define the new name for the output text file
txt_filename = 'NACA_64A206_mfoil.txt';  % New name for the text file

% Write the data to a new text file
writematrix(data, txt_filename, 'Delimiter', ' ');

%%  NACA 64A208 Airfoil txt

csv_filename = 'airfoil_NACA_64A208.csv';  % Path to your CSV file
data = readmatrix(csv_filename);

% Define the new name for the output text file
txt_filename = 'NACA_64A208_mfoil.txt';  % New name for the text file

% Write the data to a new text file
writematrix(data, txt_filename, 'Delimiter', ' ');

