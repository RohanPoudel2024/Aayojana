package dao;
import org.mindrot.jbcrypt.BCrypt;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {
    public boolean createUser(int userId, String name, String email, String password ) throws SQLException {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        String role = "user";

        String query = "INSERT INTO user (name, email, password, role) VALUES (?,?,?,?)";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1,name);
            stmt.setString(2,email);
            stmt.setString(3,hashedPassword);
            stmt.setString(3,role);

            int rowsAffected = stmt.executeUpdate();
            if(rowsAffected>0){
                System.out.println("User Registered Successfully");
                return true;
            }else {
                System.out.println("Failed in registration");
                return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
