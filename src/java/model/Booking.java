package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Booking {
    private int bookingID;
    private int tripID;
    private int userID;
    private Timestamp bookingDate;
    private double totalPrice;
    private String ticketCode;
    private String status;
    private String tripType;
    private int adultCount;
    private int childCount;
    private String qrCodeURL;

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    // Navigation properties for easy access in JSP
    private Trip trip;
    private User user;
    private java.util.List<String> bookedSeats;
    private List<BookingSegment> segments = new ArrayList<>();
    private List<BookingPassenger> passengers = new ArrayList<>();

    public java.util.List<String> getBookedSeats() {
        return bookedSeats;
    }

    public void setBookedSeats(java.util.List<String> bookedSeats) {
        this.bookedSeats = bookedSeats;
    }

    public Booking() {
    }

    public Booking(int bookingID, int tripID, int userID, Timestamp bookingDate, double totalPrice, String status) {
        this.bookingID = bookingID;
        this.tripID = tripID;
        this.userID = userID;
        this.bookingDate = bookingDate;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getTripID() {
        return tripID;
    }

    public void setTripID(int tripID) {
        this.tripID = tripID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTripType() {
        return tripType;
    }

    public void setTripType(String tripType) {
        this.tripType = tripType;
    }

    public int getAdultCount() {
        return adultCount;
    }

    public void setAdultCount(int adultCount) {
        this.adultCount = adultCount;
    }

    public int getChildCount() {
        return childCount;
    }

    public void setChildCount(int childCount) {
        this.childCount = childCount;
    }

    public String getQrCodeURL() {
        return qrCodeURL;
    }

    public void setQrCodeURL(String qrCodeURL) {
        this.qrCodeURL = qrCodeURL;
    }

    public Trip getTrip() {
        return trip;
    }

    public void setTrip(Trip trip) {
        this.trip = trip;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<BookingSegment> getSegments() {
        return segments;
    }

    public void setSegments(List<BookingSegment> segments) {
        this.segments = segments;
    }

    public List<BookingPassenger> getPassengers() {
        return passengers;
    }

    public void setPassengers(List<BookingPassenger> passengers) {
        this.passengers = passengers;
    }

    public int getTotalPassengerCount() {
        return adultCount + childCount;
    }

    public BookingSegment getOutboundSegment() {
        return getSegmentByType("OUTBOUND");
    }

    public BookingSegment getReturnSegment() {
        return getSegmentByType("RETURN");
    }

    private BookingSegment getSegmentByType(String type) {
        if (segments == null) {
            return null;
        }
        for (BookingSegment segment : segments) {
            if (segment != null && type.equalsIgnoreCase(segment.getSegmentType())) {
                return segment;
            }
        }
        return null;
    }
}
