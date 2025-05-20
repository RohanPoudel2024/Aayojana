package utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * Utility class to diagnose database-related issues
 */
public class DiagnosticHelper {
    
    private static final Logger logger = Logger.getLogger(DiagnosticHelper.class.getName());
    
    public static void main(String[] args) {
        runDiagnostics();
    }
    
    /**
     * Checks if the specified table exists in the database schema
     */
    public static boolean tableExists(String tableName) {
        try (Connection conn = DBUtils.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, null, tableName, null);
            boolean exists = tables.next();
            tables.close();
            return exists;
        } catch (SQLException e) {
            logger.severe("Error checking if table exists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Checks the column names and types in a specific table
     */
    public static void printTableStructure(String tableName) {
        try (Connection conn = DBUtils.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, tableName, null);
            
            System.out.println("==== TABLE: " + tableName + " ====");
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                boolean isNullable = columns.getInt("NULLABLE") == DatabaseMetaData.columnNullable;
                
                System.out.println(columnName + " | " + columnType + "(" + columnSize + ")" + 
                                  " | " + (isNullable ? "NULL" : "NOT NULL"));
            }
            System.out.println("====================");
            columns.close();
            
        } catch (SQLException e) {
            logger.severe("Error getting table structure: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Test querying events table
     */
    public static void checkEvents() {
        try (Connection conn = DBUtils.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM events LIMIT 1");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("== FIRST EVENT ==");
                System.out.println("ID: " + rs.getInt("id"));
                System.out.println("Title: " + rs.getString("title"));
                System.out.println("Available Seats: " + rs.getInt("available_seats"));
            } else {
                System.out.println("No events found in database");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            logger.severe("Error checking events table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Test querying bookings table
     */
    public static void checkBookings() {
        try (Connection conn = DBUtils.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM bookings LIMIT 5");
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("== BOOKING " + count + " ==");
                System.out.println("ID: " + rs.getInt("booking_id"));
                System.out.println("User ID: " + rs.getInt("user_id"));
                System.out.println("Event ID: " + rs.getInt("event_id"));
                System.out.println("Seats: " + rs.getInt("seats_booked"));
            }
            if (count == 0) {
                System.out.println("No bookings found in database");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            logger.severe("Error checking bookings table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Run all diagnostic checks
     */
    public static void runDiagnostics() {
        System.out.println("=== RUNNING DATABASE DIAGNOSTICS ===");
        System.out.println("Checking tables...");
        boolean eventsExists = tableExists("events");
        boolean bookingsExists = tableExists("bookings");
        boolean usersExists = tableExists("users");
        
        System.out.println("Events table exists: " + eventsExists);
        System.out.println("Bookings table exists: " + bookingsExists);
        System.out.println("Users table exists: " + usersExists);
        
        if (eventsExists) {
            printTableStructure("events");
            checkEvents();
        }
        
        if (bookingsExists) {
            printTableStructure("bookings");
            checkBookings();
        }
        
        System.out.println("=== DIAGNOSTICS COMPLETE ===");
    }
}
