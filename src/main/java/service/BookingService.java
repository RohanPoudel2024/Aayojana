package service;

import dao.BookingDAO;
import dao.EventsDAO;
import model.Booking;
import model.Event;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    private BookingDAO bookingDAO;
    private EventsDAO eventDAO;
    
    public BookingService() {
        try {
            Connection connection = DBUtils.getConnection();
            this.bookingDAO = new BookingDAO(connection);
            this.eventDAO = new EventsDAO();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public int createBooking(Booking booking) {
        
        if (!validateBooking(booking.getEventId(), booking.getSeatsBooked())) {
            return -1;
        }
        
        
        int bookingId = bookingDAO.createBooking(booking);
        if (bookingId > 0) {
            
            boolean updated = bookingDAO.updateEventSeats(booking.getEventId(), booking.getSeatsBooked());
            if (!updated) {
                
                
                return -1;
            }
        }
        
        return bookingId;
    }
    
    public boolean validateBooking(int eventId, int seatsRequested) {
        if (seatsRequested <= 0) {
            return false;
        }
        
        Event event = null;
        try {
            event = eventDAO.getEventById(eventId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
        
        if (event == null) {
            return false;
        }
        
        return event.getAvailableSeats() >= seatsRequested;
    }
    
    public boolean cancelBooking(int bookingId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            return false;
        }
        
        return bookingDAO.cancelBooking(bookingId, booking.getEventId(), booking.getSeatsBooked());
    }
    
    public List<Booking> getBookingsByUserId(int userId) {
        return bookingDAO.getBookingsByUserId(userId);
    }
    
    public Booking getBookingById(int bookingId) {
        return bookingDAO.getBookingById(bookingId);
    }
    
    public List<Booking> getEventBookings(int eventId) {
        return bookingDAO.getBookingsByEventId(eventId);
    }
}