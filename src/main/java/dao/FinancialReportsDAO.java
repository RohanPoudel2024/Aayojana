package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import utils.DBUtils;
import model.Event;

public class FinancialReportsDAO {
    
    /**
     * Get monthly revenue for the past 6 months
     */    public Map<String, Double> getMonthlyRevenue() throws SQLException {
        Map<String, Double> monthlyRevenue = new LinkedHashMap<>();
        
        // Initialize all months with 0 revenue
        LocalDate today = LocalDate.now();
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("MMM yyyy");
        
        for (int i = 5; i >= 0; i--) {
            LocalDate date = today.minusMonths(i);
            String monthKey = date.format(monthFormatter);
            String displayMonth = date.format(displayFormatter);
            monthlyRevenue.put(displayMonth, 0.0);
        }
          // SQL query for SQLite - we use substr instead of strftime which may not work in all SQLite versions
        String sql = "SELECT substr(booking_date, 1, 7) AS month, " +
                     "SUM(total_price) AS revenue " +
                     "FROM bookings " +
                     "WHERE booking_date >= date('now', '-6 months') " +
                     "GROUP BY month " +
                     "ORDER BY month ASC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            // Fill in actual revenue data
            while (rs.next()) {
                String month = rs.getString("month");
                double revenue = rs.getDouble("revenue");
                
                try {
                    // Convert the month format to display format (try with different formats)
                    LocalDate date;
                    try {
                        // If format is YYYY-MM
                        date = LocalDate.parse(month + "-01");
                    } catch (Exception e) {
                        // If the format is different, e.g., YYYY-MM-DD
                        date = LocalDate.parse(month.substring(0, 7) + "-01");
                    }
                    
                    String displayMonth = date.format(displayFormatter);
                    monthlyRevenue.put(displayMonth, revenue);
                } catch (Exception e) {
                    System.err.println("Failed to parse month: " + month + " - " + e.getMessage());
                    // Use the month string directly if parsing fails
                    monthlyRevenue.put(month, revenue);
                }
            }
        }
        
