// This is your Backend API (server.js)
// Run this with `node server.js`

const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');

const app = express();
const port = 3000;

// --- CONFIGURATION ---
// Enable CORS (Cross-Origin Resource Sharing)
app.use(cors());
// Enable built-in JSON parsing
app.use(express.json());

// --- !! IMPORTANT !! ---
// Change these details to match your local MySQL database
const dbConfig = {
    host: 'dbms',
    user: 'root', // Your MySQL username
    password: 'password', // Your MySQL password
    database: 'PARKSENSE' // The name of your database
};

// Create a connection pool (more efficient than single connections)
const pool = mysql.createPool(dbConfig);


// --- API ENDPOINTS ---

/**
 * @api {get} /api/lots
 * @description Get a list of all available parking lots
 */
app.get('/api/lots', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT DISTINCT lot_name FROM ParkingSlots');
        const lotNames = rows.map(row => row.lot_name);
        res.json({ lots: lotNames });
    } catch (error) {
        console.error('Error fetching lots:', error);
        res.status(500).json({ error: 'Failed to fetch parking lots' });
    }
});

/**
 * @api {get} /api/slots/:lot_name
 * @description Get all slots for a specific parking lot
 */
app.get('/api/slots', async (req, res) => {
    try {
        const lotName = req.query.lot;
        if (!lotName) {
            return res.status(400).json({ error: 'Missing "lot" query parameter' });
        }

        // Query to get slots and their hourly rate
        const [slots] = await pool.query(
            'SELECT slot_id, slot_number, status, hourly_rate FROM ParkingSlots WHERE lot_name = ?',
            [lotName]
        );
        
        // In a real app, you'd also check against 'Bookings' to find 'occupied' slots.
        // For this project, we'll just use the 'status' column from the 'ParkingSlots' table.
        
        // Get the (mocked) pricing tiers
        // This is a simplified stand-in for the pricing logic you had.
        const hourlyRate = slots.length > 0 ? parseFloat(slots[0].hourly_rate) : 0;
        const pricing = {
            '1': hourlyRate,
            '2': hourlyRate * 1.8, // e.g., 10% discount
            '3': hourlyRate * 2.5, // e.g., ~16% discount
            'all-day': hourlyRate * 6 // e.g., pay for 6 hours, get 8
        };

        res.json({
            name: lotName,
            pricing: pricing,
            slots: slots.map(s => ({
                id: s.slot_id, // Use the DB primary key
                slot_number: s.slot_number,
                status: s.status
            }))
        });

    } catch (error) {
        console.error('Error fetching slots:', error);
        res.status(500).json({ error: 'Failed to fetch slot data' });
    }
});

/**
 * @api {post} /api/book
 * @description Create a new booking by calling the stored procedure
 */
app.post('/api/book', async (req, res) => {
    try {
        // Data from the frontend fetch()
        const {
            userId,      // e.g., 1 (for 'test_user')
            vehicleId,   // e.g., 1 (for 'ABC-123')
            slotId,      // The slot_id from the DB (e.g., 1, 2, 3...)
            startTime,   // '2025-10-27T15:30'
            endTime,     // Calculated end time
            cost         // e.g., 20.00
        } = req.body;

        // --- Data Validation (Basic) ---
        if (!userId || !vehicleId || !slotId || !startTime || !endTime || !cost) {
            return res.status(400).json({ error: 'Missing required booking information.' });
        }

        // Call the Stored Procedure
        // Your procedure: sp_CreateBooking(in_user_id, in_vehicle_id, in_slot_id, in_start_time, in_expected_end_time, in_cost)
        const [result] = await pool.query(
            'CALL sp_CreateBooking(?, ?, ?, ?, ?, ?)',
            [userId, vehicleId, slotId, startTime, endTime, cost]
        );

        // The stored procedure will either succeed or throw an error (which we catch below).
        // `result[0]` might contain the `new_booking_id` if you SELECTed it.
        const newBookingId = result[0]?.[0]?.new_booking_id;

        // Also update the slot status in the ParkingSlots table
        // This is important so the UI updates immediately
        await pool.query(
            'UPDATE ParkingSlots SET status = "occupied" WHERE slot_id = ?',
            [slotId]
        );

        res.json({ success: true, bookingId: newBookingId, message: 'Booking successful!' });

    } catch (error) {
        console.error('Error creating booking:', error);

        // Check for the custom error message from our SP
        if (error.sqlState === '45000') {
            res.status(409).json({ error: error.sqlMessage }); // e.g., "Time slot conflict"
        } else {
            res.status(500).json({ error: 'Database error during booking.' });
        }
    }
});


// --- Start the server ---
app.listen(port, () => {
    console.log(`Park Sense API running on http://localhost:${port}`);
});
