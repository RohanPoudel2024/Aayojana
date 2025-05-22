package dao;

import model.Event;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventsDAO {
    
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY date DESC";
        
        try (Connection conn = DBUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Event event = extractEventFromResultSet(rs);
                events.add(event);
            }
        }
        
        return events;
    }
    public Event getEventById(int eventId) throws SQLException {
        String sql = "SELECT * FROM events WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractEventFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    public boolean createEvent(Event event) throws SQLException {
        String sql = "INSERT INTO events (title, location, date, time, available_seats, price, category_id, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, event.getTitle());
            pstmt.setString(2, event.getLocation());
            pstmt.setDate(3, event.getDate());
            pstmt.setString(4, event.getTime());
            pstmt.setInt(5, event.getAvailableSeats());
            pstmt.setDouble(6, event.getPrice());
            pstmt.setInt(7, event.getCategoryId());
            
            // Handle image data
            if (event.getImageData() != null) {
                pstmt.setBytes(8, event.getImageData());
            } else {
                pstmt.setNull(8, java.sql.Types.BLOB);
            }
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        event.setEventId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
      public boolean updateEvent(Event event) throws SQLException {
        String sql = "UPDATE events SET title = ?, location = ?, date = ?, time = ?, available_seats = ?, price = ?, category_id = ?, image = ? WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, event.getTitle());
            pstmt.setString(2, event.getLocation());
            pstmt.setDate(3, event.getDate());
            pstmt.setString(4, event.getTime());
            pstmt.setInt(5, event.getAvailableSeats());
            pstmt.setDouble(6, event.getPrice());
            pstmt.setInt(7, event.getCategoryId());
            
            // Handle image data - check if we're updating the image
            if (event.getImageData() != null) {
                pstmt.setBytes(8, event.getImageData());
            } else {
                // Get the existing image data if we're not updating it
                Event existingEvent = getEventById(event.getEventId());
                if (existingEvent != null && existingEvent.getImageData() != null) {
                    pstmt.setBytes(8, existingEvent.getImageData());
                } else {
                    pstmt.setNull(8, java.sql.Types.BLOB);
                }
            }
            
            pstmt.setInt(9, event.getEventId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
      public boolean deleteEvent(int eventId) throws SQLException {
        String sql = "DELETE FROM events WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    private Event extractEventFromResultSet(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventId(rs.getInt("id")); // Changed from event_id to id
        event.setTitle(rs.getString("title"));
        event.setLocation(rs.getString("location"));
        event.setDate(rs.getDate("date"));
        event.setTime(rs.getString("time"));
        event.setAvailableSeats(rs.getInt("available_seats"));
        event.setPrice(rs.getDouble("price"));
        event.setCategoryId(rs.getInt("category_id"));
        
        // Extract image data
        byte[] imageData = rs.getBytes("image");
        event.setImageData(imageData);
        
        return event;
    }
    
    public List<Event> searchEvents(String keyword) throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE title LIKE ? OR location LIKE ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Event event = extractEventFromResultSet(rs);
                    events.add(event);
                }
            }
        }
        
        return events;
    }

    public int countTotalEvents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM events";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
}
