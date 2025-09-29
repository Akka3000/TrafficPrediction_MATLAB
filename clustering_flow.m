% Load flow data 
flow_filename = 'E4S 58,140 flow.xlsx';  
flow_data = readtable(flow_filename); 
 
% Convert DATE to datetime for easier handling 
flow_data.DATE = datetime(flow_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Reshape data for clustering: each row is a day, each column is a 15-min interval 
num_days_flow = height(flow_data); % Number of days 
num_intervals_flow = width(flow_data) - 1; % Number of time intervals, excluding DATE 
flow_profiles = table2array(flow_data(:, 2:end)); 
 
% Define number of clusters (e.g., 3 clusters for flow) 
k_flow = 3; 
 
% Perform k-means clustering for flow profiles 
[idx_flow, centroids_flow] = kmeans(flow_profiles, k_flow); 
 
% Generate time labels as duration (no date) 
time_labels = hours(5) + minutes(0:15:(21*60 + 45 - 300)); % 5:00 to 21:45 
 
% Plot each flow cluster in separate figures 
for cluster = 1:k_flow 
    % Extract all days that belong to this flow cluster 
    cluster_data_flow = flow_profiles(idx_flow == cluster, :); 
     
    % Calculate mean and standard deviation for shading in flow clusters 
    cluster_mean_flow = mean(cluster_data_flow, 1); 
    cluster_std_flow = std(cluster_data_flow, 0, 1); 
 
    % Create a new figure for each flow cluster 
    figure; 
    hold on; 
     
    % Plot each day's profile in light color for the flow cluster 
    plot(time_labels, cluster_data_flow', 'Color', [1, 0.6, 0.6]); % Light red for individual profiles 
     
    % Plot mean profile with thicker line for flow cluster 
    plot(time_labels, cluster_mean_flow, 'r-', 'LineWidth', 2); 
     
    % Plot shaded area for standard deviation in flow cluster 
    fill([time_labels, fliplr(time_labels)], ... 
         [cluster_mean_flow + cluster_std_flow, fliplr(cluster_mean_flow - cluster_std_flow)], ... 
         'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Shaded area for variation 
 
    % Customize each plot for flow 
    title(['Flow Cluster ' num2str(cluster) ' (# data points: ' num2str(size(cluster_data_flow, 1)) ')'], 'FontSize', 
12); 
    xlabel('Time of Day'); 
    ylabel('Flow (veh/hr)'); 
    xlim([time_labels(1), time_labels(end)]); 
    ylim([0, max(flow_profiles(:)) + 10]); 
    xtickformat('hh:mm'); % Display time in HH:MM format without date 
    xticks(time_labels(1:4:end)); % Show every 4th time label to reduce clutter 
    grid on; 
    hold off; 
end