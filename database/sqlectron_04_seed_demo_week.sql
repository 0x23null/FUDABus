-- Sqlectron-safe weekly demo seed for SQL Server / AWS RDS.
-- Run this after sqlectron_01_reset_schema.sql on the same database.
-- This script seeds enough routes/trips for one-way and round-trip demos
-- from 2026-03-15 through 2026-03-21.

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

INSERT INTO Users (username, password, email, fullName, phoneNumber, role)
VALUES
    (N'admin', N'admin123', N'admin@fudabus.store', N'Quản trị hệ thống', N'0900000001', N'Admin'),
    (N'demo', N'demo123', N'demo@fudabus.store', N'Khách hàng demo', N'0900000002', N'Customer'),
    (N'lan', N'lan123', N'lan@fudabus.store', N'Nguyễn Thị Lan', N'0912345678', N'Customer');

INSERT INTO Buses (busNumber, seatCapacity, busType, imageURL)
VALUES
    (N'82B-100.01', 34, N'Limousine', N'assets/images/bus_home.png'),
    (N'82B-100.02', 40, N'Giường nằm', N'assets/images/bus_home.png'),
    (N'82B-100.03', 28, N'Cabin đôi', N'assets/images/bus_home.png'),
    (N'82B-100.04', 45, N'Ghế ngồi', N'assets/images/bus_home.png'),
    (N'82B-100.05', 36, N'Limousine VIP', N'assets/images/bus_home.png'),
    (N'82B-100.06', 22, N'Cabin đơn', N'assets/images/bus_home.png');

INSERT INTO Routes (origin, destination, distance, duration, description)
VALUES
    (N'Hà Nội', N'Đà Nẵng', 760, 900, N'Tuyến trục Bắc Trung Bộ, phù hợp demo một chiều và khứ hồi'),
    (N'Đà Nẵng', N'Hà Nội', 760, 900, N'Chiều về của tuyến Hà Nội - Đà Nẵng'),
    (N'Kon Tum', N'Đà Nẵng', 300, 360, N'Tuyến Tây Nguyên về miền Trung'),
    (N'Đà Nẵng', N'Kon Tum', 300, 360, N'Chiều về của tuyến Kon Tum - Đà Nẵng'),
    (N'Hồ Chí Minh', N'Đà Lạt', 310, 420, N'Tuyến du lịch phổ biến dịp cuối tuần'),
    (N'Đà Lạt', N'Hồ Chí Minh', 310, 420, N'Chiều về của tuyến Hồ Chí Minh - Đà Lạt'),
    (N'Hồ Chí Minh', N'Nha Trang', 430, 510, N'Tuyến biển cho flow một chiều và khứ hồi'),
    (N'Nha Trang', N'Hồ Chí Minh', 430, 510, N'Chiều về của tuyến Hồ Chí Minh - Nha Trang'),
    (N'Đà Nẵng', N'Huế', 100, 180, N'Tuyến ngắn phù hợp khách đi trong ngày'),
    (N'Huế', N'Đà Nẵng', 100, 180, N'Chiều về của tuyến Đà Nẵng - Huế'),
    (N'Hà Nội', N'Sa Pa', 320, 360, N'Tuyến du lịch miền núi phía Bắc'),
    (N'Sa Pa', N'Hà Nội', 320, 360, N'Chiều về của tuyến Hà Nội - Sa Pa');

DECLARE @baseDate DATE = '2026-03-15';

DECLARE @routeTemplates TABLE (
    origin NVARCHAR(100),
    destination NVARCHAR(100),
    morningBus NVARCHAR(20),
    morningDepartMinute INT,
    eveningBus NVARCHAR(20),
    eveningDepartMinute INT,
    durationMinutes INT,
    morningPrice DECIMAL(18,2),
    eveningPrice DECIMAL(18,2)
);

