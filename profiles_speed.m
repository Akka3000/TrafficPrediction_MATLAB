% Load the speed data file 
speed_filename = 'E4S 58,140 speed.xlsx';  
speed_data = readtable(speed_filename); 
 
% Convert the DATE column to datetime 
speed_data.DATE = datetime(speed_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Extract the number of days and time intervals 
num_days = height(speed_data); % Number of unique dates 
num_times = width(speed_data) - 1; % Number of time intervals (excluding DATE column) 
 
% Generate the time labels (each time column represents a 15-minute interval) 
time_labels = speed_data.Properties.VariableNames(2:end);  % Extract time strings from column names 
time_labels = replace(time_labels, '_', ':'); % Replace underscores with colons for readability 
 
% Plot speed profiles for each day 
figure; 
hold on; 
 
% Define colors to distinguish each day 
colors = jet(num_days); % Colormap with unique colors for each day 
 
for i = 1:num_days 
    % Extract speed data for each day 
    daily_speed = table2array(speed_data(i, 2:end)); % Get data for each row, excluding the DATE column 
    plot(1:num_times, daily_speed, 'Color', colors(i, :)); % Plot with color 
end 
 
% Customize plot with string labels for time of day 
set(gca, 'XTick', 1:num_times, 'XTickLabel', time_labels); % Use time labels directly as x-axis labels 
xtickangle(45); % Rotate x-axis labels for readability 
xlabel('Time of Day', 'FontSize', 10); 
ylabel('Speed (km/h)', 'FontSize', 10); 
title('Daily Speed Profiles for Sensor E4S 58,140', 'FontSize', 12); 
set(gca, 'FontSize', 5); % Decrease font size for axes labels and ticks 
 
grid on; 
hold off;