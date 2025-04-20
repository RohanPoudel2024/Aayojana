package utils;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {
    private static String URL ;
    private static String USER;
    private static String PASSWORD;

    public static Connection getConnection()throws SQLException {
        return DriverManager.getConnection(URL,USER,PASSWORD);
    }
}
