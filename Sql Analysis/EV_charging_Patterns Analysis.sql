USE ev_charging_db;

DESCRIBE dim_vehicles;
DESCRIBE dim_stations;
DESCRIBE dim_time;
DESCRIBE fact_charging_sessions;

SELECT * FROM fact_charging_sessions LIMIT 5;

-- Total Revenue & Total Energy Consumed ---
SELECT 
SUM(charging_cost_usd) AS total_revenue,
SUM(energy_consumed_kwh) AS total_energy
FROM fact_charging_sessions;

-- Average Charging Duration & Rate --
SELECT
AVG(charging_duration_hours) AS avg_duration,
AVG(charging_rate_kw) AS avg_rate
FROM fact_charging_sessions;

-- Location Insights - Revenue by City --
SELECT 
s.station_location,
SUM(f.charging_cost_usd) AS revenue
FROM fact_charging_sessions f
JOIN dim_stations s ON f.station_id = s.station_id
GROUP BY s.station_location
ORDER BY revenue DESC;

-- Energy Consumed by Charger Type --
SELECT 
s.charger_type,
AVG(f.energy_consumed_kwh) AS avg_energy,
AVG(f.charging_duration_hours) AS avg_duration
FROM fact_charging_sessions f
JOIN dim_stations s ON f.station_id = s.station_id
GROUP BY s.charger_type;

-- User Behavior Analysis - Sessions & Avg Duration by User Type--
SELECT 
u.user_type,
COUNT(f.session_id) AS total_sessions,
AVG(f.charging_duration_hours) AS avg_duration,
AVG(f.energy_consumed_kwh) AS avg_energy
FROM fact_charging_sessions f
JOIN dim_users u ON f.user_id = u.user_id
GROUP BY u.user_type;

-- Peak Charging Time--
SELECT 
t.time_of_day,
COUNT(f.session_id) AS session_count
FROM fact_charging_sessions f
JOIN dim_time t ON f.date = t.date
GROUP BY t.time_of_day
ORDER BY session_count DESC;

-- Vehicle Insights - Energy Consumed per Vehicle Model--
SELECT
vehicle_model,
AVG(energy_consumed_kwh) AS avg_energy,
AVG(charging_duration_hours) AS avg_duration
FROM fact_charging_sessions
GROUP BY vehicle_model
ORDER BY avg_energy DESC;

-- Charging Cost per Vehicle Model --
SELECT
vehicle_model,
SUM(charging_cost_usd) AS total_cost
FROM fact_charging_sessions
GROUP BY vehicle_model
ORDER BY total_cost DESC;

-- Time-Series / Trend Analysis --
SELECT 
date,
COUNT(session_id) AS total_sessions,
SUM(charging_cost_usd) AS daily_revenue
FROM fact_charging_sessions
GROUP BY date
ORDER BY date;

-- City + Charger Type Breakdown --
SELECT 
s.station_location,
s.charger_type,
COUNT(f.session_id) AS sessions,
SUM(f.energy_consumed_kwh) AS total_energy,
SUM(f.charging_cost_usd) AS revenue
FROM fact_charging_sessions f
JOIN dim_stations s ON f.station_id = s.station_id
GROUP BY s.station_location, s.charger_type
ORDER BY revenue DESC;








