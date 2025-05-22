package dao;

import model.DashboardActivity;
import utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {
      public int countTotalBookings() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
      public double calculateTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_price) FROM bookings";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        
        return 0.0;
    }
    
    public int countTotalCategories() throws SQLException {
        String sql = "SELECT COUNT(*) FROM category WHERE is_active = TRUE";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
      public List<DashboardActivity> getRecentActivities() throws SQLException {
        List<DashboardActivity> activities = new ArrayList<>();        
        String bookingsSql = 
            "SELECT 'booking' as type, b.booking_id as id, u.name as user_name, e.title as event_title, " +
            "b.booking_date, b.seats_booked " +
            "FROM bookings b " +
            "JOIN user u ON b.user_id = u.user_id " +
            "JOIN event e ON b.event_id = e.event_id " +
            "ORDER BY b.booking_date DESC LIMIT 3";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(bookingsSql);
             ResultSet rs = stmt.executeQuery()) {
              while (rs.next()) {
                String type = rs.getString("type");
                int id = rs.getInt("id");
                String userName = rs.getString("user_name");
                String eventTitle = rs.getString("event_title");
                int seatsBooked = rs.getInt("seats_booked");
                
                
                java.sql.Date bookingDate = rs.getDate("booking_date");
                Timestamp createdAt = bookingDate != null ? 
                    new Timestamp(bookingDate.getTime()) : 
                    new Timestamp(System.currentTimeMillis());
                
                String title = "New booking";
                String description = userName + " booked " + seatsBooked + 
                                     " ticket" + (seatsBooked > 1 ? "s" : "") + 
                                     " for " + eventTitle;
                
                activities.add(new DashboardActivity(type, id, title, description, createdAt));
            }
        }        
        String usersSql = 
            "SELECT 'user' as type, user_id as id, name, email " +
            "FROM user " +
            "ORDER BY user_id DESC LIMIT 3";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(usersSql);
             ResultSet rs = stmt.executeQuery()) {
              while (rs.next()) {
                String type = rs.getString("type");
                int id = rs.getInt("id");
                String name = rs.getString("name");
                
                
                Timestamp createdAt = new Timestamp(System.currentTimeMillis());
                
                String title = "New user registered";
                String description = name + " joined the platform";
                
                activities.add(new DashboardActivity(type, id, title, description, createdAt));
            }
        }        
        String eventsSql = 
            "SELECT 'event' as type, event_id as id, title, location " +
            "FROM event " +
            "ORDER BY event_id DESC LIMIT 2";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(eventsSql);
             ResultSet rs = stmt.executeQuery()) {
              while (rs.next()) {
                String type = rs.getString("type");
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String location = rs.getString("location");
                
                
                Timestamp createdAt = new Timestamp(System.currentTimeMillis());
                
                String activityTitle = "New event created";
                String description = title + " at " + location;
                
                activities.add(new DashboardActivity(type, id, activityTitle, description, createdAt));
            }
        }
        
        
        if (activities.size() < 5) {
            Timestamp yesterday = Timestamp.valueOf(LocalDateTime.now().minusDays(1));
            activities.add(new DashboardActivity("system", 0, "System update", 
                          "System maintenance completed successfully", yesterday));
        }
        
        
        activities.sort((a1, a2) -> a2.getTimestamp().compareTo(a1.getTimestamp()));
        
        
        return activities.size() > 5 ? activities.subList(0, 5) : activities;
    }
}
