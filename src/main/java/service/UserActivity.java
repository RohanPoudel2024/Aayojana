package service;

import dao.UserActivityDAO;
import model.User;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.SQLException;

public class UserActivity {
    private UserActivityDAO userActivityDAO;
    
    public UserActivity() {
        userActivityDAO = new UserActivityDAO();
    }
    
    public boolean updateUserProfile(User user) {
        return userActivityDAO.updateProfile(user);
    }
    
    public User getUserById(int userId) {
        try {
            return userActivityDAO.getUserById(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public User getUserByEmail(String email) {
        try {
            return userActivityDAO.getUserByEmail(email);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean handleProfileImage(Part filePart, User user) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            try {
                // Read image data from the part
                byte[] imageData = filePart.getInputStream().readAllBytes();
                
                // Set image data in user object
                user.setImageData(imageData);
                
                return true;
            } catch (Exception e) {
                throw new IOException("Failed to process image data: " + e.getMessage(), e);
            }
        }
        return false;
    }
    
    public void logActivity(int userId, String action) {
        try {
            userActivityDAO.logActivity(userId, action);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
