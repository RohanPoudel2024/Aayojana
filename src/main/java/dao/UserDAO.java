package dao;
import model.User;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public boolean createUser(User user) throws SQLException {
        String query = "INSERT INTO users (name, email, password, role) VALUES (?,?,?,?)";

        user.setRole("user");
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User Registered Successfully");
                return true;
            } else {
                System.out.println("Failed in registration");
                return false;
            }
        } catch (SQLException e) {
            System.out.println(e.getErrorCode());
            if (e.getErrorCode() == 1062) {
                System.out.println("Email Already Exist" + "\n" + user.getEmail());
            }
            return false;
        }

    }


    public User validateUser(String email) throws SQLException {
        String query = "SELECT * FROM users WHERE email =?";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1,email);

            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                    User user = new User();
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));

                    return user;
            }
        }catch (SQLException e){
            System.out.println("Error during authUser: " + e.getMessage());
        }
        return null;
    }
    public boolean emailExists(String email) throws SQLException {
        String query = "SELECT email FROM users WHERE email = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

}
