-- Smoke check for the weekly demo seed.
-- Run this after sqlectron_04_seed_demo_week.sql.

SELECT COUNT(*) AS UserCount FROM Users;
SELECT COUNT(*) AS BusCount FROM Buses;
SELECT COUNT(*) AS RouteCount FROM Routes;
SELECT COUNT(*) AS TripCount FROM Trips;

SELECT
    CONVERT(DATE, departureTime) AS TripDate,
    COUNT(*) AS TripsPerDay
FROM Trips
GROUP BY CONVERT(DATE, departureTime)
ORDER BY TripDate;

SELECT TOP 40
    t.tripID,
    r.origin,
    r.destination,
    t.departureTime,
    t.arrivalTime,
    t.price,
    b.busNumber,
    b.busType
FROM Trips t
JOIN Routes r ON r.routeID = t.routeID
JOIN Buses b ON b.busID = t.busID
ORDER BY t.departureTime ASC, r.origin ASC, r.destination ASC;
