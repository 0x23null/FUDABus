-- Sqlectron-safe seed script for SQL Server / AWS RDS.
-- Run this after sqlectron_01_reset_schema.sql on the same database.
-- The demo data is inserted relative to the database current date.

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

INSERT INTO Users (username, password, email, fullName, phoneNumber, role)
VALUES
    (N'admin', N'admin123', N'admin@bus.com', N'Quản trị hệ thống', N'0900000001', N'Admin'),
    (N'demo', N'demo123', N'demo@bus.com', N'Khách hàng demo', N'0900000002', N'Customer');

INSERT INTO Buses (busNumber, seatCapacity, busType, imageURL)
VALUES
    (N'82B-100.01', 34, N'Limousine', N'assets/images/bus_home.png'),
    (N'82B-100.02', 40, N'Giường nằm', N'assets/images/bus_home.png'),
    (N'82B-100.03', 28, N'Cabin đôi', N'assets/images/bus_home.png');

INSERT INTO Routes (origin, destination, distance, duration, description)
VALUES
    (N'Hà Nội', N'Đà Nẵng', 760, 900, N'Tuyến demo cho flow một chiều và khứ hồi'),
    (N'Đà Nẵng', N'Hà Nội', 760, 900, N'Chiều về của tuyến Hà Nội - Đà Nẵng'),
    (N'Kon Tum', N'Đà Nẵng', 300, 360, N'Tuyến demo cho flow khứ hồi'),
    (N'Đà Nẵng', N'Kon Tum', 300, 360, N'Chiều về của tuyến Kon Tum - Đà Nẵng'),
    (N'Hồ Chí Minh', N'Đà Lạt', 310, 420, N'Tuyến demo cho flow khứ hồi'),
    (N'Đà Lạt', N'Hồ Chí Minh', 310, 420, N'Chiều về của tuyến Hồ Chí Minh - Đà Lạt');

DECLARE @bus1 INT = (SELECT busID FROM Buses WHERE busNumber = N'82B-100.01');
DECLARE @bus2 INT = (SELECT busID FROM Buses WHERE busNumber = N'82B-100.02');
DECLARE @bus3 INT = (SELECT busID FROM Buses WHERE busNumber = N'82B-100.03');
DECLARE @routeHN_DN INT = (SELECT routeID FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Đà Nẵng');
DECLARE @routeDN_HN INT = (SELECT routeID FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Hà Nội');
DECLARE @routeKT_DN INT = (SELECT routeID FROM Routes WHERE origin = N'Kon Tum' AND destination = N'Đà Nẵng');
DECLARE @routeDN_KT INT = (SELECT routeID FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Kon Tum');
DECLARE @routeHCM_DL INT = (SELECT routeID FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Đà Lạt');
DECLARE @routeDL_HCM INT = (SELECT routeID FROM Routes WHERE origin = N'Đà Lạt' AND destination = N'Hồ Chí Minh');
DECLARE @today DATE = CAST(GETDATE() AS DATE);

INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES
    (@routeHN_DN, @bus1, DATEADD(MINUTE, 450, CAST(DATEADD(DAY, 1, @today) AS DATETIME)), DATEADD(MINUTE, 1350, CAST(DATEADD(DAY, 1, @today) AS DATETIME)), 435000, N'Scheduled'),
    (@routeHN_DN, @bus2, DATEADD(MINUTE, 1260, CAST(DATEADD(DAY, 1, @today) AS DATETIME)), DATEADD(MINUTE, 360, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), 455000, N'Scheduled'),
    (@routeDN_HN, @bus1, DATEADD(MINUTE, 510, CAST(DATEADD(DAY, 3, @today) AS DATETIME)), DATEADD(MINUTE, 1410, CAST(DATEADD(DAY, 3, @today) AS DATETIME)), 435000, N'Scheduled'),
    (@routeDN_HN, @bus3, DATEADD(MINUTE, 1200, CAST(DATEADD(DAY, 3, @today) AS DATETIME)), DATEADD(MINUTE, 300, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), 475000, N'Scheduled'),

    (@routeKT_DN, @bus1, DATEADD(MINUTE, 480, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), DATEADD(MINUTE, 840, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), 335000, N'Scheduled'),
    (@routeKT_DN, @bus2, DATEADD(MINUTE, 1260, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), DATEADD(MINUTE, 180, CAST(DATEADD(DAY, 3, @today) AS DATETIME)), 355000, N'Scheduled'),
    (@routeDN_KT, @bus1, DATEADD(MINUTE, 540, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), DATEADD(MINUTE, 900, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), 335000, N'Scheduled'),
    (@routeDN_KT, @bus2, DATEADD(MINUTE, 1200, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), DATEADD(MINUTE, 120, CAST(DATEADD(DAY, 5, @today) AS DATETIME)), 355000, N'Scheduled'),

    (@routeHCM_DL, @bus2, DATEADD(MINUTE, 420, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), DATEADD(MINUTE, 840, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), 290000, N'Scheduled'),
    (@routeHCM_DL, @bus3, DATEADD(MINUTE, 1320, CAST(DATEADD(DAY, 2, @today) AS DATETIME)), DATEADD(MINUTE, 300, CAST(DATEADD(DAY, 3, @today) AS DATETIME)), 320000, N'Scheduled'),
    (@routeDL_HCM, @bus2, DATEADD(MINUTE, 480, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), DATEADD(MINUTE, 900, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), 290000, N'Scheduled'),
    (@routeDL_HCM, @bus3, DATEADD(MINUTE, 1260, CAST(DATEADD(DAY, 4, @today) AS DATETIME)), DATEADD(MINUTE, 240, CAST(DATEADD(DAY, 5, @today) AS DATETIME)), 320000, N'Scheduled');