-- =============================================================
-- SEED DATA cho Bus Ticket Booking System
-- Ngày tạo: 2026-03-13
-- Tất cả trips sử dụng DATEADD() từ GETDATE() để luôn ở tương lai
-- =============================================================

USE BusTicketDB;
GO

-- ===================== 1. ROUTES =====================
-- Xóa data cũ nếu muốn reset (tùy chọn)
-- DELETE FROM BookingDetails; DELETE FROM Bookings; DELETE FROM Trips; DELETE FROM Buses; DELETE FROM Routes WHERE routeID > 0;

-- Route 1: đã có sẵn (Ha Noi - Da Nang), update tên đúng dấu
UPDATE Routes SET origin = N'Hà Nội', destination = N'Đà Nẵng', 
    description = N'Tuyến đường dài Bắc - Trung, xe giường nằm chất lượng cao'
WHERE origin = 'Ha Noi' AND destination = 'Da Nang';

-- Thêm các tuyến mới
IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hồ Chí Minh')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hà Nội', N'Hồ Chí Minh', 1700, 2040, N'Tuyến Bắc - Nam dài nhất, xe giường nằm VIP');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Đà Lạt')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hồ Chí Minh', N'Đà Lạt', 310, 420, N'Tuyến du lịch phổ biến, đường đèo đẹp');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Nha Trang')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hồ Chí Minh', N'Nha Trang', 430, 540, N'Tuyến biển nổi tiếng, xe Limousine');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hải Phòng')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hà Nội', N'Hải Phòng', 120, 150, N'Tuyến ngắn Bắc bộ, xe chất lượng cao');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Vũng Tàu')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hồ Chí Minh', N'Vũng Tàu', 125, 150, N'Tuyến biển gần HCM, phù hợp cuối tuần');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Huế')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Đà Nẵng', N'Huế', 100, 150, N'Tuyến ngắn miền Trung, qua đèo Hải Vân');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Cần Thơ')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hồ Chí Minh', N'Cần Thơ', 170, 240, N'Tuyến miền Tây, xe giường nằm');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hạ Long')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Hà Nội', N'Hạ Long', 160, 210, N'Tuyến du lịch Vịnh Hạ Long');
GO

IF NOT EXISTS (SELECT * FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Nha Trang')
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES (N'Đà Nẵng', N'Nha Trang', 530, 600, N'Tuyến duyên hải miền Trung');
GO

-- ===================== 2. BUSES =====================
IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'51B-123.45')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'51B-123.45', 40, N'Giường nằm');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'51B-678.90')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'51B-678.90', 22, N'Limousine VIP');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'29B-111.22')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'29B-111.22', 45, N'Ghế ngồi');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'29B-333.44')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'29B-333.44', 40, N'Giường nằm');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'43B-555.66')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'43B-555.66', 34, N'Limousine Phòng');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'43B-777.88')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'43B-777.88', 40, N'Giường nằm');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'51B-999.00')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'51B-999.00', 22, N'Limousine VIP');
GO

IF NOT EXISTS (SELECT * FROM Buses WHERE busNumber = N'29B-222.33')
    INSERT INTO Buses (busNumber, seatCapacity, busType) VALUES (N'29B-222.33', 45, N'Ghế ngồi');
GO

-- ===================== 3. TRIPS =====================
-- Sử dụng DATEADD() từ GETDATE() để trips luôn ở tương lai
-- Mỗi trip offset từ ngày hiện tại + N ngày

-- Lấy routeID và busID theo tên để tránh hardcode ID
DECLARE @r_hanoi_danang INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Đà Nẵng');
DECLARE @r_hanoi_hcm INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hồ Chí Minh');
DECLARE @r_hcm_dalat INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Đà Lạt');
DECLARE @r_hcm_nhatrang INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Nha Trang');
DECLARE @r_hanoi_haiphong INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hải Phòng');
DECLARE @r_hcm_vungtau INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Vũng Tàu');
DECLARE @r_danang_hue INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Huế');
DECLARE @r_hcm_cantho INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hồ Chí Minh' AND destination = N'Cần Thơ');
DECLARE @r_hanoi_halong INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Hà Nội' AND destination = N'Hạ Long');
DECLARE @r_danang_nhatrang INT = (SELECT TOP 1 routeID FROM Routes WHERE origin = N'Đà Nẵng' AND destination = N'Nha Trang');