INSERT INTO @routeTemplates (origin, destination, morningBus, morningDepartMinute, eveningBus, eveningDepartMinute, durationMinutes, morningPrice, eveningPrice)
VALUES
    (N'Hà Nội', N'Đà Nẵng', N'82B-100.01', 450, N'82B-100.02', 1260, 900, 435000, 455000),
    (N'Đà Nẵng', N'Hà Nội', N'82B-100.05', 480, N'82B-100.03', 1200, 900, 445000, 475000),
    (N'Kon Tum', N'Đà Nẵng', N'82B-100.01', 480, N'82B-100.02', 1260, 360, 335000, 355000),
    (N'Đà Nẵng', N'Kon Tum', N'82B-100.05', 540, N'82B-100.02', 1200, 360, 335000, 355000),
    (N'Hồ Chí Minh', N'Đà Lạt', N'82B-100.04', 420, N'82B-100.03', 1320, 420, 290000, 320000),
    (N'Đà Lạt', N'Hồ Chí Minh', N'82B-100.04', 480, N'82B-100.03', 1260, 420, 290000, 320000),
    (N'Hồ Chí Minh', N'Nha Trang', N'82B-100.05', 510, N'82B-100.02', 1290, 510, 365000, 395000),
    (N'Nha Trang', N'Hồ Chí Minh', N'82B-100.05', 480, N'82B-100.02', 1230, 510, 365000, 395000),
    (N'Đà Nẵng', N'Huế', N'82B-100.04', 390, N'82B-100.01', 990, 180, 145000, 165000),
    (N'Huế', N'Đà Nẵng', N'82B-100.04', 450, N'82B-100.01', 1050, 180, 145000, 165000),
    (N'Hà Nội', N'Sa Pa', N'82B-100.06', 390, N'82B-100.02', 1290, 360, 285000, 315000),
    (N'Sa Pa', N'Hà Nội', N'82B-100.06', 450, N'82B-100.02', 1230, 360, 285000, 315000);

DECLARE @dayOffsets TABLE (dayOffset INT PRIMARY KEY);
INSERT INTO @dayOffsets (dayOffset)
VALUES (0), (1), (2), (3), (4), (5), (6);

INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
SELECT
    r.routeID,
    bMorning.busID,
    DATEADD(MINUTE, rt.morningDepartMinute, CAST(DATEADD(DAY, d.dayOffset, @baseDate) AS DATETIME)),
    DATEADD(MINUTE, rt.morningDepartMinute + rt.durationMinutes, CAST(DATEADD(DAY, d.dayOffset, @baseDate) AS DATETIME)),
    rt.morningPrice,
    N'Scheduled'
FROM @routeTemplates rt
JOIN Routes r
    ON r.origin = rt.origin
   AND r.destination = rt.destination
JOIN Buses bMorning
    ON bMorning.busNumber = rt.morningBus
CROSS JOIN @dayOffsets d;

INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
SELECT
    r.routeID,
    bEvening.busID,
    DATEADD(MINUTE, rt.eveningDepartMinute, CAST(DATEADD(DAY, d.dayOffset, @baseDate) AS DATETIME)),
    DATEADD(MINUTE, rt.eveningDepartMinute + rt.durationMinutes, CAST(DATEADD(DAY, d.dayOffset, @baseDate) AS DATETIME)),
    rt.eveningPrice,
    N'Scheduled'
FROM @routeTemplates rt
JOIN Routes r
    ON r.origin = rt.origin
   AND r.destination = rt.destination
JOIN Buses bEvening
    ON bEvening.busNumber = rt.eveningBus
CROSS JOIN @dayOffsets d;

-- Add a few high-demand midday trips on weekend dates to make the search page
-- feel fuller for demos on 20/03 and 21/03.
DECLARE @extraTrips TABLE (
    origin NVARCHAR(100),
    destination NVARCHAR(100),
    busNumber NVARCHAR(20),
    tripDate DATE,
    departMinute INT,
    durationMinutes INT,
    price DECIMAL(18,2)
);

INSERT INTO @extraTrips (origin, destination, busNumber, tripDate, departMinute, durationMinutes, price)
VALUES
    (N'Hà Nội', N'Đà Nẵng', N'82B-100.05', '2026-03-20', 720, 900, 465000),
    (N'Đà Nẵng', N'Hà Nội', N'82B-100.05', '2026-03-21', 750, 900, 465000),
    (N'Hồ Chí Minh', N'Đà Lạt', N'82B-100.06', '2026-03-20', 660, 420, 330000),
    (N'Đà Lạt', N'Hồ Chí Minh', N'82B-100.06', '2026-03-21', 690, 420, 330000),
    (N'Đà Nẵng', N'Kon Tum', N'82B-100.01', '2026-03-20', 780, 360, 345000),
    (N'Kon Tum', N'Đà Nẵng', N'82B-100.01', '2026-03-21', 780, 360, 345000),
    (N'Hồ Chí Minh', N'Nha Trang', N'82B-100.03', '2026-03-21', 720, 510, 405000),
    (N'Nha Trang', N'Hồ Chí Minh', N'82B-100.03', '2026-03-21', 780, 510, 405000);

INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
SELECT
    r.routeID,
    b.busID,
    DATEADD(MINUTE, e.departMinute, CAST(e.tripDate AS DATETIME)),
    DATEADD(MINUTE, e.departMinute + e.durationMinutes, CAST(e.tripDate AS DATETIME)),
    e.price,
    N'Scheduled'
FROM @extraTrips e
JOIN Routes r
    ON r.origin = e.origin
   AND r.destination = e.destination
JOIN Buses b
    ON b.busNumber = e.busNumber;
