package dao;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {
    public boolean createUser(User user ) throws SQLException {
        String query = "INSERT INTO user (name, email, password, role) VALUES (?,?,?,?)";

        String hashedPassword  = hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

        user.setRole("user");
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1,user.getName());
            stmt.setString(2,user.getEmail());
            stmt.setString(3,user.getPassword());
            stmt.setString(4,user.getRole());

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

    //Password Hash Garne method
    public String hashPassword(String password){
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }
}
