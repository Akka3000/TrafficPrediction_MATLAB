% Load and prepare flow data ('flow_data' is already loaded with DATE and time columns) 
flow_filename = 'E4S 58,140 flow.xlsx';  
flow_data = readtable(flow_filename); 
 
% Convert the DATE column to datetime 
flow_data.DATE = datetime(flow_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Prepare a matrix for heatmap visualization 
num_days = height(flow_data);  % Number of unique dates 
num_times = width(flow_data) - 1;  % Number of time intervals (exclude DATE column) 
flow_matrix = NaN(num_days, num_times); 

 
% Fill the matrix with flow values 
for i = 1:num_days 
    for j = 2:width(flow_data)  % Start from the second column (time columns) 
        flow_matrix(i, j-1) = flow_data{i, j}; 
    end 
end 
 
% Generate the time labels (assuming each time column represents a 15-minute interval) 
time_labels = flow_data.Properties.VariableNames(2:end);  % Extract time strings from column names 
time_labels = replace(time_labels, '_', ':'); % Replace underscores with colons for readability 
 
% Plot the heatmap for flow 
figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]); % Increase figure size 
h = heatmap(time_labels, datestr(flow_data.DATE, 'yyyy-mm-dd'), flow_matrix, 'Colormap', parula); 
 
% Adjust the font size for both axes 
h.FontSize = 6; % Adjust font size as needed, e.g., set to 8 for smaller text 
 
xlabel('Time of Day'); 
ylabel('Date'); 
title('Flow Variation for Sensor E4S 58,140'); 
 
% Add colorbar for interpretation 
colorbar;