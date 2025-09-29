> Traffic data analysis and short-term prediction using MATLAB: fundamental diagrams, heatmaps, clustering, and KNN forecasting.


# TrafficPrediction_MATLAB

This repository contains MATLAB scripts and results from a traffic data analysis and prediction project.  
The goal was to analyze traffic flow and speed patterns, identify typical day profiles, and perform short-term traffic prediction using K-Nearest Neighbors (KNN).

---

## Dataset
- **Source:** Swedish Transport Administration & Traffic Management Center, Stockholm  
- **Period:** April–May 2022 (61 days)  
- **Sensors:** 8 radar sensors along the southbound E4 highway  
- **Resolution:** 15-minute intervals, 05:00–21:45 daily  
- **Variables:** average speed (km/h), total flow (vehicles/hour)  
- **Size:** ~66,000 measurements (all sensors combined)  

⚠️ Raw data cannot be shared here. Scripts are provided to reproduce the analysis when data is available.

---

## Methods
1. **Fundamental diagrams** – Triangular flow-density-speed model vs observed data  
2. **Heatmaps** – Visualization of speed and flow across days and times  
3. **Daily profiles** – Overlapping line plots for each day (speed & flow)  
4. **Clustering (K-means)** – Identification of typical traffic day patterns  
5. **Prediction (KNN)** – Forecast of speed and flow 15 minutes ahead  
   - Training 60%, testing 20%, validation 20%  
   - Performance metrics: RMSE, MAPE, R²  

---

## Results (highlights)
- Fundamental diagrams showed good agreement for sensors E4S 55,620, E4S 56,160, and E4S 58,140.  
- Heatmaps revealed consistent congestion in the afternoon (15:30–17:30).  
- Clustering identified three typical patterns for speed and flow (weekday congestion, weekends, and heavy traffic days).  
- KNN prediction achieved low errors:
  - Speed RMSE ≈ 1–2 km/h, MAPE ≈ 2–3%, R² > 0.99  
  - Flow RMSE ≈ 130–200 veh/h, MAPE ≈ 4–6%, R² ≈ 0.96  

---

## How to run
1. Clone this repo.  
2. Open scripts in MATLAB.  
3. Provide traffic data in the same format as used in the report (15-minute aggregated).  
4. Run scripts individually to reproduce plots and metrics.  

---
