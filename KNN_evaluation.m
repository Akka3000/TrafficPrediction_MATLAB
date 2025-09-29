% Load speed and flow data 
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
% Extract dates for the test set 
speed_test_dates = speed_data.DATE(test_idx); 
flow_test_dates = flow_data.DATE(test_idx); 
% Define K for KNN 
K = 1; 
% Make predictions for speed 
speed_predictions_horizon1 = knn_predict(speed_train(:,1), speed_test(:,1), K); % 17:00-17:15 
speed_predictions_horizon2 = knn_predict(speed_train(:,2), speed_test(:,2), K); % 17:15-17:30 
speed_predictions_horizon3 = knn_predict(speed_train(:,3), speed_test(:,3), K); % 17:30-17:45 
% Make predictions for flow 
flow_predictions_horizon1 = knn_predict(flow_train(:,1), flow_test(:,1), K); % 17:00-17:15 
flow_predictions_horizon2 = knn_predict(flow_train(:,2), flow_test(:,2), K); % 17:15-17:30 
flow_predictions_horizon3 = knn_predict(flow_train(:,3), flow_test(:,3), K); % 17:30-17:45 
% Calculate RMSE, MAPE, and R² for speed 
rmse_speed_h1 = rmse(speed_predictions_horizon1, speed_test(:,1)); 
rmse_speed_h2 = rmse(speed_predictions_horizon2, speed_test(:,2)); 
rmse_speed_h3 = rmse(speed_predictions_horizon3, speed_test(:,3)); 
mape_speed_h1 = mape(speed_predictions_horizon1, speed_test(:,1)); 
mape_speed_h2 = mape(speed_predictions_horizon2, speed_test(:,2)); 
mape_speed_h3 = mape(speed_predictions_horizon3, speed_test(:,3)); 
r2_speed_h1 = r_squared(speed_predictions_horizon1, speed_test(:,1)); 
r2_speed_h2 = r_squared(speed_predictions_horizon2, speed_test(:,2)); 
r2_speed_h3 = r_squared(speed_predictions_horizon3, speed_test(:,3)); 
% Calculate RMSE, MAPE, and R² for flow 
rmse_flow_h1 = rmse(flow_predictions_horizon1, flow_test(:,1)); 
rmse_flow_h2 = rmse(flow_predictions_horizon2, flow_test(:,2)); 
rmse_flow_h3 = rmse(flow_predictions_horizon3, flow_test(:,3)); 
mape_flow_h1 = mape(flow_predictions_horizon1, flow_test(:,1)); 
mape_flow_h2 = mape(flow_predictions_horizon2, flow_test(:,2)); 
mape_flow_h3 = mape(flow_predictions_horizon3, flow_test(:,3)); 
r2_flow_h1 = r_squared(flow_predictions_horizon1, flow_test(:,1)); 
r2_flow_h2 = r_squared(flow_predictions_horizon2, flow_test(:,2)); 
r2_flow_h3 = r_squared(flow_predictions_horizon3, flow_test(:,3)); 
% Display metrics for speed 
disp('Speed Metrics:'); 
disp(table(["17:00-17:15"; "17:15-17:30"; "17:30-17:45"], ... 
[rmse_speed_h1; rmse_speed_h2; rmse_speed_h3], ... 
[mape_speed_h1; mape_speed_h2; mape_speed_h3], ... 
[r2_speed_h1; r2_speed_h2; r2_speed_h3], ... 
    'VariableNames', {'Horizon', 'RMSE', 'MAPE', 'R2'})); 
 
% Display metrics for flow 
disp('Flow Metrics:'); 
disp(table(["17:00-17:15"; "17:15-17:30"; "17:30-17:45"], ... 
    [rmse_flow_h1; rmse_flow_h2; rmse_flow_h3], ... 
    [mape_flow_h1; mape_flow_h2; mape_flow_h3], ... 
    [r2_flow_h1; r2_flow_h2; r2_flow_h3], ... 
    'VariableNames', {'Horizon', 'RMSE', 'MAPE', 'R2'})); 
 
% Visualize predictions vs. true values for two different days 
 
    % Day 1 Visualization 
    figure; 
    subplot(2,1,1); 
    plot(1:3, speed_test(1,:), '-o', 'DisplayName', 'True Speed'); 
    hold on; 
    plot(1:3, [speed_predictions_horizon1(1), speed_predictions_horizon2(1), speed_predictions_horizon3(1)], '-s', 'DisplayName', 'Predicted Speed'); 
    title(['Speed: ', datestr(speed_test_dates(1))]); 
    xlabel('Horizon'); 
    ylabel('Speed (km/h)'); 
    xticks(1:3); 
    xticklabels({'17:00-17:15', '17:15-17:30', '17:30-17:45'}); 
    legend; 
 
    subplot(2,1,2); 
    plot(1:3, flow_test(1,:), '-o', 'DisplayName', 'True Flow'); 
    hold on; 
    plot(1:3, [flow_predictions_horizon1(1), flow_predictions_horizon2(1), flow_predictions_horizon3(1)], '-s', 'DisplayName', 'Predicted Flow'); 
    title(['Flow: ', datestr(flow_test_dates(1))]); 
    xlabel('Horizon'); 
    ylabel('Flow (veh/hr)'); 
    xticks(1:3); 
    xticklabels({'17:00-17:15', '17:15-17:30', '17:30-17:45'}); 
    legend; 
 
    % Day 2 Visualization 
    figure; 
    subplot(2,1,1); 
    plot(1:3, speed_test(2,:), '-o', 'DisplayName', 'True Speed'); 
    hold on; 
    plot(1:3, [speed_predictions_horizon1(2), speed_predictions_horizon2(2), speed_predictions_horizon3(2)], '-s', 'DisplayName', 'Predicted Speed'); 
    title(['Speed: ', datestr(speed_test_dates(2))]); 
    xlabel('Horizon'); 
    ylabel('Speed (km/h)'); 
    xticks(1:3); 
    xticklabels({'17:00-17:15', '17:15-17:30', '17:30-17:45'}); 
    legend; 
 
    subplot(2,1,2); 
    plot(1:3, flow_test(2,:), '-o', 'DisplayName', 'True Flow'); 
    hold on; 

plot(1:3, [flow_predictions_horizon1(2), flow_predictions_horizon2(2), flow_predictions_horizon3(2)], '-s', 'DisplayName', 'Predicted Flow'); 
title(['Flow: ', datestr(flow_test_dates(2))]); 
xlabel('Horizon'); 
ylabel('Flow (veh/hr)'); 
xticks(1:3); 
xticklabels({'17:00-17:15', '17:15-17:30', '17:30-17:45'}); 
legend; 
rmse.m 
function result = rmse(y_pred, y_true) 
result = sqrt(mean((y_pred - y_true).^2)); 
end 
mape.m 
function result = mape(y_pred, y_true) 
result = mean(abs((y_pred - y_true) ./ y_true)) * 100; 
end 
r_squared.m 
function r2 = r_squared(predictions, targets) 
ss_res = sum((targets - predictions).^2); 
ss_tot = sum((targets - mean(targets)).^2); 
r2 = 1 - (ss_res / ss_tot); 
end 