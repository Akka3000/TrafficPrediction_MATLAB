% Load the data 
filename = 'TNK103 1.b).xlsx'; % Replace with your actual file name 
data = readtable(filename); 
 
% Convert TIMESTAMP to datetime if necessary 
data.TIMESTAMP = datetime(data.TIMESTAMP, 'InputFormat', 'yyyy-MM-dd HH:mm:ss'); 
 
% Given parameters for the road 
V0 = 75; % Free-flow speed in km/h 
T = 0.75; % Reaction time in seconds 
rho_max = 300; % Jam density in veh/km/lane 
 
% Calculate critical density based on V0 and T 
rho_c = 1 / (V0 * (T / 3600)); % Convert T to hours for consistent units with V0 
 
% Generate triangular fundamental diagram data points 
density_triangular = linspace(0, rho_max, 100); % Density from 0 to jam density 
flow_triangular = zeros(size(density_triangular)); 
 
% Populate flow values for the triangular model 
for i = 1:length(density_triangular) 
    if density_triangular(i) <= rho_c 
        % Uncongested region: linear increase in flow 
        flow_triangular(i) = V0 * density_triangular(i); 
    else 
        % Congested region: linear decrease in flow 
        flow_triangular(i) = V0 * rho_c * (1 - (density_triangular(i) - rho_c) / (rho_max - rho_c)); 
    end 
end 
 
% Extract unique sensor IDs (PORTAL) to analyze each sensor individually 
sensors = unique(data.PORTAL); 
 
% Generate a colormap with as many colors as there are sensors 
colors = lines(length(sensors)); % 'lines' colormap generates distinct colors 
 
% Loop through each sensor and create individual plots  
for i = 1:length(sensors) 
    % Filter data for each sensor 
    sensor_data = data(strcmp(data.PORTAL, sensors{i}), :); 
     
    % Extract speed and flow for the sensor 
    speed = sensor_data.SPEED_KMH_AVG; 
    flow = sensor_data.TOTALFLOW; 
     
    % Estimate density as flow / speed (only an approximation if no density data is available) 
    density = flow ./ (speed + 1e-6); % Small epsilon to avoid division by zero 
 
    % Create a new figure for each sensor 
    figure; 
    hold on; 
     
    % Plot the empirical data for this sensor with a unique color 
    scatter(density, flow, 'o', 'MarkerEdgeColor', colors(i,:), 'DisplayName', 'Observed Data'); 
     
    % Plot the triangular fundamental diagram overlay in a fixed color 
    plot(density_triangular, flow_triangular, '-r', 'LineWidth', 2, 'DisplayName', 'Triangular Model'); 
     
    % Label the plot 
    xlabel('Density (veh/km)'); 
    ylabel('Flow (veh/h)'); 
    title(sprintf('Fundamental Diagram for Sensor %s', sensors{i})); 
    legend('show'); 
    grid on; 
    hold off; 
end 