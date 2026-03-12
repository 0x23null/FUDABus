package model;

public class Bus {
    private int busID;
    private String busNumber;
    private int seatCapacity;
    private String busType;
    private String imageURL;

    public Bus() {
    }

    public Bus(int busID, String busNumber, int seatCapacity, String busType, String imageURL) {
        this.busID = busID;
        this.busNumber = busNumber;
        this.seatCapacity = seatCapacity;
        this.busType = busType;
        this.imageURL = imageURL;
    }

    public int getBusID() {
        return busID;
    }

    public void setBusID(int busID) {
        this.busID = busID;
    }

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public int getSeatCapacity() {
        return seatCapacity;
    }

    public void setSeatCapacity(int seatCapacity) {
        this.seatCapacity = seatCapacity;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }
}
