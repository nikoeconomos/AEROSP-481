
%% Modified Airfoil for NACA 64A204

filename = 'NACA_64A210_mfoil.txt';  
airfoil_NACA_64A204 = readmatrix(filename, 'FileType', 'text');

airfoil_NACA_64A204(:, 2) = airfoil_NACA_64A204(:, 2) * 0.4;

csvwrite('NACA_64A204.csv', airfoil_NACA_64A204);

csv_filename = 'NACA_64A204.csv';  
data = readmatrix(csv_filename);


txt_filename = 'NACA_64A204_mfoil.txt'; 
fileID = fopen(txt_filename, 'w');


fprintf(fileID, txt_filename ); 

for i = 1:size(data, 1)
    fprintf(fileID, '%.6f %.6f\n', data(i, 1), data(i, 2));
end

fclose(fileID);

%%  Modified Airfoil for NACA 64A206

filename = 'NACA_64A210_mfoil.txt';  
airfoil_NACA_64A206 = readmatrix(filename, 'FileType', 'text');

% Modify the second column by multiplying it by 0.4
airfoil_NACA_64A206(:, 2) = airfoil_NACA_64A206(:, 2) * 0.6;

% Write the modified data to a new CSV file
csvwrite('NACA_64A206.csv',airfoil_NACA_64A206);

csv_filename = 'NACA_64A206.csv';  
data = readmatrix(csv_filename);


txt_filename = 'NACA_64A206_mfoil.txt'; 
fileID = fopen(txt_filename, 'w');


fprintf(fileID, txt_filename ); 

for i = 1:size(data, 1)
    fprintf(fileID, '%.6f %.6f\n', data(i, 1), data(i, 2));
end

fclose(fileID);



%% Modified Airfoil for NACA 64A208

filename = 'NACA_64A210_mfoil.txt';  
airfoil_NACA_64A208 = readmatrix(filename, 'FileType', 'text');

% Modify the second column by multiplying it by 0.4
airfoil_NACA_64A208(:, 2) = airfoil_NACA_64A208(:, 2) * 0.8;

% Write the modified data to a new CSV file
csvwrite('NACA_64A208.csv', airfoil_NACA_64A208);

csv_filename = 'NACA_64A208.csv';  
data = readmatrix(csv_filename);


txt_filename = 'NACA_64A208_mfoil.txt'; 
fileID = fopen(txt_filename, 'w');


fprintf(fileID, txt_filename ); 

for i = 1:size(data, 1)
    fprintf(fileID, '%.6f %.6f\n', data(i, 1), data(i, 2));
end

fclose(fileID);

