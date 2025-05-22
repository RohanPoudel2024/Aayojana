package service;

import dao.BookingDAO;
import dao.EventsDAO;
import dao.UserDAO;
import model.Booking;
import model.Event;
import model.User;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class BookingService {
    private BookingDAO bookingDAO;
    private EventsDAO eventDAO;
    private UserDAO userDAO;
    private static final Logger logger = Logger.getLogger(BookingService.class.getName());
      public BookingService() {
        try {
            Connection connection = DBUtils.getConnection();
            if (connection == null) {
                logger.severe("Failed to get database connection in BookingService constructor");
                throw new RuntimeException("Database connection is null");
            }
            
            // Test the database connection
            if (!connection.isValid(5)) {
                logger.severe("Database connection is invalid in BookingService constructor");
                throw new RuntimeException("Invalid database connection");
            }
            
            logger.info("BookingService initialized with valid database connection");
            this.bookingDAO = new BookingDAO(connection);
            this.eventDAO = new EventsDAO();
            this.userDAO = new UserDAO();
            
            // Run a simple diagnostic query
            try {
                boolean valid = connection.createStatement().execute("SELECT 1");
                logger.info("Test query execution: " + valid);
            } catch (SQLException e) {
                logger.severe("Test query failed: " + e.getMessage());
            }
        } catch (Exception e) {
            logger.severe("Error in BookingService constructor: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize BookingService", e);
        }
    }

    public int createBooking(Booking booking) {
        if (booking == null) {
            logger.severe("Booking object is null");
            return -1;
        }
        
        logger.info("Creating booking for user ID: " + booking.getUserId() + ", event ID: " + booking.getEventId());
        Connection transactionConnection = null;
        int bookingId = -1;
        
        try {
            // Get a new connection for this transaction
            transactionConnection = DBUtils.getConnection();
            if (transactionConnection == null) {
                logger.severe("Could not obtain database connection");
                return -1;
            }
            
            // Test connection
            if (!transactionConnection.isValid(5)) {
                logger.severe("Database connection is invalid");
                return -1;
            }
            
            transactionConnection.setAutoCommit(false);
            logger.info("Transaction started - autoCommit set to false");
            
            // Check if user exists in database first
            User user = userDAO.getUserById(booking.getUserId());
            if (user == null) {
                logger.severe("User with ID " + booking.getUserId() + " does not exist in the database");
                return -1;
            }
            
            // Check if event exists and has enough seats
            Event event = null;
            try {
                event = eventDAO.getEventById(booking.getEventId());
                if (event == null) {
                    logger.severe("Event with ID " + booking.getEventId() + " does not exist");
                    return -1;
                }
                if (event.getAvailableSeats() < booking.getSeatsBooked()) {
                    logger.severe("Not enough seats available. Requested: " + booking.getSeatsBooked() + ", Available: " + event.getAvailableSeats());
                    return -1;
                }
            } catch (SQLException e) {
                logger.severe("Error checking event details: " + e.getMessage());
                return -1;
            }
            
            // Create temporary DAOs with our transaction connection
            BookingDAO transactionBookingDAO = new BookingDAO(transactionConnection);
            
            // Create the booking
            bookingId = transactionBookingDAO.createBooking(booking);
            logger.info("BookingDAO.createBooking returned: " + bookingId);
            
            // Update seat availability if booking was created successfully
            if (bookingId > 0) {
                boolean updated = transactionBookingDAO.updateEventSeats(booking.getEventId(), booking.getSeatsBooked());
                if (!updated) {
                    logger.severe("Failed to update event seats after creating booking - rolling back transaction");
                    transactionConnection.rollback();
                    return -1;
                } else {
                    logger.info("Successfully updated event seats, committing transaction!");
                    transactionConnection.commit();
                }
            } else {
                logger.severe("Failed to create booking in database");
                transactionConnection.rollback();
                return -1;
            }
            
            return bookingId;
        } catch (SQLException e) {
            logger.severe("Database error during booking creation: " + e.getMessage());
            e.printStackTrace();
            
            try {
                if (transactionConnection != null) {
                    transactionConnection.rollback();
                }
            } catch (SQLException rollbackEx) {
                logger.severe("Error during transaction rollback: " + rollbackEx.getMessage());
                rollbackEx.printStackTrace();
            }
            return -1;
        } finally {
            try {
                if (transactionConnection != null) {
                    transactionConnection.setAutoCommit(true);
                    transactionConnection.close();
                }
            } catch (SQLException e) {
                logger.severe("Error closing transaction connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
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
    
    // Check if a user has booked a specific event
    public Booking getUserBookingForEvent(int userId, int eventId) {
        List<Booking> userBookings = bookingDAO.getBookingsByUserId(userId);
        for (Booking booking : userBookings) {
            if (booking.getEventId() == eventId) {
                return booking;
            }
        }
        return null;
    }
    
    public Booking getBookingById(int bookingId) {
        return bookingDAO.getBookingById(bookingId);
    }
    
    public List<Booking> getEventBookings(int eventId) {
        return bookingDAO.getBookingsByEventId(eventId);
    }

    public List<Booking> getAllBookings() {
        try (Connection conn = DBUtils.getConnection()) {
            BookingDAO bookingDAO = new BookingDAO(conn);
            return bookingDAO.getAllBookings();
        } catch (SQLException e) {
            logger.severe("Error getting all bookings: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}