CREATE DATABASE PARKSENSE;
USE PARKSENSE;
-- Park Sense Database Schema
-- This script creates all the necessary tables and relationships.

-- 1. Users Table
-- Stores information about registered users.
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Vehicles Table
-- Stores vehicles associated with users. A user can have multiple vehicles.
CREATE TABLE Vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plate_number VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(50),
    model VARCHAR(50),
    color VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. ParkingSlots Table
-- Stores information about each individual parking slot.
CREATE TABLE ParkingSlots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    lot_name VARCHAR(100) NOT NULL,
    slot_number VARCHAR(20) NOT NULL,
    -- 'status' here represents the *default* state, e.g., 'maintenance'.
    -- Real-time availability is a combination of this status AND current bookings.
    status ENUM('available', 'occupied', 'maintenance') NOT NULL DEFAULT 'available',
    slot_type ENUM('compact', 'regular', 'ev_charging', 'handicap') NOT NULL DEFAULT 'regular',
    hourly_rate DECIMAL(5, 2) NOT NULL DEFAULT 5.00,
    -- Add a unique constraint for lot_name and slot_number
    UNIQUE KEY uk_lot_slot (lot_name, slot_number)
);

-- 4. Bookings Table
-- This is the main transactional table, linking users, vehicles, and slots.
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    slot_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    -- end_time can be NULL for open-ended "check-in" style parking
    end_time TIMESTAMP NULL,
    expected_end_time TIMESTAMP NOT NULL,
    total_cost DECIMAL(10, 2),
    payment_status ENUM('pending', 'completed', 'failed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (slot_id) REFERENCES ParkingSlots(slot_id),
    
    -- Index for faster time-based queries
    INDEX idx_slot_time (slot_id, start_time, end_time)
);

-- 5. Payments Table (Optional but recommended)
-- Stores details of each payment transaction.
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255),
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
