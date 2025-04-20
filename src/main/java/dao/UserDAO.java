package dao;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public boolean createUser(User user) throws SQLException {
        String query = "INSERT INTO users (name, email, password, role) VALUES (?,?,?,?)";

        String hashedPassword = hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

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

    //Password Hash Garne method
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public boolean loginUser(String email, String password) {
        String query = "SELECT * FROM users where email = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String stPassword = rs.getString("password");
                String role = rs.getString("role");

                if (BCrypt.checkpw(password, stPassword)) {
                    System.out.println("User Details \n"+ rs.getString("role")+ "\n" + rs.getString("name"));
                    return true;
                } else {
                    System.out.println("Invalid password.");
                    return false;
                }
            } else {
                System.out.println("User with this email does not exist.");
                return false;
            }


        } catch (SQLException e) {
            System.out.println("Error during login: " + e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        String email = "rohan@example.com";
        String password = "rohan123";


        boolean isLoggedIn = dao.loginUser(email, password);
        if (isLoggedIn == true) {
            System.out.println("login successful");
        }

    }
}