DECLARE @b_giuongnam1 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'51B-123.45');
DECLARE @b_limousine1 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'51B-678.90');
DECLARE @b_ghengoi1 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'29B-111.22');
DECLARE @b_giuongnam2 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'29B-333.44');
DECLARE @b_limousinephong INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'43B-555.66');
DECLARE @b_giuongnam3 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'43B-777.88');
DECLARE @b_limousine2 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'51B-999.00');
DECLARE @b_ghengoi2 INT = (SELECT TOP 1 busID FROM Buses WHERE busNumber = N'29B-222.33');

-- Xóa trips cũ để insert mới (chỉ trips không có booking)
DELETE t FROM Trips t
LEFT JOIN Bookings b ON t.tripID = b.tripID
WHERE b.bookingID IS NULL;

-- =============== HÀ NỘI → ĐÀ NẴNG ===============
-- Ngày mai, 06:00 sáng, giường nằm, 350k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_danang, @b_giuongnam1,
    DATEADD(HOUR, 6, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 22, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    350000, 'Scheduled');

-- Ngày mai, 19:00 tối, Limousine, 550k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_danang, @b_limousine1,
    DATEADD(HOUR, 19, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 11, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    550000, 'Scheduled');

-- +3 ngày, 20:00, giường nằm, 350k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_danang, @b_giuongnam2,
    DATEADD(HOUR, 20, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 12, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
    350000, 'Scheduled');

-- =============== HÀ NỘI → HỒ CHÍ MINH ===============
-- +2 ngày, 17:00, giường nằm, 650k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_hcm, @b_giuongnam1,
    DATEADD(HOUR, 17, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 3, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
    650000, 'Scheduled');

-- +5 ngày, 18:00, Limousine VIP, 950k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_hcm, @b_limousine2,
    DATEADD(HOUR, 18, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 4, CAST(DATEADD(DAY, 7, CAST(GETDATE() AS DATE)) AS DATETIME)),
    950000, 'Scheduled');

-- =============== HCM → ĐÀ LẠT ===============
-- Ngày mai, 07:00, ghế ngồi, 250k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_dalat, @b_ghengoi1,
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 14, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    250000, 'Scheduled');

-- Ngày mai, 22:00, giường nằm, 300k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_dalat, @b_giuongnam3,
    DATEADD(HOUR, 22, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 5, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    300000, 'Scheduled');

-- +4 ngày, 08:00, Limousine, 450k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_dalat, @b_limousinephong,
    DATEADD(HOUR, 8, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 15, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
    450000, 'Scheduled');

-- =============== HCM → NHA TRANG ===============
-- +2 ngày, 21:00, giường nằm, 350k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_nhatrang, @b_giuongnam1,
    DATEADD(HOUR, 21, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 6, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    350000, 'Scheduled');

-- +3 ngày, 07:30, Limousine, 500k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_nhatrang, @b_limousine1,
    DATEADD(MINUTE, 450, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 990, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    500000, 'Scheduled');

-- =============== HÀ NỘI → HẢI PHÒNG ===============
-- Ngày mai, 06:30, ghế ngồi, 120k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_haiphong, @b_ghengoi2,
    DATEADD(MINUTE, 390, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 540, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    120000, 'Scheduled');

-- Ngày mai, 13:00, Limousine, 200k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_haiphong, @b_limousine2,
    DATEADD(HOUR, 13, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 930, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    200000, 'Scheduled');

-- +7 ngày, 08:00, ghế ngồi, 120k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_haiphong, @b_ghengoi1,
    DATEADD(HOUR, 8, CAST(DATEADD(DAY, 7, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 630, CAST(DATEADD(DAY, 7, CAST(GETDATE() AS DATE)) AS DATETIME)),
    120000, 'Scheduled');

-- =============== HCM → VŨNG TÀU ===============
-- Ngày mai, 08:00, ghế ngồi, 100k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_vungtau, @b_ghengoi1,
    DATEADD(HOUR, 8, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 630, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    100000, 'Scheduled');

-- +2 ngày, 07:00, Limousine, 180k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_vungtau, @b_limousine1,
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 570, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    180000, 'Scheduled');

