package utils;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtils {
    private static String URL ;
    private static String USER;
    private static String PASSWORD;

    static{
        try(InputStream is = DBUtils.class.getClassLoader().getResourceAsStream("db.properties")){
            Properties prop = new Properties();
            prop.load(is);
            Class.forName(prop.getProperty("db.driver"));
            URL = prop.getProperty("db.url");
            USER = prop.getProperty("db.username");
            PASSWORD = prop.getProperty("db.password");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    public static Connection getConnection()throws SQLException {
        return DriverManager.getConnection(URL,USER,PASSWORD);
    }


}
