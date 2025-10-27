Park Sense - Smart Parking Management System

Park Sense is a full-stack web application designed to automate and streamline parking management. It provides real-time slot availability, a seamless reservation system, and dynamic pricing, enhancing user convenience while ensuring efficient utilization of parking spaces.

This project is a demonstration of a 3-tier architecture, with a focus on robust backend database management using MySQL, including stored procedures and triggers to ensure data integrity and prevent booking conflicts.

✨ Features

Real-Time Lot Viewing: Users can select a parking lot and see an up-to-the-minute visual grid of all available, occupied, and maintenance-locked slots.

Dynamic Booking: Select a date, time, and duration to book a specific slot.

Dynamic Pricing: The booking cost is calculated instantly based on the lot's hourly rate and the selected duration.

Conflict-Free Reservations: The backend uses a MySQL stored procedure to ensure that two users cannot book the same slot at the same time.

Data Integrity: A MySQL trigger prevents a booking from being made unless the user's vehicle is properly registered in the database.

🛠️ Tech Stack

Frontend: HTML5, Tailwind CSS, JavaScript (ES6+)

Backend: Node.js, Express.js

Database: MySQL

Core Concepts: REST API, 3-Tier Architecture, Database Triggers, Stored Procedures, Data Normalization.

🗃️ Core Database Logic

This project's intelligence lies in the database itself.

sp_CreateBooking (Stored Procedure)

This procedure is called by the API instead of a simple INSERT query. It wraps the entire booking process in a transaction to ensure it's "all or nothing."

Logic:

Check for Conflicts: It first checks if the desired slot_id has any other bookings that overlap with the new in_start_time and in_expected_end_time.

Prevent Double Booking: If a conflict is found, it raises a custom SQL error (SQLSTATE '45000') with the message "Time slot conflict! This slot is already booked for the selected time."

Book Slot: If no conflict exists, it inserts the new booking and commits the transaction.

trg_CheckVehicleOwner (Trigger)

This trigger is attached to the Bookings table and runs before any new row is inserted.

Logic:

It checks if the in_vehicle_id being booked actually belongs to the in_user_id making the booking.

If the vehicle is not registered to that user, it raises a custom SQL error with the message "Vehicle does not belong to this user."
