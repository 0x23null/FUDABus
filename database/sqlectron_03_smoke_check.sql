-- Optional smoke-check after running the reset and seed scripts.

SELECT COUNT(*) AS UserCount FROM Users;
SELECT COUNT(*) AS RouteCount FROM Routes;
SELECT COUNT(*) AS TripCount FROM Trips;

SELECT TOP 20
    t.tripID,
    r.origin,
    r.destination,
    t.departureTime,
    t.arrivalTime,
    t.price,
    t.status,
    b.busNumber,
    b.busType
FROM Trips t
JOIN Routes r ON t.routeID = r.routeID
JOIN Buses b ON t.busID = b.busID
ORDER BY t.departureTime ASC;