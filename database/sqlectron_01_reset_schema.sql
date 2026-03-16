-- Sqlectron-safe reset script for SQL Server / AWS RDS.
-- Connect directly to your target database (for example: BusTicketDB) before running.

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF OBJECT_ID(N'dbo.Payments', N'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID(N'dbo.BookingSegmentSeats', N'U') IS NOT NULL DROP TABLE dbo.BookingSegmentSeats;
IF OBJECT_ID(N'dbo.BookingPassengers', N'U') IS NOT NULL DROP TABLE dbo.BookingPassengers;
IF OBJECT_ID(N'dbo.BookingSegments', N'U') IS NOT NULL DROP TABLE dbo.BookingSegments;
IF OBJECT_ID(N'dbo.BookingDetails', N'U') IS NOT NULL DROP TABLE dbo.BookingDetails;
IF OBJECT_ID(N'dbo.Bookings', N'U') IS NOT NULL DROP TABLE dbo.Bookings;
IF OBJECT_ID(N'dbo.Trips', N'U') IS NOT NULL DROP TABLE dbo.Trips;
IF OBJECT_ID(N'dbo.Buses', N'U') IS NOT NULL DROP TABLE dbo.Buses;
IF OBJECT_ID(N'dbo.Routes', N'U') IS NOT NULL DROP TABLE dbo.Routes;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE Users (
    userID INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    fullName NVARCHAR(100),
    phoneNumber NVARCHAR(20),
    role NVARCHAR(20) DEFAULT 'Customer',
    googleID NVARCHAR(100) NULL,
    createdAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Buses (
    busID INT IDENTITY(1,1) PRIMARY KEY,
    busNumber NVARCHAR(20) NOT NULL UNIQUE,
    seatCapacity INT NOT NULL,
    busType NVARCHAR(50),
    imageURL NVARCHAR(255)
);

CREATE TABLE Routes (
    routeID INT IDENTITY(1,1) PRIMARY KEY,
    origin NVARCHAR(100) NOT NULL,
    destination NVARCHAR(100) NOT NULL,
    distance FLOAT,
    duration INT,
    description NVARCHAR(MAX)
);

CREATE TABLE Trips (
    tripID INT IDENTITY(1,1) PRIMARY KEY,
    routeID INT NOT NULL FOREIGN KEY REFERENCES Routes(routeID),
    busID INT NOT NULL FOREIGN KEY REFERENCES Buses(busID),
    departureTime DATETIME NOT NULL,
    arrivalTime DATETIME,
    price DECIMAL(18,2) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Scheduled'
);

CREATE TABLE Bookings (
    bookingID INT IDENTITY(1,1) PRIMARY KEY,
    tripID INT NULL FOREIGN KEY REFERENCES Trips(tripID),
    userID INT NOT NULL FOREIGN KEY REFERENCES Users(userID),
    bookingDate DATETIME DEFAULT GETDATE(),
    totalPrice DECIMAL(18,2) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Pending',
    qrCodeURL NVARCHAR(255),
    ticketCode NVARCHAR(50) UNIQUE,
    tripType NVARCHAR(20) DEFAULT 'OneWay',
    adultCount INT DEFAULT 1,
    childCount INT DEFAULT 0
);

CREATE TABLE BookingSegments (
    segmentID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(bookingID) ON DELETE CASCADE,
    tripID INT NOT NULL FOREIGN KEY REFERENCES Trips(tripID),
    segmentType NVARCHAR(20) NOT NULL,
    segmentOrder INT NOT NULL,
    segmentPrice DECIMAL(18,2) NOT NULL
);

CREATE TABLE BookingPassengers (
    passengerID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(bookingID) ON DELETE CASCADE,
    passengerType NVARCHAR(20) NOT NULL,
    displayLabel NVARCHAR(100)
);

CREATE TABLE BookingSegmentSeats (
    bookingSegmentSeatID INT IDENTITY(1,1) PRIMARY KEY,
    segmentID INT NOT NULL FOREIGN KEY REFERENCES BookingSegments(segmentID) ON DELETE CASCADE,
    passengerID INT NULL FOREIGN KEY REFERENCES BookingPassengers(passengerID),
    seatNumber NVARCHAR(10) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

CREATE INDEX IX_BookingSegments_BookingID ON BookingSegments(bookingID);
CREATE INDEX IX_BookingSegments_TripID ON BookingSegments(tripID);
CREATE INDEX IX_BookingSegmentSeats_SegmentID ON BookingSegmentSeats(segmentID);
CREATE INDEX IX_BookingSegmentSeats_SeatNumber ON BookingSegmentSeats(seatNumber);
CREATE INDEX IX_BookingPassengers_BookingID ON BookingPassengers(bookingID);
CREATE UNIQUE INDEX UX_BookingSegmentSeats_Segment_Seat ON BookingSegmentSeats(segmentID, seatNumber);

CREATE TABLE Payments (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(bookingID),
    amount DECIMAL(18,2) NOT NULL,
    paymentMethod NVARCHAR(50),
    transactionID NVARCHAR(100),
    paymentDate DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'Pending'
);
