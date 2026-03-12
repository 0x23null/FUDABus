-- Database Schema for Bus Ticket Booking System (SQL Server)
USE master;
GO

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BusTicketDB')
BEGIN
    CREATE DATABASE BusTicketDB;
END
GO

USE BusTicketDB;
GO

-- 1. Users Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE Users (
        userID INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(50) NOT NULL UNIQUE,
        password NVARCHAR(255) NOT NULL, -- Hashed password
        email NVARCHAR(100) NOT NULL UNIQUE,
        fullName NVARCHAR(100),
        phoneNumber NVARCHAR(20),
        role NVARCHAR(20) DEFAULT 'Customer', -- 'Admin', 'Customer'
        googleID NVARCHAR(100) NULL, -- For Google Login
        createdAt DATETIME DEFAULT GETDATE()
    );
END
GO

-- 2. Buses Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Buses]') AND type in (N'U'))
BEGIN
    CREATE TABLE Buses (
        busID INT IDENTITY(1,1) PRIMARY KEY,
        busNumber NVARCHAR(20) NOT NULL UNIQUE,
        seatCapacity INT NOT NULL,
        busType NVARCHAR(50), -- e.g., 'Sleeper', 'Seater', 'Limousine'
        imageURL NVARCHAR(255)
    );
END
GO

-- 3. Routes Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Routes]') AND type in (N'U'))
BEGIN
    CREATE TABLE Routes (
        routeID INT IDENTITY(1,1) PRIMARY KEY,
        origin NVARCHAR(100) NOT NULL,
        destination NVARCHAR(100) NOT NULL,
        distance FLOAT, -- in km
        duration INT, -- in minutes
        description NVARCHAR(MAX)
    );
END
GO

-- 4. Trips Table (Schedule)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Trips]') AND type in (N'U'))
BEGIN
    CREATE TABLE Trips (
        tripID INT IDENTITY(1,1) PRIMARY KEY,
        routeID INT FOREIGN KEY REFERENCES Routes(routeID),
        busID INT FOREIGN KEY REFERENCES Buses(busID),
        departureTime DATETIME NOT NULL,
        arrivalTime DATETIME,
        price DECIMAL(18, 2) NOT NULL,
        status NVARCHAR(20) DEFAULT 'Scheduled' -- 'Scheduled', 'Completed', 'Cancelled'
    );
END
GO

-- 5. Bookings Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookings]') AND type in (N'U'))
BEGIN
    CREATE TABLE Bookings (
        bookingID INT IDENTITY(1,1) PRIMARY KEY,
        tripID INT FOREIGN KEY REFERENCES Trips(tripID),
        userID INT FOREIGN KEY REFERENCES Users(userID),
        bookingDate DATETIME DEFAULT GETDATE(),
        totalPrice DECIMAL(18, 2) NOT NULL,
        status NVARCHAR(20) DEFAULT 'Pending', -- 'Pending', 'Paid', 'Cancelled'
        qrCodeURL NVARCHAR(255) -- Path to generated QR code
    );
END
GO

-- 6. BookingDetails Table (For specific seats)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingDetails]') AND type in (N'U'))
BEGIN
    CREATE TABLE BookingDetails (
        detailID INT IDENTITY(1,1) PRIMARY KEY,
        bookingID INT FOREIGN KEY REFERENCES Bookings(bookingID) ON DELETE CASCADE,
        seatNumber NVARCHAR(10) NOT NULL,
        passengerName NVARCHAR(100), -- Optional: if booking for others
        price DECIMAL(18, 2) -- Price at the time of booking
    );
END
GO

-- 7. Payments Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]') AND type in (N'U'))
BEGIN
    CREATE TABLE Payments (
        paymentID INT IDENTITY(1,1) PRIMARY KEY,
        bookingID INT FOREIGN KEY REFERENCES Bookings(bookingID),
        amount DECIMAL(18, 2) NOT NULL,
        paymentMethod NVARCHAR(50), -- 'VietQR', 'Cash', 'CreditCard'
        transactionID NVARCHAR(100), -- From payment gateway
        paymentDate DATETIME DEFAULT GETDATE(),
        status NVARCHAR(20) DEFAULT 'Pending' -- 'Success', 'Failed'
    );
END
GO

-- Insert Default Admin
IF NOT EXISTS (SELECT * FROM Users WHERE username = 'admin')
BEGIN
    INSERT INTO Users (username, password, email, fullName, role)
    VALUES ('admin', 'admin123', 'admin@bus.com', 'System Admin', 'Admin');
END
GO

-- Insert Sample Route
IF NOT EXISTS (SELECT * FROM Routes WHERE origin = 'Ha Noi' AND destination = 'Da Nang')
BEGIN
    INSERT INTO Routes (origin, destination, distance, duration, description)
    VALUES ('Ha Noi', 'Da Nang', 760, 960, 'Long distance sleeper bus route');
END
GO
