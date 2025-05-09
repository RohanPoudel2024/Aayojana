package dao;

import model.Booking;
import model.Event;
import model.UserBooking;

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
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getEventId());
            stmt.setDate(3, booking.getBookingDate());
            stmt.setInt(4, booking.getSeatsBooked());
            stmt.setDouble(5, booking.getTotalPrice());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateEventSeats(int eventId, int seatsBooked) {
        String sql = "UPDATE events SET available_seats = available_seats - ? WHERE event_id = ? AND available_seats >= ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, seatsBooked);
            stmt.setInt(2, eventId);
            stmt.setInt(3, seatsBooked);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelBooking(int bookingId, int eventId, int seatsBooked) {
        // Start transaction
        try {
            connection.setAutoCommit(false);
            
            // Delete booking
            String deleteSql = "DELETE FROM bookings WHERE booking_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(deleteSql)) {
                stmt.setInt(1, bookingId);
                int rowsDeleted = stmt.executeUpdate();
                
                if (rowsDeleted == 0) {
                    connection.rollback();
                    return false;
                }
            }
            
            // Update event seats
            String updateSql = "UPDATE events SET available_seats = available_seats + ? WHERE event_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(updateSql)) {
                stmt.setInt(1, seatsBooked);
                stmt.setInt(2, eventId);
                stmt.executeUpdate();
            }
            
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
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setEventId(rs.getInt("event_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setSeatsBooked(rs.getInt("seats_booked"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setEventId(rs.getInt("event_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setSeatsBooked(rs.getInt("seats_booked"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public List<Booking> getBookingsByEventId(int eventId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE event_id = ? ORDER BY booking_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setEventId(rs.getInt("event_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setSeatsBooked(rs.getInt("seats_booked"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }
}