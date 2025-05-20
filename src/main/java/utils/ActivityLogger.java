package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Logger;

public class ActivityLogger {
    private static final Logger logger = Logger.getLogger(ActivityLogger.class.getName());
    
    public static void log(int userId, String action) {
        String sql = "INSERT INTO user_activity (user_id, action, timestamp) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, action);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            
            stmt.executeUpdate();
            logger.info("Logged activity for user " + userId + ": " + action);
            
        } catch (SQLException e) {
            logger.severe("Error logging user activity: " + e.getMessage());
            // Don't throw - logging failure shouldn't break the main functionality
        }
    }
}
