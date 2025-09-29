% Load and preprocess data 
speed_filename = 'E4S 58,140 speed.xlsx';  
flow_filename = 'E4S 58,140 flow.xlsx';  
speed_data = readtable(speed_filename); 
flow_data = readtable(flow_filename); 
% Convert DATE to datetime for easier handling 
speed_data.DATE = datetime(speed_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
flow_data.DATE = datetime(flow_data.DATE, 'InputFormat', 'yyyy-MM-dd'); 
% Extract relevant columns for 17:00–17:45 (time intervals 50–52 in 15-min data) 
speed_relevant = table2array(speed_data(:, 50:52)); % Columns for 17:00–17:45 
flow_relevant = table2array(flow_data(:, 50:52));   % Columns for 17:00–17:45 
% Randomize the data 
num_days = size(speed_relevant, 1); % Total number of days 
random_indices = randperm(num_days); 
% Split data into 60% training, 20% testing, and 20% validation 
train_idx = random_indices(1:round(0.6*num_days)); % First 60% 
test_idx = random_indices(round(0.6*num_days)+1:round(0.8*num_days)); % Next 20% 
val_idx = random_indices(round(0.8*num_days)+1:end); % Remaining 20% 
% Create training, test, and validation sets for speed 
speed_train = speed_relevant(train_idx, :); 
speed_test = speed_relevant(test_idx, :); 
speed_val = speed_relevant(val_idx, :); 

% Create training, test, and validation sets for flow 
flow_train = flow_relevant(train_idx, :); 
flow_test = flow_relevant(test_idx, :); 
flow_val = flow_relevant(val_idx, :); 
% Define a range of K values to test 
K_values = 1:20; 
% Initialize arrays to store RMSE and MAPE 
rmse_values = zeros(length(K_values), 3); % 3 horizons 
mape_values = zeros(length(K_values), 3); 
% Iterate over K values 
for idx = 1:length(K_values) 
K = K_values(idx); 
% Make predictions for validation set (Speed) 
speed_val_predictions_h1 = knn_predict(speed_train(:,1), speed_val(:,1), K); 
speed_val_predictions_h2 = knn_predict(speed_train(:,2), speed_val(:,2), K); 
speed_val_predictions_h3 = knn_predict(speed_train(:,3), speed_val(:,3), K); 
% Compute RMSE and MAPE for each horizon (Speed) 
rmse_values(idx, 1) = rmse(speed_val_predictions_h1, speed_val(:,1)); 
rmse_values(idx, 2) = rmse(speed_val_predictions_h2, speed_val(:,2)); 
rmse_values(idx, 3) = rmse(speed_val_predictions_h3, speed_val(:,3)); 
mape_values(idx, 1) = mape(speed_val_predictions_h1, speed_val(:,1)); 
mape_values(idx, 2) = mape(speed_val_predictions_h2, speed_val(:,2)); 
mape_values(idx, 3) = mape(speed_val_predictions_h3, speed_val(:,3)); 
end 
% Plot RMSE for all horizons in one figure 
figure; 
plot(K_values, rmse_values(:, 1), '-o', 'DisplayName', '(17:00-17:15)', 'LineWidth', 2); 
hold on; 
plot(K_values, rmse_values(:, 2), '-s', 'DisplayName', '(17:15-17:30)', 'LineWidth', 2); 
plot(K_values, rmse_values(:, 3), '-d', 'DisplayName', '(17:30-17:45)', 'LineWidth', 2); 
xlabel('K (Number of Neighbors)'); 
ylabel('RMSE'); 
title('RMSE for All Horizons'); 
legend('Location', 'best'); 
grid on; 
% Plot MAPE for all horizons in one figure 
figure; 
plot(K_values, mape_values(:, 1), '-o', 'DisplayName', '(17:00-17:15)', 'LineWidth', 2); 
hold on; 
plot(K_values, mape_values(:, 2), '-s', 'DisplayName', '(17:15-17:30)', 'LineWidth', 2); 
plot(K_values, mape_values(:, 3), '-d', 'DisplayName', '(17:30-17:45)', 'LineWidth', 2); 
xlabel('K (Number of Neighbors)'); 
ylabel('MAPE (%)'); 
title('MAPE for All Horizons'); 
legend('Location', 'best'); 
grid on; 

% Find the index of the minimum RMSE for each horizon 
[~, best_k_rmse_horizon1] = min(rmse_values(:, 1)); 
[~, best_k_rmse_horizon2] = min(rmse_values(:, 2)); 
[~, best_k_rmse_horizon3] = min(rmse_values(:, 3)); 
% Find the index of the minimum MAPE for each horizon 
[~, best_k_mape_horizon1] = min(mape_values(:, 1)); 
[~, best_k_mape_horizon2] = min(mape_values(:, 2)); 
[~, best_k_mape_horizon3] = min(mape_values(:, 3)); 
% Display the best K values 
disp(['Best K for RMSE 17:00-17:15: ', num2str(K_values(best_k_rmse_horizon1))]); 
disp(['Best K for RMSE 17:15-17:30: ', num2str(K_values(best_k_rmse_horizon2))]); 
disp(['Best K for RMSE 17:30-17:45: ', num2str(K_values(best_k_rmse_horizon3))]); 
disp(['Best K for MAPE 17:00-17:15: ', num2str(K_values(best_k_mape_horizon1))]); 
disp(['Best K for MAPE 17:15-17:30: ', num2str(K_values(best_k_mape_horizon2))]); 
disp(['Best K for MAPE 17:30-17:45: ', num2str(K_values(best_k_mape_horizon3))]); 
rmse.m 
function result = rmse(y_pred, y_true) 
result = sqrt(mean((y_pred - y_true).^2)); 
end 
mape.m 
function result = mape(y_pred, y_true) 
result = mean(abs((y_pred - y_true) ./ y_true)) * 100; 
end 