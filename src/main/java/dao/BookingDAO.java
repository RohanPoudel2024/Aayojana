package dao;

import model.Booking;
import model.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    private Connection connection;

    public BookingDAO(Connection connection) {
        this.connection = connection;
    }      
    
    public int createBooking(Booking booking) {
        if (connection == null) {
            System.out.println("Error: No active database connection");
            return -1;
        }
        
        try {
            if (!connection.isValid(5)) {
                System.out.println("Error: Database connection is invalid");
                return -1;
            }
        } catch (SQLException e) {
            System.out.println("Error checking connection validity: " + e.getMessage());
            return -1;
        }        String sql = "INSERT INTO bookings (user_id, event_id, booking_date, seats_booked, total_price, status) VALUES (?, ?, ?, ?, ?, ?)";
        System.out.println("SQL: " + sql);
        System.out.println("Values: user_id=" + booking.getUserId() + 
                          ", event_id=" + booking.getEventId() + 
                          ", booking_date=" + booking.getBookingDate() + 
                          ", seats=" + booking.getSeatsBooked() + 
                          ", price=" + booking.getTotalPrice() +
                          ", status=" + (booking.getStatus() != null ? booking.getStatus() : "CONFIRMED"));
        
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, booking.getUserId());
            statement.setInt(2, booking.getEventId());
            statement.setDate(3, booking.getBookingDate());
            statement.setInt(4, booking.getSeatsBooked());
            statement.setDouble(5, booking.getTotalPrice());
            statement.setString(6, booking.getStatus() != null ? booking.getStatus() : "CONFIRMED");
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                System.out.println("Creating booking failed, no rows affected.");
                return -1;
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int id = generatedKeys.getInt(1);
                    System.out.println("Booking created with ID: " + id);
                    return id;
                } else {
                    System.out.println("Creating booking failed, no ID obtained.");
                    return -1;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }    
    
    public boolean updateEventSeats(int eventId, int seatsBooked) {
        String sql = "UPDATE events SET available_seats = available_seats - ? WHERE id = ? AND available_seats >= ?";
        System.out.println("Updating event seats: eventId=" + eventId + ", seatsBooked=" + seatsBooked);
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seatsBooked);
            statement.setInt(2, eventId);
            statement.setInt(3, seatsBooked);
            
            int rowsUpdated = statement.executeUpdate();
            boolean success = rowsUpdated > 0;
            System.out.println("Update succeeded: " + success + " (rows affected: " + rowsUpdated + ")");
            return success;
        } catch (SQLException e) {
            System.out.println("Error updating event seats: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }    public boolean cancelBooking(int bookingId, int eventId, int seatsBooked) {        
        // First update the available seats in the event
        String updateEventSql = "UPDATE events SET available_seats = available_seats + ? WHERE id = ?";
        
        // Update booking status to "cancelled" instead of deleting
        String updateBookingSql = "UPDATE bookings SET status = 'CANCELLED' WHERE id = ?";
        
        try {
            // Start transaction
            connection.setAutoCommit(false);
            
            // Update event seats
            try (PreparedStatement eventStmt = connection.prepareStatement(updateEventSql)) {
                eventStmt.setInt(1, seatsBooked);
                eventStmt.setInt(2, eventId);
                eventStmt.executeUpdate();
            }
            
            // Update booking status
            try (PreparedStatement bookingStmt = connection.prepareStatement(updateBookingSql)) {
                bookingStmt.setInt(1, bookingId);
                bookingStmt.executeUpdate();
            }
            
            // Commit transaction
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }    
    
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ? ORDER BY booking_date DESC";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    bookings.add(mapBooking(resultSet));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting bookings for user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, bookingId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapBooking(resultSet);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            // If first query fails, try with alternative column name
            try {
                String alternateSql = "SELECT * FROM bookings WHERE booking_id = ?";
                PreparedStatement statement = connection.prepareStatement(alternateSql);
                statement.setInt(1, bookingId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    return mapBooking(resultSet);
                }
                resultSet.close();
                statement.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        
        return null;
    }
    
    public List<Booking> getBookingsByEventId(int eventId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE event_id = ?";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, eventId);
            
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                bookings.add(mapBooking(resultSet));
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC";
        
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            
            while (resultSet.next()) {
                bookings.add(mapBooking(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all bookings: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }    private Booking mapBooking(ResultSet resultSet) throws SQLException {
        Booking booking = new Booking();
        try {
            booking.setBookingId(resultSet.getInt("booking_id"));
        } catch (SQLException e) {
            // Try alternative column name
            booking.setBookingId(resultSet.getInt("id"));
        }
        booking.setUserId(resultSet.getInt("user_id"));
        booking.setEventId(resultSet.getInt("event_id"));
        booking.setBookingDate(resultSet.getDate("booking_date"));
        booking.setSeatsBooked(resultSet.getInt("seats_booked"));
        booking.setTotalPrice(resultSet.getDouble("total_price"));
        
        // Set status if it exists
        try {
            String status = resultSet.getString("status");
            booking.setStatus(status != null ? status : "CONFIRMED"); // Default to CONFIRMED if null
        } catch (SQLException e) {
            // Status column might not exist in older schema
            booking.setStatus("CONFIRMED"); // Default status
        }
        
        return booking;
    }
}