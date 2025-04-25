package dao;

import model.User;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserActivityDAO {
    public boolean updateProfile(User user) {
        String query = "UPDATE users SET name=?, email=?, phone=?, photo=? WHERE id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getPhoto());
            stmt.setInt(5, user.getUserId());
            return stmt.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public User getUserById(int userId) throws SQLException {
        String query = "SELECT * FROM users WHERE id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPhoto(rs.getString("photo"));
                return user;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
