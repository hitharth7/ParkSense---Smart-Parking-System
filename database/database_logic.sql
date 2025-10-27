-- Park Sense Advanced Database Logic
-- This file contains stored procedures and triggers
-- to ensure data integrity and automate complex tasks.

-- 1. Stored Procedure: sp_CreateBooking
-- This procedure safely creates a new booking, checking for conflicts.
-- This is what your backend service would call.

DELIMITER $$

CREATE PROCEDURE sp_CreateBooking(
    IN in_user_id INT,
    IN in_vehicle_id INT,
    IN in_slot_id INT,
    IN in_start_time TIMESTAMP,
    IN in_expected_end_time TIMESTAMP,
    IN in_cost DECIMAL(10, 2)
)
BEGIN
    DECLARE conflict_count INT DEFAULT 0;
    DECLARE slot_status ENUM('available', 'occupied', 'maintenance');

    -- Start a transaction
    START TRANSACTION;

    -- 1. Check if the slot is under maintenance
    SELECT status INTO slot_status
    FROM ParkingSlots
    WHERE slot_id = in_slot_id
    FOR UPDATE; -- Lock the row for this transaction

    IF slot_status = 'maintenance' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Selected slot is under maintenance.';
    END IF;

    -- 2. Check for time-based booking conflicts
    -- A conflict exists if another booking for this slot overlaps
    -- (StartA < EndB) AND (EndA > StartB)
    SELECT COUNT(*)
    INTO conflict_count
    FROM Bookings
    WHERE
        slot_id = in_slot_id
        AND payment_status IN ('pending', 'completed')
        AND in_start_time < expected_end_time
        AND in_expected_end_time > start_time;

    IF conflict_count > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Time slot conflict. Slot is already booked for this period.';
    ELSE
        -- 3. No conflicts found, insert the new booking
        INSERT INTO Bookings (
            user_id,
            vehicle_id,
            slot_id,
            start_time,
            expected_end_time,
            total_cost,
            payment_status
        ) VALUES (
            in_user_id,
            in_vehicle_id,
            in_slot_id,
            in_start_time,
            in_expected_end_time,
            in_cost,
            'completed' -- Assume payment is successful for this procedure
        );
        
        -- Commit the transaction
        COMMIT;
        
        -- Optionally, return the new booking ID
        SELECT LAST_INSERT_ID() AS new_booking_id;
    END IF;

END$$

DELIMITER ;


-- 2. Trigger: trg_ValidateVehicleOwner
-- This trigger fires BEFORE a booking is inserted to ensure
-- the vehicle being used actually belongs to the user making the booking.
-- This enforces "consistency and integrity" as you mentioned.

DELIMITER $$

CREATE TRIGGER trg_ValidateVehicleOwner
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE vehicle_owner_id INT;

    -- Find the owner of the vehicle
    SELECT user_id
    INTO vehicle_owner_id
    FROM Vehicles
    WHERE vehicle_id = NEW.vehicle_id;

    -- If the vehicle's owner is not the user making the booking, raise an error
    IF vehicle_owner_id != NEW.user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Integrity Error: The selected vehicle does not belong to the booking user.';
    END IF;
END$$

DELIMITER ;