        return monthlyRevenue;
    }
      /**
     * Get top 5 events by revenue
     */
    public List<Map<String, Object>> getTopEventsByRevenue() throws SQLException {
        List<Map<String, Object>> topEvents = new ArrayList<>();        String sql = "SELECT e.event_id as id, e.title, e.location, " +
                     "COUNT(b.booking_id) AS bookings_count, " +
                     "SUM(b.seats_booked) AS total_seats, " +
                     "SUM(b.total_price) AS total_revenue " +
                     "FROM event e " +
                     "JOIN bookings b ON e.event_id = b.event_id " +
                     "GROUP BY e.id " +
                     "ORDER BY total_revenue DESC " +
                     "LIMIT 5";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rs.getInt("id"));
                
                String title = rs.getString("title");
                event.put("title", title != null ? title : "Unnamed Event");
                
                String location = rs.getString("location");
                event.put("location", location != null ? location : "Unknown Location");
                
                int bookingsCount = rs.getInt("bookings_count");
                event.put("bookings_count", rs.wasNull() ? 0 : bookingsCount);
                
                int totalSeats = rs.getInt("total_seats");
                event.put("total_seats", rs.wasNull() ? 0 : totalSeats);
                
                double totalRevenue = rs.getDouble("total_revenue");
                event.put("total_revenue", rs.wasNull() ? 0.0 : totalRevenue);
                
                topEvents.add(event);
            }
        }
        
        // If no events found, add a placeholder
        if (topEvents.isEmpty()) {
            Map<String, Object> placeholderEvent = new HashMap<>();
            placeholderEvent.put("id", 0);
            placeholderEvent.put("title", "No Events");
            placeholderEvent.put("location", "N/A");
            placeholderEvent.put("bookings_count", 0);
            placeholderEvent.put("total_seats", 0);
            placeholderEvent.put("total_revenue", 0.0);
            topEvents.add(placeholderEvent);
        }
        
        return topEvents;
    }
      /**
     * Get revenue breakdown by category
     */
    public Map<String, Double> getRevenueByCategoryChart() throws SQLException {
        Map<String, Double> categoryRevenue = new LinkedHashMap<>();        String sql = "SELECT c.name, SUM(b.total_price) AS revenue " +
                     "FROM bookings b " +
                     "JOIN event e ON b.event_id = e.event_id " +
                     "JOIN category c ON e.category_id = c.category_id " +
                     "GROUP BY c.id " +
                     "ORDER BY revenue DESC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                String categoryName = rs.getString("name");
                double revenue = rs.getDouble("revenue");
                
                // Handle null values and empty category names
                if (categoryName == null || categoryName.trim().isEmpty()) {
                    categoryName = "Uncategorized";
                }
                
                categoryRevenue.put(categoryName, rs.wasNull() ? 0.0 : revenue);
            }
        }
        
        // If no categories found, add a default one to prevent empty chart
        if (categoryRevenue.isEmpty()) {
            categoryRevenue.put("No Data", 0.0);
        }
        
        return categoryRevenue;
    }
      /**
     * Get revenue data for the current year, month, and week
     */
    public Map<String, Double> getRevenueOverview() throws SQLException {
        Map<String, Double> revenueOverview = new HashMap<>();
          // Total revenue
        String totalSql = "SELECT SUM(total_price) AS revenue " +
                         "FROM bookings";
          // This year revenue - using substr for more compatible SQLite syntax
        String yearSql = "SELECT SUM(total_price) AS revenue " +
                         "FROM bookings " +
                         "WHERE substr(booking_date, 1, 4) = substr(date('now'), 1, 4)";
          // This month revenue - using substr for more compatible SQLite syntax
        String monthSql = "SELECT SUM(total_price) AS revenue " +
                          "FROM bookings " +
                          "WHERE substr(booking_date, 1, 7) = substr(date('now'), 1, 7)";
          // This week revenue
        String weekSql = "SELECT SUM(total_price) AS revenue " +
                        "FROM bookings " +
                        "WHERE booking_date >= date('now', '-7 days')";
        try (Connection conn = DBUtils.getConnection()) {
            // Get total revenue
            try (PreparedStatement stmt = conn.prepareStatement(totalSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double value = rs.getDouble("revenue");
                    revenueOverview.put("total", rs.wasNull() ? 0.0 : value);
                } else {
                    revenueOverview.put("total", 0.0);
                }
            }
            
            // Get this year revenue
            try (PreparedStatement stmt = conn.prepareStatement(yearSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double value = rs.getDouble("revenue");
                    revenueOverview.put("year", rs.wasNull() ? 0.0 : value);
                } else {
                    revenueOverview.put("year", 0.0);
                }
            }
            
            // Get this month revenue
            try (PreparedStatement stmt = conn.prepareStatement(monthSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double value = rs.getDouble("revenue");
                    revenueOverview.put("month", rs.wasNull() ? 0.0 : value);
                } else {
                    revenueOverview.put("month", 0.0);
                }
            }
              // Get this week revenue
            try (PreparedStatement stmt = conn.prepareStatement(weekSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double value = rs.getDouble("revenue");
                    revenueOverview.put("week", rs.wasNull() ? 0.0 : value);
                } else {
                    revenueOverview.put("week", 0.0);
                }
            }
        }
        
        return revenueOverview;
    }
      /**
     * Get recent transactions
     */    public List<Map<String, Object>> getRecentTransactions(int limit) throws SQLException {
        List<Map<String, Object>> transactions = new ArrayList<>();
        String sql = "SELECT b.id, b.booking_date, b.total_price, b.seats_booked, " +
                     "u.name AS user_name, e.title AS event_title " +                     "FROM bookings b " +
                     "JOIN user u ON b.user_id = u.user_id " +
                     "JOIN event e ON b.event_id = e.event_id " +
                     "ORDER BY b.booking_date DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> transaction = new HashMap<>();
                    
                    transaction.put("id", rs.getInt("id"));
                    
                    // Handle dates carefully
                    java.sql.Date bookingDate = rs.getDate("booking_date");
                    transaction.put("date", bookingDate != null ? bookingDate : new java.util.Date());
                    
                    double totalPrice = rs.getDouble("total_price");
                    transaction.put("price", rs.wasNull() ? 0.0 : totalPrice);
                    
                    int seatsBooked = rs.getInt("seats_booked");
                    transaction.put("seats", rs.wasNull() ? 0 : seatsBooked);
                    
                    // Assume all bookings are confirmed since status column doesn't exist
                    transaction.put("status", "CONFIRMED");
                    
                    String userName = rs.getString("user_name");
                    transaction.put("userName", userName != null ? userName : "Unknown User");
                    
                    String eventTitle = rs.getString("event_title");
                    transaction.put("eventTitle", eventTitle != null ? eventTitle : "Unknown Event");
                    
                    transactions.add(transaction);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching recent transactions: " + e.getMessage());
            e.printStackTrace();
            // Return empty list if query fails, to avoid breaking the UI
            return new ArrayList<>();
        }
        
        // If no transactions found, add a placeholder
        if (transactions.isEmpty() && limit > 0) {
            Map<String, Object> placeholderTransaction = new HashMap<>();
            placeholderTransaction.put("id", 0);
            placeholderTransaction.put("date", new java.util.Date());
            placeholderTransaction.put("price", 0.0);
            placeholderTransaction.put("seats", 0);
            placeholderTransaction.put("status", "No Data");
            placeholderTransaction.put("userName", "No transactions");
            placeholderTransaction.put("eventTitle", "No events");
            
            transactions.add(placeholderTransaction);
        }
        
        return transactions;    }
      /**
     * Debugging method to check if we have bookings in the database
     */
    public int getBookingsCount() throws SQLException {
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
    
    /**
     * Check database schema for debugging
     */
    public String checkDatabaseSchema() throws SQLException {
        StringBuilder result = new StringBuilder();
        
        try (Connection conn = DBUtils.getConnection()) {
            // Check if bookings table exists
            try {
                PreparedStatement stmt = conn.prepareStatement("SELECT sql FROM sqlite_master WHERE type='table' AND name='bookings'");
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    String tableSchema = rs.getString(1);
                    result.append("Bookings table exists with schema: ").append(tableSchema);
                } else {
                    result.append("Bookings table does not exist!");
                }
                rs.close();
                stmt.close();
            } catch (Exception e) {
                result.append("Error checking bookings table: ").append(e.getMessage());
            }
            
            // Check column names in bookings table
            try {
                PreparedStatement stmt = conn.prepareStatement("PRAGMA table_info(bookings)");
                ResultSet rs = stmt.executeQuery();
                result.append("\nColumns in bookings table: ");
                int columnCount = 0;
                while (rs.next()) {
                    columnCount++;
                    String columnName = rs.getString("name");
                    String columnType = rs.getString("type");
                    result.append("\n- ").append(columnName).append(" (").append(columnType).append(")");
                }
                if (columnCount == 0) {
                    result.append("No columns found!");
                }
                rs.close();
                stmt.close();
            } catch (Exception e) {
                result.append("\nError checking columns: ").append(e.getMessage());
            }
        } catch (Exception e) {
            result.append("\nError connecting to database: ").append(e.getMessage());
        }
        
        return result.toString();
    }
    
    /**
     * Add sample data to test reports
     */
    public boolean addSampleBookingsData() throws SQLException {
        String checkTableSql = "SELECT name FROM sqlite_master WHERE type='table' AND name='bookings'";        String createTableSql = "CREATE TABLE IF NOT EXISTS bookings (" +
                               "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                               "user_id INTEGER, " +
                               "event_id INTEGER, " +
                               "booking_date TEXT, " +
                               "seats_booked INTEGER, " +
                               "total_price REAL)";
        
        String insertSql = "INSERT INTO bookings (user_id, event_id, booking_date, seats_booked, total_price) VALUES " +
                           "(1, 1, date('now'), 2, 2000.00), " +
                           "(2, 2, date('now', '-1 month'), 1, 1500.00), " +
                           "(1, 3, date('now', '-2 month'), 3, 3000.00), " +
                           "(3, 1, date('now', '-3 day'), 2, 2000.00), " +
                           "(2, 3, date('now', '-10 day'), 1, 1000.00)";
        
        boolean sampleDataAdded = false;
        try (Connection conn = DBUtils.getConnection()) {
            // Check if table exists
            try (PreparedStatement stmt = conn.prepareStatement(checkTableSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                boolean tableExists = rs.next();
                
                // Create table if it doesn't exist
                if (!tableExists) {
                    try (PreparedStatement createStmt = conn.prepareStatement(createTableSql)) {
                        createStmt.executeUpdate();
                    }
                }
            }
            
            // Check if there's already data
            try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM bookings");
                 ResultSet rs = countStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) == 0) {
                    // Insert sample data
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.executeUpdate();
                        sampleDataAdded = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        
        return sampleDataAdded;
    }
}
