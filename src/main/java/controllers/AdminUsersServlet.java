package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private UserDAO userDAO;
    
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Check if user is logged in and is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get action parameter (for future CRUD operations)
            String action = request.getParameter("action");
            
            // Default action is to list all users
            if (action == null) {
                listUsers(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Get all users from database
        List<User> userList = userDAO.getAllUsers();
        
        // Set as request attribute
        request.setAttribute("userList", userList);
        
        // Forward to users list view
        request.getRequestDispatcher("/WEB-INF/view/admin/users.jsp").forward(request, response);
    }
}