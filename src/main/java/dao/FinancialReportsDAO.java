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
     */
    public Map<String, Double> getMonthlyRevenue() throws SQLException {
        Map<String, Double> monthlyRevenue = new LinkedHashMap<>();
        String sql = "SELECT strftime('%Y-%m', booking_date) AS month, " +
                     "SUM(total_price) AS revenue " +
                     "FROM bookings " +
                     "WHERE status != 'CANCELLED' " +
                     "AND booking_date >= date('now', '-6 months') " +
                     "GROUP BY month " +
                     "ORDER BY month ASC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
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
            
            // Fill in actual revenue data
            while (rs.next()) {
                String month = rs.getString("month");
                double revenue = rs.getDouble("revenue");
                
                // Convert the month format to display format
                LocalDate date = LocalDate.parse(month + "-01");
                String displayMonth = date.format(displayFormatter);
                
                monthlyRevenue.put(displayMonth, revenue);
            }
        }
        
        return monthlyRevenue;
    }
    
    /**
     * Get top 5 events by revenue
     */
    public List<Map<String, Object>> getTopEventsByRevenue() throws SQLException {
        List<Map<String, Object>> topEvents = new ArrayList<>();
        String sql = "SELECT e.id, e.title, e.location, " +
                     "COUNT(b.id) AS bookings_count, " +
                     "SUM(b.seats_booked) AS total_seats, " +
                     "SUM(b.total_price) AS total_revenue " +
                     "FROM events e " +
                     "JOIN bookings b ON e.id = b.event_id " +
                     "WHERE b.status != 'CANCELLED' " +
                     "GROUP BY e.id " +
                     "ORDER BY total_revenue DESC " +
                     "LIMIT 5";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rs.getInt("id"));
                event.put("title", rs.getString("title"));
                event.put("location", rs.getString("location"));
                event.put("bookings_count", rs.getInt("bookings_count"));
                event.put("total_seats", rs.getInt("total_seats"));
                event.put("total_revenue", rs.getDouble("total_revenue"));
                
                topEvents.add(event);
            }
        }
        
        return topEvents;
    }
    
    /**
     * Get revenue breakdown by category
     */
    public Map<String, Double> getRevenueByCategoryChart() throws SQLException {
        Map<String, Double> categoryRevenue = new LinkedHashMap<>();
        String sql = "SELECT c.name, SUM(b.total_price) AS revenue " +
                     "FROM bookings b " +
                     "JOIN events e ON b.event_id = e.id " +
                     "JOIN category c ON e.category_id = c.id " +
                     "WHERE b.status != 'CANCELLED' " +
                     "GROUP BY c.id " +
                     "ORDER BY revenue DESC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                String categoryName = rs.getString("name");
                double revenue = rs.getDouble("revenue");
                categoryRevenue.put(categoryName, revenue);
            }
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
                         "FROM bookings " +
                         "WHERE status != 'CANCELLED'";
        
        // This year revenue
        String yearSql = "SELECT SUM(total_price) AS revenue " +
                         "FROM bookings " +
                         "WHERE status != 'CANCELLED' " +
                         "AND strftime('%Y', booking_date) = strftime('%Y', 'now')";
        
        // This month revenue
        String monthSql = "SELECT SUM(total_price) AS revenue " +
                          "FROM bookings " +
                          "WHERE status != 'CANCELLED' " +
                          "AND strftime('%Y-%m', booking_date) = strftime('%Y-%m', 'now')";
        
        // This week revenue
        String weekSql = "SELECT SUM(total_price) AS revenue " +
                        "FROM bookings " +
                        "WHERE status != 'CANCELLED' " +
                        "AND booking_date >= date('now', 'weekday 0', '-7 days')";
        
        try (Connection conn = DBUtils.getConnection()) {
            // Get total revenue
            try (PreparedStatement stmt = conn.prepareStatement(totalSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenueOverview.put("total", rs.getDouble("revenue"));
                }
            }
            
            // Get this year revenue
            try (PreparedStatement stmt = conn.prepareStatement(yearSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenueOverview.put("year", rs.getDouble("revenue"));
                }
            }
            
            // Get this month revenue
            try (PreparedStatement stmt = conn.prepareStatement(monthSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenueOverview.put("month", rs.getDouble("revenue"));
                }
            }
            
            // Get this week revenue
            try (PreparedStatement stmt = conn.prepareStatement(weekSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenueOverview.put("week", rs.getDouble("revenue"));
                }
            }
        }
        
        return revenueOverview;
    }
    
    /**
     * Get recent transactions
     */
    public List<Map<String, Object>> getRecentTransactions(int limit) throws SQLException {
        List<Map<String, Object>> transactions = new ArrayList<>();
        String sql = "SELECT b.id, b.booking_date, b.total_price, b.seats_booked, " +
                     "b.status, u.name AS user_name, e.title AS event_title " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN events e ON b.event_id = e.id " +
                     "ORDER BY b.booking_date DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> transaction = new HashMap<>();
                    transaction.put("id", rs.getInt("id"));
                    transaction.put("date", rs.getDate("booking_date"));
                    transaction.put("price", rs.getDouble("total_price"));
                    transaction.put("seats", rs.getInt("seats_booked"));
                    transaction.put("status", rs.getString("status"));
                    transaction.put("userName", rs.getString("user_name"));
                    transaction.put("eventTitle", rs.getString("event_title"));
                    
                    transactions.add(transaction);
                }
            }
        }
        
        return transactions;
    }
}
