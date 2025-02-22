CREATE DATABASE flutter_hospital;
USE flutter_hospital;

CREATE TABLE users (
  UserID INT PRIMARY KEY AUTO_INCREMENT,
  UserName VARCHAR(255) NOT NULL,
  UserEmail VARCHAR(255) NOT NULL UNIQUE,
  UserPassword VARCHAR(64) NOT NULL
);

CREATE TABLE locations (
  LocationID INT PRIMARY KEY AUTO_INCREMENT,
  HospitalName VARCHAR(255) NOT NULL,
  HospitalLang DECIMAL(10, 8) NOT NULL,
  HospitalLong DECIMAL(11, 8) NOT NULL,
  HospitalAddress TEXT NOT NULL,
  PlaceID VARCHAR(255),
  Distance FLOAT,
  LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add this new table for tracking user locations
CREATE TABLE location_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  UserID INT,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  address TEXT,
  user_agent VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);

ALTER TABLE locations 
  ADD COLUMN PlaceID VARCHAR(255),
  ADD COLUMN Distance FLOAT,
  ADD COLUMN LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP; 