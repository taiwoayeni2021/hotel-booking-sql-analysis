--1. Create a database named hotel_booking_db.

--2. Create 3 tables namely: bookings, guest and room.

CREATE TABLE bookings(
	booking_id INTEGER NOT NULL PRIMARY KEY,
	guest_id INTEGER,
	room_id INTEGER,
	check_in_date DATE,
	check_out_date DATE,
	booking_date DATE,
	total_amount DECIMAL(10,2),
	booking_channel VARCHAR(15)
);

CREATE TABLE guest(
	guest_id INTEGER NOT NULL PRIMARY KEY,
	first_name VARCHAR(10),
	last_name VARCHAR(10),
	country VARCHAR(20),
	email VARCHAR(20)
);

CREATE TABLE room(
	room_id INTEGER NOT NULL PRIMARY KEY,
	room_type VARCHAR(10),
	price_per_night DECIMAL(10,2),
	capacity INTEGER,
	hotel_branch VARCHAR(15)
);

--3. ADD FOREIGN KEYS USING ALTER TABLE 
--1. To add guest_id foreign key to 'bookings' table
ALTER TABLE bookings
ADD CONSTRAINT fk_guest
FOREIGN KEY (guest_id)
REFERENCES guest(guest_id);

--2. To add room_id foreign key to 'bookings' table
ALTER TABLE bookings
ADD CONSTRAINT fk_room
FOREIGN KEY (room_id)
REFERENCES room(room_id);

--4. Values were imported and the following analysis were performed.

--A. BOOKING PERFORMANCE & REVENUE
--1. Total Revenue
SELECT SUM(total_amount) total_revenue
FROM bookings;

--2. Revenue By Room Type
SELECT room_type, SUM(total_amount) revenue
FROM room r
JOIN bookings b
ON r.room_id = b.room_id
GROUP BY room_type
ORDER BY revenue DESC;

--3. Average Booking Value
SELECT ROUND(AVG(total_amount), 2) average_booking_value
FROM bookings;

--B. GUEST BEHAVIOUR
--1. Top 5 Guests by spending
SELECT first_name, last_name, SUM(total_amount) total_amount_spent
FROM guest g
JOIN bookings b
ON g.guest_id = b.guest_id
GROUP BY first_name, last_name
ORDER BY total_amount_spent DESC
LIMIT 5;

--2. Guest nationality Distribution
SELECT country, COUNT(*) count_of_guests
FROM guest
GROUP BY country
ORDER BY count_of_guests DESC;

--3. 5 Most frequent guests
SELECT first_name, last_name, COUNT(*) total_bookings
FROM guest g
JOIN bookings b
ON g.guest_id = b.guest_id
GROUP BY first_name, last_name
ORDER BY total_bookings DESC
LIMIT 5;

--C. BOOKING TREND
--1. Bookings by Channel
SELECT booking_channel, COUNT(*) total_bookings
FROM bookings
GROUP BY booking_channel
ORDER BY total_bookings DESC;

--2. Most Popular Room type
SELECT room_type, COUNT(*) number_of_bookings
FROM bookings b
JOIN room r
ON b.room_id = r.room_id
GROUP BY room_type
ORDER BY number_of_bookings DESC;

--3. Daily Booking Trend
SELECT booking_date, COUNT(*) bookings
FROM bookings
GROUP BY booking_date
ORDER BY booking_date;

--D. OPERATIONAL INSIGHTS
--1. Average Stay duration per Room type
SELECT room_type, ROUND(AVG(check_out_date - check_in_date), 2) average_nights
FROM room r
JOIN bookings b
ON r.room_id = b.room_id
GROUP BY room_type
ORDER BY average_nights DESC;

--2. Occupancy by Hotel Branch
SELECT hotel_branch, COUNT(*) occupancy
FROM room r
JOIN bookings b
ON r.room_id = b.room_id
GROUP BY hotel_branch
ORDER BY occupancy DESC;
