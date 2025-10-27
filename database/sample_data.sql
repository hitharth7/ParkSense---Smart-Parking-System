-- Park Sense Sample Data
-- Run this file AFTER 'database_schema.sql' to populate your tables.

-- 1. Create a sample user
INSERT INTO Users (username, email, password_hash)
VALUES ('test_user', 'test@example.com', 'dummy_hash_123');

-- 2. Create a sample vehicle for the user
-- (Assuming 'test_user' gets user_id = 1)
INSERT INTO Vehicles (user_id, plate_number, make, model, color)
VALUES (1, 'ABC-123', 'Toyota', 'Camry', 'Silver');

-- 3. Populate ParkingSlots for Lot A
-- (Matches the simulation data from the HTML file)
INSERT INTO ParkingSlots (lot_name, slot_number, status, hourly_rate)
VALUES
('Downtown Garage (Lot A)', 'A-1', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-2', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-3', 'occupied', 5.00),
('Downtown Garage (Lot A)', 'A-4', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-5', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-6', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-7', 'occupied', 5.00),
('Downtown Garage (Lot A)', 'A-8', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-9', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-10', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-11', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-12', 'maintenance', 5.00),
('Downtown Garage (Lot A)', 'A-13', 'occupied', 5.00),
('Downtown Garage (Lot A)', 'A-14', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-15', 'available', 5.00),
('Downtown Garage (Lot A)', 'A-16', 'available', 5.00);

-- 4. Populate ParkingSlots for Lot B
INSERT INTO ParkingSlots (lot_name, slot_number, status, hourly_rate)
VALUES
('Airport Economy (Lot B)', 'B-1', 'available', 3.00),
('Airport Economy (Lot B)', 'B-2', 'occupied', 3.00),
('Airport Economy (Lot B)', 'B-3', 'occupied', 3.00),
('Airport Economy (Lot B)', 'B-4', 'available', 3.00),
('Airport Economy (Lot B)', 'B-5', 'available', 3.00),
('Airport Economy (Lot B)', 'B-6', 'available', 3.00),
('Airport Economy (Lot B)', 'B-7', 'occupied', 3.00),
('Airport Economy (Lot B)', 'B-8', 'available', 3.00),
('Airport Economy (Lot B)', 'B-9', 'available', 3.00),
('Airport Economy (Lot B)', 'B-10', 'available', 3.00),
('Airport Economy (Lot B)', 'B-11', 'available', 3.00),
('Airport Economy (Lot B)', 'B-12', 'occupied', 3.00),
('Airport Economy (Lot B)', 'B-13', 'available', 3.00),
('Airport Economy (Lot B)', 'B-14', 'available', 3.00),
('Airport Economy (Lot B)', 'B-15', 'available', 3.00),
('Airport Economy (Lot B)', 'B-16', 'maintenance', 3.00),
('Airport Economy (Lot B)', 'B-17', 'available', 3.00),
('Airport Economy (Lot B)', 'B-18', 'available', 3.00),
('Airport Economy (Lot B)', 'B-19', 'occupied', 3.00),
('Airport Economy (Lot B)', 'B-20', 'available', 3.00);

-- 5. Populate ParkingSlots for Lot C
INSERT INTO ParkingSlots (lot_name, slot_number, status, hourly_rate)
VALUES
('Mall Rooftop (Lot C)', 'C-1', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-2', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-3', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-4', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-5', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-6', 'occupied', 2.00),
('Mall Rooftop (Lot C)', 'C-7', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-8', 'available', 2.00),
('Mall Roo-ftop (Lot C)', 'C-9', 'available', 2.00),
('Mall Rooftop (Lot C)', 'C-10', 'available', 2.00);
