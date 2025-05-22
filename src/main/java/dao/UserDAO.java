package dao;
import model.User;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

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
        String query = "SELECT * FROM users WHERE email = ?";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("id")); // Make sure this matches your column name
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    
                    logger.info("Found user with ID: " + user.getUserId() + " for email: " + email);
                    return user;
                }
            }
            logger.warning("No user found for email: " + email);
            return null;
        } catch (SQLException e) {
            logger.severe("Database error validating user: " + e.getMessage());
            throw e;
        }
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

    public List<User> getAllUsers() throws SQLException {
        String query = "SELECT * FROM users ORDER BY id";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                
                users.add(user);
            }
        }
        
        return users;
    }

    public boolean createUserByAdmin(User user) throws SQLException {
        String query = "INSERT INTO users (name, email, password, role, phone) VALUES (?,?,?,?,?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getPhone());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            if (e.getErrorCode() == 1062) {
                System.out.println("Email already exists: " + user.getEmail());
            }
            throw e;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String query = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting user: " + e.getMessage());
            throw e;
        }
    }    
    
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
                    return user;
                }
            }
        }
        return null;
    }
      public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, role = ?, phone = ? WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getPhone());
            pstmt.setInt(5, user.getUserId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            throw e;
        }
    }
    
    public boolean updateUserWithPassword(User user) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, role = ?, phone = ?, password = ? WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getPassword());
            pstmt.setInt(6, user.getUserId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user with password: " + e.getMessage());
            throw e;
        }
    }
    
    public int countTotalUsers() throws SQLException {
        String query = "SELECT COUNT(*) FROM users";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
}
