package dao;

import model.User;
import utils.DBUtils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserActivityDAO {
    
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, phone = ?, photo = ? WHERE id = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhone());
            
            if (user.getImageData() != null) {
                statement.setBytes(4, user.getImageData());
            } else {
                statement.setNull(4, java.sql.Types.BLOB);
            }
            
            statement.setInt(5, user.getUserId());
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("User ID: " + user.getUserId());
            System.out.println("Name: " + user.getName());
            
            int rowsUpdated = statement.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    User user = new User();
                    user.setUserId(resultSet.getInt("id"));
                    user.setName(resultSet.getString("name"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPassword(resultSet.getString("password"));
                    user.setRole(resultSet.getString("role"));
                    user.setPhone(resultSet.getString("phone"));
                    
                    byte[] imageData = resultSet.getBytes("photo");
                    user.setImageData(imageData);
                    
                    return user;
                }
            }
        }
        
        return null;
    }
    
    public boolean saveImageAsBlob(int userId, InputStream imageStream) {
        String sql = "UPDATE users SET photo = ? WHERE id = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            byte[] imageData = imageStream.readAllBytes();
            
            statement.setBytes(1, imageData);
            statement.setInt(2, userId);
            
            int rowsUpdated = statement.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (Exception e) {
            System.err.println("Error saving image as BLOB: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = new User();
                user.setUserId(resultSet.getInt("id"));
                user.setName(resultSet.getString("name"));
                user.setEmail(resultSet.getString("email"));
                user.setPassword(resultSet.getString("password"));
                user.setRole(resultSet.getString("role"));
                user.setPhone(resultSet.getString("phone"));
                
                return user;
            }
        } finally {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        
        return null;
    }
}
