% Load the flow data file 
flow_filename = 'E4S 58,140 flow.xlsx';  
flow_data = readtable(flow_filename); 
 
% Convert the DATE column to datetime 
flow_data.DATE = datetime(flow_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Extract the number of days and time intervals 
num_days = height(flow_data); % Number of unique dates 
num_times = width(flow_data) - 1; % Number of time intervals (excluding DATE column) 
 
% Generate the time labels (each time column represents a 15-minute interval) 
time_labels = flow_data.Properties.VariableNames(2:end);  % Extract time strings from column names 
time_labels = replace(time_labels, '_', ':'); % Replace underscores with colons for readability 
 
% Plot flow profiles for each day 
figure; 
hold on; 
 
% Define colors to distinguish each day 
colors = jet(num_days); % Colormap with unique colors for each day 
 
for i = 1:num_days 
    % Extract flow data for each day 
    daily_flow = table2array(flow_data(i, 2:end)); % Get data for each row, excluding the DATE column 
    plot(1:num_times, daily_flow, 'Color', colors(i, :)); % Plot with color 
end 
 
% Customize plot with string labels for time of day 
set(gca, 'XTick', 1:num_times, 'XTickLabel', time_labels); % Use time labels directly as x-axis labels 
xtickangle(45); % Rotate x-axis labels for readability 
xlabel('Time of Day', 'FontSize', 10); 
ylabel('Flow (veh/h)', 'FontSize', 10); 
title('Daily Flow Profiles for Sensor E4S 58,140', 'FontSize', 12); 
set(gca, 'FontSize', 5); % Decrease font size for axes labels and ticks 
 
grid on; 
hold off;