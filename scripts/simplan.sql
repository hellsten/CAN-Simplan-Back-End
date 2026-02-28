-- drops old databse if it exists and creats a fresh one
DROP DATABASE IF EXISTS simplan;
CREATE DATABASE simplan;
USE simplan;

-- base planing table - core proposal data (zoning, units, transit, approval score)
CREATE TABLE base_planning (
    application_id VARCHAR(50) PRIMARY KEY,
    submission_date DATE,
    district_id INT,
    district_name VARCHAR(100),
    proposed_use VARCHAR(255),
    max_storeys INT,
    residential_units INT,
    non_residential_gfa_m2 DECIMAL(12, 2),
    inside_mtsa TINYINT,
    mtsa_corridor VARCHAR(100),
    distance_to_transit_m INT,
    approval_score INT,
    synthetic_approval TINYINT
);

-- social/economic scores - rent forcast, displacement risk, transit impact
CREATE TABLE social_economic_scores (
    application_id VARCHAR(50) PRIMARY KEY,
    rent_increase_forecast_pct DECIMAL(5, 2),
    rent_burden_score INT,
    displacement_risk_score INT,
    transit_speed_impact_score INT,
    FOREIGN KEY (application_id) REFERENCES base_planning(application_id) ON DELETE CASCADE
);

-- finacial risk - property value, default risk, loan feasability
CREATE TABLE financial_scores (
    application_id VARCHAR(50) PRIMARY KEY,
    property_value_change_pct DECIMAL(6, 2),
    default_risk_score INT,
    capital_concentration_risk INT,
    construction_loan_feasibility INT,
    insurance_premium_shift_index INT,
    FOREIGN KEY (application_id) REFERENCES base_planning(application_id) ON DELETE CASCADE
);

-- users table for login - stores email and hashed pasword
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- urban impact - population increase, traffic delta, enviornmental stress
CREATE TABLE urban_impact_scores (
    application_id VARCHAR(50) PRIMARY KEY,
    projected_population_increase INT,
    traffic_delta_pct DECIMAL(5, 2),
    environmental_stress_change INT,
    shadow_impact_score INT,
    transit_rider_impact INT,
    estimated_new_riders_daily INT,
    FOREIGN KEY (application_id) REFERENCES base_planning(application_id) ON DELETE CASCADE
);
