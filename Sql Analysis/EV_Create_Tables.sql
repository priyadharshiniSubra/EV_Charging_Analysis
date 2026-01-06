CREATE DATABASE ev_charging_db;
USE ev_charging_db;

SET GLOBAL local_infile = 1;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE dim_users (
    user_id VARCHAR(20) PRIMARY KEY,
    user_type VARCHAR(50));
   
LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/dim_users.csv'
INTO TABLE dim_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE dim_vehicles (
    vehicle_model VARCHAR(50),
    battery_capacity_kwh DECIMAL(8,3),
    user_id VARCHAR(20),
    PRIMARY KEY (vehicle_model, user_id),
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id));
    
LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/dim_vehicles.csv'
INTO TABLE dim_vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE dim_stations (
    station_id VARCHAR(20),
    station_location VARCHAR(50),
    charger_type VARCHAR(50),
    PRIMARY KEY (station_id, station_location, charger_type));

LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/dim_stations.csv'
INTO TABLE dim_stations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE dim_time (
    date DATE,
    day_of_week VARCHAR(20),
    time_of_day VARCHAR(20),
    PRIMARY KEY (date, day_of_week, time_of_day));
    
LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/dim_time.csv'
INTO TABLE dim_time
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

    
CREATE TABLE fact_charging_sessions (
    session_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    vehicle_model VARCHAR(50),
    station_id VARCHAR(20),
    date DATE,
    charging_duration_hours DECIMAL(6,3),
    energy_consumed_kwh DECIMAL(8,3),
    charging_rate_kw DECIMAL(6,3),
    charging_cost_usd DECIMAL(6,2),
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
    FOREIGN KEY (station_id) REFERENCES dim_stations(station_id),
    FOREIGN KEY (date) REFERENCES dim_time(date));

LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/fact_charging_sessions.csv'
INTO TABLE fact_charging_sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;





