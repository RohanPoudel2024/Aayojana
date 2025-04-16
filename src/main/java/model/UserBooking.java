package model;
public class UserBooking {
    private int userId;
    private int bookingId;
    private int eventId;

    public UserBooking() {}

    public UserBooking(int userId, int bookingId, int eventId) {
        this.userId = userId;
        this.bookingId = bookingId;
        this.eventId = eventId;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
}