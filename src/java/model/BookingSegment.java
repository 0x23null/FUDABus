package model;

import java.util.ArrayList;
import java.util.List;

public class BookingSegment {
    private int segmentID;
    private int bookingID;
    private int tripID;
    private String segmentType;
    private int segmentOrder;
    private double segmentPrice;
    private Trip trip;
    private List<String> seatNumbers = new ArrayList<>();

    public int getSegmentID() {
        return segmentID;
    }

    public void setSegmentID(int segmentID) {
        this.segmentID = segmentID;
    }

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

    public String getSegmentType() {
        return segmentType;
    }

    public void setSegmentType(String segmentType) {
        this.segmentType = segmentType;
    }

    public int getSegmentOrder() {
        return segmentOrder;
    }

    public void setSegmentOrder(int segmentOrder) {
        this.segmentOrder = segmentOrder;
    }

    public double getSegmentPrice() {
        return segmentPrice;
    }

    public void setSegmentPrice(double segmentPrice) {
        this.segmentPrice = segmentPrice;
    }

    public Trip getTrip() {
        return trip;
    }

    public void setTrip(Trip trip) {
        this.trip = trip;
    }

    public List<String> getSeatNumbers() {
        return seatNumbers;
    }

    public void setSeatNumbers(List<String> seatNumbers) {
        this.seatNumbers = seatNumbers;
    }

    public String getDisplayType() {
        return "RETURN".equalsIgnoreCase(segmentType) ? "Chuyến về" : "Chuyến đi";
    }
}
