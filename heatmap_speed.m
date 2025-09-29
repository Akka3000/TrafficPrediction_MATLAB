% Load and prepare speed data ('speed_data' is already loaded with DATE and time columns) 
speed_filename = 'E4S 58,140 speed.xlsx';  
speed_data = readtable(speed_filename); 
 
% Convert the DATE column to datetime 
speed_data.DATE = datetime(speed_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Prepare a matrix for heatmap visualization 
num_days = height(speed_data);  % Number of unique dates 
num_times = width(speed_data) - 1;  % Number of time intervals (exclude DATE column) 
speed_matrix = NaN(num_days, num_times); 

% Fill the matrix with speed values 
for i = 1:num_days 
    for j = 2:width(speed_data)  % Start from the second column (time columns) 
        speed_matrix(i, j-1) = speed_data{i, j}; 
    end 
end 
 
% Generate the time labels (assuming each time column represents a 15-minute interval) 
time_labels = speed_data.Properties.VariableNames(2:end);  % Extract time strings from column names 
time_labels = replace(time_labels, '_', ':'); % Replace underscores with colons for readability 
 
% Plot the heatmap 
figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]); % Increase figure size 
h = heatmap(time_labels, datestr(speed_data.DATE, 'yyyy-mm-dd'), speed_matrix, 'Colormap', jet); 
 
% Adjust the font size for both axes 
h.FontSize = 6; % Adjust font size as needed, e.g., set to 8 for smaller text 
 
xlabel('Time of Day'); 
ylabel('Date'); 
title('Speed Variation for Sensor E4S 58,140'); 
 
% Add colorbar for interpretation 
colorbar;