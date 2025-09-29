% Load speed data 
speed_filename = 'E4S 58,140 speed.xlsx';  
speed_data = readtable(speed_filename); 
 
% Convert DATE to datetime for easier handling 
speed_data.DATE = datetime(speed_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Reshape data for clustering: each row is a day, each column is a 15-min interval 
num_days_speed = height(speed_data); % Number of days 
num_intervals_speed = width(speed_data) - 1; % Number of time intervals, excluding DATE 
speed_profiles = table2array(speed_data(:, 2:end)); 
 
% Define number of clusters (e.g., 3 clusters for speed) 
k_speed = 3; 
 
% Perform k-means clustering for speed profiles 
[idx_speed, centroids_speed] = kmeans(speed_profiles, k_speed); 
 
% Generate time labels as duration (no date) 
time_labels = hours(5) + minutes(0:15:(21*60 + 45 - 300)); % 5:00 to 21:45 
 
% Plot each speed cluster in separate figures 
for cluster = 1:k_speed 
    % Extract all days that belong to this speed cluster 
    cluster_data_speed = speed_profiles(idx_speed == cluster, :); 
     
    % Calculate mean and standard deviation for shading in speed clusters 
    cluster_mean_speed = mean(cluster_data_speed, 1); 
    cluster_std_speed = std(cluster_data_speed, 0, 1); 
 
    % Create a new figure for each speed cluster 
    figure; 
    hold on; 
     
    % Plot each day's profile in light color for the speed cluster 
    plot(time_labels, cluster_data_speed', 'Color', [0.6, 0.6, 1]); % Light blue for individual profiles 
     
    % Plot mean profile with thicker line for speed cluster 
    plot(time_labels, cluster_mean_speed, 'b-', 'LineWidth', 2); 
     
    % Plot shaded area for standard deviation in speed cluster 
    fill([time_labels, fliplr(time_labels)], ... 
         [cluster_mean_speed + cluster_std_speed, fliplr(cluster_mean_speed - cluster_std_speed)], ... 
         'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Shaded area for variation 
 
    % Customize each plot for speed 
    title(['Speed Cluster ' num2str(cluster) ' (# data points: ' num2str(size(cluster_data_speed, 1)) ')'], 'FontSize', 12); 
    xlabel('Time of Day'); 
    ylabel('Speed (km/h)'); 
    xlim([time_labels(1), time_labels(end)]); 
    ylim([0, max(speed_profiles(:)) + 10]); 
    xtickformat('hh:mm'); % Display time in HH:MM format without date 
    xticks(time_labels(1:4:end)); % Show every 4th time label to reduce clutter 
    grid on; 
    hold off; 
end 