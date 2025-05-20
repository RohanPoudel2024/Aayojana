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
        String sql = "INSERT INTO bookings (user_id, event_id, booking_date, seats_booked, total_price) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, booking.getUserId());
            statement.setInt(2, booking.getEventId());
            statement.setDate(3, booking.getBookingDate());
            statement.setInt(4, booking.getSeatsBooked());
            statement.setDouble(5, booking.getTotalPrice());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                return -1;
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateEventSeats(int eventId, int seatsBooked) {
        String sql = "UPDATE events SET available_seats = available_seats - ? WHERE event_id = ? AND available_seats >= ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seatsBooked);
            statement.setInt(2, eventId);
            statement.setInt(3, seatsBooked);
            
            int rowsUpdated = statement.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelBooking(int bookingId, int eventId, int seatsBooked) {
        // First update the available seats in the event
        String updateEventSql = "UPDATE events SET available_seats = available_seats + ? WHERE event_id = ?";
        
        // Then mark the booking as cancelled
        String cancelBookingSql = "DELETE FROM bookings WHERE booking_id = ?";
        
        try {
            // Start transaction
            connection.setAutoCommit(false);
            
            // Update event seats
            try (PreparedStatement eventStmt = connection.prepareStatement(updateEventSql)) {
                eventStmt.setInt(1, seatsBooked);
                eventStmt.setInt(2, eventId);
                eventStmt.executeUpdate();
            }
            
            // Cancel booking
            try (PreparedStatement bookingStmt = connection.prepareStatement(cancelBookingSql)) {
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
        String sql = "SELECT * FROM bookings WHERE user_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    bookings.add(mapBooking(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, bookingId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapBooking(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public List<Booking> getBookingsByEventId(int eventId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE event_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, eventId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    bookings.add(mapBooking(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    private Booking mapBooking(ResultSet resultSet) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(resultSet.getInt("booking_id"));
        booking.setUserId(resultSet.getInt("user_id"));
        booking.setEventId(resultSet.getInt("event_id"));
        booking.setBookingDate(resultSet.getDate("booking_date"));
        booking.setSeatsBooked(resultSet.getInt("seats_booked"));
        booking.setTotalPrice(resultSet.getDouble("total_price"));
        return booking;
    }
}