-- +6 ngày, 09:00, ghế ngồi, 100k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_vungtau, @b_ghengoi2,
    DATEADD(HOUR, 9, CAST(DATEADD(DAY, 6, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 690, CAST(DATEADD(DAY, 6, CAST(GETDATE() AS DATE)) AS DATETIME)),
    100000, 'Scheduled');

-- =============== ĐÀ NẴNG → HUẾ ===============
-- Ngày mai, 07:00, ghế ngồi, 90k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_danang_hue, @b_ghengoi2,
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 570, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    90000, 'Scheduled');

-- +2 ngày, 14:00, Limousine Phòng, 250k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_danang_hue, @b_limousinephong,
    DATEADD(HOUR, 14, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 990, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    250000, 'Scheduled');

-- =============== HCM → CẦN THƠ ===============
-- Ngày mai, 06:00, giường nằm, 180k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_cantho, @b_giuongnam2,
    DATEADD(HOUR, 6, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 10, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
    180000, 'Scheduled');

-- +3 ngày, 15:00, Limousine, 280k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_cantho, @b_limousine2,
    DATEADD(HOUR, 15, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 19, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    280000, 'Scheduled');

-- =============== HÀ NỘI → HẠ LONG ===============
-- +2 ngày, 07:00, ghế ngồi, 150k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_halong, @b_ghengoi1,
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 630, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    150000, 'Scheduled');

-- +5 ngày, 06:30, Limousine, 280k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_halong, @b_limousine1,
    DATEADD(MINUTE, 390, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(MINUTE, 600, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
    280000, 'Scheduled');

-- =============== ĐÀ NẴNG → NHA TRANG ===============
-- +2 ngày, 18:00, giường nằm, 380k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_danang_nhatrang, @b_giuongnam3,
    DATEADD(HOUR, 18, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 4, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
    380000, 'Scheduled');

-- +4 ngày, 20:00, Limousine Phòng, 580k
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_danang_nhatrang, @b_limousinephong,
    DATEADD(HOUR, 20, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 6, CAST(DATEADD(DAY, 5, CAST(GETDATE() AS DATE)) AS DATETIME)),
    580000, 'Scheduled');

-- =============== THÊM CÁC CHUYẾN TUẦN SAU ===============
-- HCM → Đà Lạt, +10 ngày
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_dalat, @b_limousine1,
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 10, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 14, CAST(DATEADD(DAY, 10, CAST(GETDATE() AS DATE)) AS DATETIME)),
    450000, 'Scheduled');

-- Hà Nội → Đà Nẵng, +14 ngày
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hanoi_danang, @b_limousinephong,
    DATEADD(HOUR, 19, CAST(DATEADD(DAY, 14, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 11, CAST(DATEADD(DAY, 15, CAST(GETDATE() AS DATE)) AS DATETIME)),
    600000, 'Scheduled');

-- HCM → Nha Trang, +20 ngày
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_nhatrang, @b_limousine2,
    DATEADD(HOUR, 22, CAST(DATEADD(DAY, 20, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 7, CAST(DATEADD(DAY, 21, CAST(GETDATE() AS DATE)) AS DATETIME)),
    500000, 'Scheduled');

-- HCM → Cần Thơ, +25 ngày
INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status)
VALUES (@r_hcm_cantho, @b_ghengoi2,
    DATEADD(HOUR, 8, CAST(DATEADD(DAY, 25, CAST(GETDATE() AS DATE)) AS DATETIME)),
    DATEADD(HOUR, 12, CAST(DATEADD(DAY, 25, CAST(GETDATE() AS DATE)) AS DATETIME)),
    150000, 'Scheduled');

PRINT N'✅ Seed data đã được thêm thành công!';
PRINT N'📊 Tổng: 10 routes, 8 buses, ~30 trips (tất cả trong tương lai)';
GO
