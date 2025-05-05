package dao;

import model.Category;
import utils.DBUtils;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY name";
        
        try (Connection conn = DBUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                categories.add(category);
            }
        }
        
        return categories;
    }
    
    public List<Category> getActiveCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM category WHERE is_active = TRUE ORDER BY name";
        
        try (Connection conn = DBUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                categories.add(category);
            }
        }
        
        return categories;
    }
    
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT * FROM category WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractCategoryFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    public boolean createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO category (name, description, created_at, updated_at, is_active) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            LocalDateTime now = LocalDateTime.now();
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setTimestamp(3, Timestamp.valueOf(now));
            pstmt.setTimestamp(4, Timestamp.valueOf(now));
            pstmt.setBoolean(5, category.isActive());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setCategoryId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE category SET name = ?, description = ?, updated_at = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            LocalDateTime now = LocalDateTime.now();
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setTimestamp(3, Timestamp.valueOf(now));
            pstmt.setBoolean(4, category.isActive());
            pstmt.setInt(5, category.getCategoryId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    public boolean deleteCategory(int categoryId) throws SQLException {
        // First check if category is used in any events
        String checkSql = "SELECT COUNT(*) FROM events WHERE category_id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setInt(1, categoryId);
            
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Category is in use, cannot delete
                    return false;
                }
            }
            
            // Category is not in use, safe to delete
            String deleteSql = "DELETE FROM category WHERE id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, categoryId);
                int affectedRows = deleteStmt.executeUpdate();
                return affectedRows > 0;
            }
        }
    }
    
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        
        // Handle timestamps
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            category.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            category.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        category.setActive(rs.getBoolean("is_active"));
        
        return category;
    }
}