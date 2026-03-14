-- Run this after rds_reset_schema.sql on the same database.
-- This seed focuses on round-trip demo pairs so the new flow can be tested immediately.

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF NOT EXISTS (SELECT 1 FROM Buses WHERE busNumber = N'82B-100.01')
    INSERT INTO Buses (busNumber, seatCapacity, busType, imageURL)
    VALUES (N'82B-100.01', 34, N'Limousine', N'assets/images/bus_home.png');
GO

IF NOT EXISTS (SELECT 1 FROM Buses WHERE busNumber = N'82B-100.02')
    INSERT INTO Buses (busNumber, seatCapacity, busType, imageURL)
    VALUES (N'82B-100.02', 40, N'Giuong nam', N'assets/images/bus_home.png');
GO

IF NOT EXISTS (SELECT 1 FROM Routes WHERE origin = N'Kon Tum' AND destination = N'Da Nang')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Kon Tum', N'Da Nang', 300, 360, N'Tuyen demo cho flow khu hoi');
GO

IF NOT EXISTS (SELECT 1 FROM Routes WHERE origin = N'Da Nang' AND destination = N'Kon Tum')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Da Nang', N'Kon Tum', 300, 360, N'Tuyen demo chieu ve cho flow khu hoi');
GO

IF NOT EXISTS (SELECT 1 FROM Routes WHERE origin = N'Ho Chi Minh' AND destination = N'Da Lat')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Ho Chi Minh', N'Da Lat', 310, 420, N'Tuyen demo cho flow khu hoi');
GO

IF NOT EXISTS (SELECT 1 FROM Routes WHERE origin = N'Da Lat' AND destination = N'Ho Chi Minh')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Da Lat', N'Ho Chi Minh', 310, 420, N'Tuyen demo chieu ve cho flow khu hoi');
GO

DECLARE @busA INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'82B-100.01');
DECLARE @busB INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'82B-100.02');
DECLARE @r_kontum_danang INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Kon Tum' AND destination = N'Da Nang');
DECLARE @r_danang_kontum INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Da Nang' AND destination = N'Kon Tum');
DECLARE @r_hcm_dalat INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Ho Chi Minh' AND destination = N'Da Lat');
DECLARE @r_dalat_hcm INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Da Lat' AND destination = N'Ho Chi Minh');

IF NOT EXISTS (SELECT 1 FROM Trips WHERE routeID = @r_kontum_danang AND CONVERT(DATE, departureTime) = CONVERT(DATE, DATEADD(DAY, 2, GETDATE())))
BEGIN
    INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
    VALUES
    (@r_kontum_danang, @busA,
        DATEADD(HOUR, 8, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
        335000, 'Scheduled'),
    (@r_kontum_danang, @busB,
        DATEADD(HOUR, 21, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 3, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
        355000, 'Scheduled');
END
GO

IF NOT EXISTS (SELECT 1 FROM Trips WHERE routeID = @r_danang_kontum AND CONVERT(DATE, departureTime) = CONVERT(DATE, DATEADD(DAY, 4, GETDATE())))
BEGIN
    INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
    VALUES
    (@r_danang_kontum, @busA,
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 15, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
        335000, 'Scheduled'),
    (@r_danang_kontum, @busB,
        DATEADD(HOUR, 20, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 2, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
        355000, 'Scheduled');
END
GO

IF NOT EXISTS (SELECT 1 FROM Trips WHERE routeID = @r_hcm_dalat AND CONVERT(DATE, departureTime) = CONVERT(DATE, DATEADD(DAY, 3, GETDATE())))
BEGIN
    INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
    VALUES
    (@r_hcm_dalat, @busA,
        DATEADD(HOUR, 7, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
        290000, 'Scheduled'),
    (@r_hcm_dalat, @busB,
        DATEADD(HOUR, 22, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 5, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
        320000, 'Scheduled');
END
GO

IF NOT EXISTS (SELECT 1 FROM Trips WHERE routeID = @r_dalat_hcm AND CONVERT(DATE, departureTime) = CONVERT(DATE, DATEADD(DAY, 5, GETDATE())))
BEGIN
    INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
    VALUES
    (@r_dalat_hcm, @busA,
        DATEADD(HOUR, 8, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 15, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
        290000, 'Scheduled'),
    (@r_dalat_hcm, @busB,
        DATEADD(HOUR, 21, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
        DATEADD(HOUR, 4, CAST(DATEADD(DAY, 6, CAST(GETDATE() AS DATE)) AS DATETIME)),
        320000, 'Scheduled');
END
GO
