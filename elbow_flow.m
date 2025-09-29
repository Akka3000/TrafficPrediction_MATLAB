% Load flow data 
flow_filename = 'E4S 58,140 flow.xlsx';  
flow_data = readtable(flow_filename); 
 
% Convert DATE to datetime for easier handling 
flow_data.DATE = datetime(flow_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
 
% Reshape data for clustering: each row is a day, each column is a 15-min interval 
flow_profiles = table2array(flow_data(:, 2:end)); 
 
% Determine the optimal number of clusters using the elbow method 
max_k = 6; % Maximum number of clusters to try 
cost = zeros(1, max_k); % Preallocate cost array 
 
for k = 1:max_k 
    [idx, C, sumd, D] = kmeans(flow_profiles, k); 
    cost(k) = sum(sumd .^ 2); % Total cost for current k using squared distance 
end 

% Plot the elbow method result 
figure; 
plot(1:max_k, cost, '-o'); 
xlabel('Number of clusters'); 
ylabel('Cost'); 
title('Elbow Method for Optimal Number of Clusters (Flow Data)'); 
grid on;