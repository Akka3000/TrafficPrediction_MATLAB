% Load speed and flow data 
speed_filename = 'E4S 58,140 speed.xlsx';  
speed_data = readtable(speed_filename); 
 
flow_filename = 'E4S 58,140 flow.xlsx';  
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
HT1 2024 TNK120 Almir Nokic 
speed_test_dates = speed_data.DATE(test_idx); 
flow_test_dates = flow_data.DATE(test_idx); 
 
% Display sizes to verify splits 
disp(['Training set size (speed): ', num2str(size(speed_train, 1))]); 
disp(['Test set size (speed): ', num2str(size(speed_test, 1))]); 
disp(['Validation set size (speed): ', num2str(size(speed_val, 1))]); 
 
disp(['Training set size (flow): ', num2str(size(flow_train, 1))]); 
disp(['Test set size (flow): ', num2str(size(flow_test, 1))]); 
disp(['Validation set size (flow): ', num2str(size(flow_val, 1))]); 
 
% Define K for KNN (K = 1 for this step) 
K = 1; 
 
% Make predictions for speed 
speed_predictions_horizon1 = knn_predict(speed_train(:,1), speed_test(:, 1), K); % 17:00-17:15 
speed_predictions_horizon2 = knn_predict(speed_train(:,2), speed_test(:, 2), K); % 17:15-17:30 
speed_predictions_horizon3 = knn_predict(speed_train(:,3), speed_test(:, 3), K); % 17:30-17:45 
 
% Make predictions for flow 
flow_predictions_horizon1 = knn_predict(flow_train(:,1), flow_test(:, 1), K); % 17:00-17:15 
flow_predictions_horizon2 = knn_predict(flow_train(:,2), flow_test(:, 2), K); % 17:15-17:30 
flow_predictions_horizon3 = knn_predict(flow_train(:,3), flow_test(:, 3), K); % 17:30-17:45 
 
% Display speed predictions with dates 
disp('Speed Predictions with Dates:'); 
disp(table(speed_test_dates, speed_predictions_horizon1, speed_predictions_horizon2, 
speed_predictions_horizon3, ... 
    'VariableNames', {'Date', 'Prediction_17:00-17:15', 'Prediction_17:15-17:30', 'Prediction_17:30-17:45'})); 
 
% Display flow predictions with dates 
disp('Flow Predictions with Dates:'); 
disp(table(flow_test_dates, flow_predictions_horizon1, flow_predictions_horizon2, 
flow_predictions_horizon3, ... 
    'VariableNames', {'Date', 'Prediction_17:00-17:15', 'Prediction_17:15-17:30', 'Prediction_17:30-17:45'})); 
 
%Seperate function
knn_predict.m 
function predictions = knn_predict(train_data, test_data, K) 
% Check inputs 
if K > size(train_data, 1) 
error('K cannot be greater than the number of training samples.'); 
end 
% Initialize predictions matrix 
[num_test_samples, num_features] = size(test_data); 
predictions = zeros(num_test_samples, num_features); 
% Loop over each test sample 
for i = 1:num_test_samples 
% Compute Euclidean distances between test sample and all training samples 
distances = sqrt(sum((train_data - test_data(i, :)).^2, 2)); 
% Sort distances and get indices of the K nearest neighbors 
[~, sorted_indices] = sort(distances); 
nearest_neighbors = sorted_indices(1:K); 
% Predict the mean value of the K nearest neighbors 
predictions(i, :) = mean(train_data(nearest_neighbors, :), 1); 
end 
end