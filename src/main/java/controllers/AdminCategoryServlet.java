package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.User;
import service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private CategoryService categoryService;
    
    @Override
    public void init() {
        categoryService = new CategoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            
            listCategories(request, response);
        } else {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                case "toggle":
                    toggleCategoryStatus(request, response);
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        switch (action) {
            case "create":
                createCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/view/admin/categories.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/view/admin/categoryForm.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryService.getCategoryById(categoryId);
        
        if (category == null) {
            
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        request.setAttribute("category", category);
        request.getRequestDispatcher("/WEB-INF/view/admin/categoryForm.jsp").forward(request, response);
    }
    
    private void createCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isActive = "on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive"));
        
        
        boolean success = categoryService.createCategory(name, description, isActive);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Category created successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to create category.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isActive = "on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive"));
        
        
        boolean success = categoryService.updateCategory(categoryId, name, description, isActive);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Category updated successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update category.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = categoryService.deleteCategory(categoryId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Category deleted successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to delete category. It may be in use by events.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
    
    private void toggleCategoryStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = categoryService.toggleCategoryStatus(categoryId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Category status updated successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update category status.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}