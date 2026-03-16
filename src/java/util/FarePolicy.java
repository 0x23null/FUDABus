package util;

public final class FarePolicy {

    public static final double CHILD_FARE_RATE = 0.7d;

    private FarePolicy() {
    }

    public static double calculateSegmentTotal(double baseFare, int adultCount, int childCount) {
        return (adultCount * baseFare) + (childCount * baseFare * CHILD_FARE_RATE);
    }

    public static double calculateSeatPrice(double baseFare, boolean childPassenger) {
        return childPassenger ? baseFare * CHILD_FARE_RATE : baseFare;
    }
}
