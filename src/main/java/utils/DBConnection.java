package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String username;
    private static String password;
    private static String driver;
    
    // Load database properties once at class initialization
    static {
        try {
            Properties props = new Properties();
            InputStream inputStream = DBConnection.class.getClassLoader()
                                     .getResourceAsStream("db.properties");
            
            if (inputStream == null) {
                System.err.println("db.properties not found in classpath");
                throw new RuntimeException("db.properties not found");
            }
            
            props.load(inputStream);
            
            driver = props.getProperty("db.driver");
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
            
            // Load the database driver
            Class.forName(driver);
            
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            throw new RuntimeException("Database driver not found", e);
        } catch (IOException e) {
            System.err.println("Error reading database properties: " + e.getMessage());
            throw new RuntimeException("Error reading database properties", e);
        }
    }
    
    // Get a fresh connection each time this method is called
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}