% Load speed data 
speed_filename = 'E4S 58,140 speed.xlsx';  
speed_data = readtable(speed_filename); 
 
% Convert DATE to datetime for easier handling 
speed_data.DATE = datetime(speed_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Reshape data for clustering: each row is a day, each column is a 15-min interval 
speed_profiles = table2array(speed_data(:, 2:end)); 

 
% Determine the optimal number of clusters using the elbow method 
max_k = 6; % Maximum number of clusters to try 
cost = zeros(1, max_k); % Preallocate cost array 
 
for k = 1:max_k 
    [idx, C, sumd, D] = kmeans(speed_profiles, k); % Perform k-means clustering 
    cost(k) = sum(sumd .^ 2); % Calculate the total squared cost for current k 
end 
 
% Plot the elbow method result 
figure; 
plot(1:max_k, cost, '-o'); 
xlabel('Number of clusters'); 
ylabel('Cost'); 
title('Elbow Method for Optimal Number of Clusters (Speed data)'); 
grid on;