package service;

import dao.CategoryDAO;
import model.Category;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO;
    
    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }
    
    public List<Category> getAllCategories() {
        try {
            return categoryDAO.getAllCategories();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of(); // Return empty list on error
        }
    }
    
    public List<Category> getActiveCategories() {
        try {
            // Filter to only return active categories
            return categoryDAO.getAllCategories().stream()
                .filter(Category::isActive)
                .toList();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    public Category getCategoryById(int categoryId) {
        try {
            return categoryDAO.getCategoryById(categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean createCategory(String name, String description, boolean isActive) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        
        try {
            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            category.setCreatedAt(LocalDateTime.now());
            category.setUpdatedAt(LocalDateTime.now());
            category.setActive(isActive);
            
            return categoryDAO.createCategory(category);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateCategory(int categoryId, String name, String description, boolean isActive) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        
        try {
            Category category = categoryDAO.getCategoryById(categoryId);
            if (category == null) {
                return false;
            }
            
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            category.setUpdatedAt(LocalDateTime.now());
            category.setActive(isActive);
            
            return categoryDAO.updateCategory(category);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteCategory(int categoryId) {
        try {
            return categoryDAO.deleteCategory(categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean toggleCategoryStatus(int categoryId) {
        try {
            Category category = categoryDAO.getCategoryById(categoryId);
            if (category == null) {
                return false;
            }
            
            category.setActive(!category.isActive());
            category.setUpdatedAt(LocalDateTime.now());
            
            return categoryDAO.updateCategory(category);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}