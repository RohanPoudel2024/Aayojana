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
import java.util.ArrayList;
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
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteUser(request, response);
            } else if (action.equals("new")) {
                showNewUserForm(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }      private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Get query parameters for filtering
        String searchQuery = request.getParameter("query");
        String roleFilter = request.getParameter("role");
        
        // Pagination parameters
        int page = 1;
        int recordsPerPage = 10;
        String pageParam = request.getParameter("page");
        
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page parameter, use default
                page = 1;
            }
        }
        
        // Get all users from database
        List<User> allUsers = userDAO.getAllUsers();
        List<User> filteredUsers = new ArrayList<>();
        
        // Apply filters if they exist
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.toLowerCase();
            for (User user : allUsers) {
                if (user.getName().toLowerCase().contains(query) || 
                    user.getEmail().toLowerCase().contains(query)) {
                    filteredUsers.add(user);
                }
            }
        } else {
            filteredUsers.addAll(allUsers);
        }
        
        // Apply role filter if it exists
        if (roleFilter != null && !roleFilter.isEmpty() && !roleFilter.equals("all")) {
            List<User> roleFilteredUsers = new ArrayList<>();
            for (User user : filteredUsers) {
                if (user.getRole().equalsIgnoreCase(roleFilter)) {
                    roleFilteredUsers.add(user);
                }
            }
            filteredUsers = roleFilteredUsers;
        }
        
        // Calculate pagination
        int totalRecords = filteredUsers.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Adjust page if needed
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // Get subset of users for the current page
        int startIndex = (page - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);
        
        List<User> paginatedUsers = new ArrayList<>();
        if (startIndex < totalRecords) {
            paginatedUsers = filteredUsers.subList(startIndex, endIndex);
        }
        
        // Set as request attributes
        request.setAttribute("userList", paginatedUsers);
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("filteredCount", filteredUsers.size());
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        
        // Forward to users list view
        request.getRequestDispatcher("/WEB-INF/view/admin/users.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                // User not found, redirect to user list
                request.getSession().setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Set user as request attribute
            request.setAttribute("user", user);
            
            // Forward to edit form
            request.getRequestDispatcher("/WEB-INF/view/admin/editUser.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }    private void showNewUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to create user form
        request.getRequestDispatcher("/WEB-INF/view/admin/newUser.jsp").forward(request, response);
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        
        if (userIdParam == null || userIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Prevent admin from deleting themselves
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser.getUserId() == userId) {
                session.setAttribute("errorMessage", "You cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Delete user from database
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                session.setAttribute("message", "User deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete user");
            }
            
            // Redirect back to user list
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Check if user is logged in and is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the action parameter
        String action = request.getParameter("action");
        
        if ("updateUser".equals(action)) {
            try {
                // Get form parameters
                String userIdParam = request.getParameter("userId");
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                // Validate required fields
                if (userIdParam == null || name == null || email == null || role == null) {
                    session.setAttribute("errorMessage", "All required fields must be filled");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
                
                int userId = Integer.parseInt(userIdParam);
                
                // Get the existing user
                User user = userDAO.getUserById(userId);
                if (user == null) {
                    session.setAttribute("errorMessage", "User not found");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
                
                // Check if password is being updated
                boolean passwordUpdate = newPassword != null && !newPassword.isEmpty();
                
                // Validate password if updating
                if (passwordUpdate) {
                    // Check if passwords match
                    if (!newPassword.equals(confirmPassword)) {
                        session.setAttribute("errorMessage", "Passwords do not match");
                        response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
                        return;
                    }
                    
                    // Check password length
                    if (newPassword.length() < 6) {
                        session.setAttribute("errorMessage", "Password must be at least 6 characters long");
                        response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
                        return;
                    }
                }
                
                // Update user object
                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setRole(role);
                
                // Update password if needed
                boolean success;
                if (passwordUpdate) {
                    user.setPassword(newPassword);
                    success = userDAO.updateUserWithPassword(user);
                } else {
                    success = userDAO.updateUser(user);
                }
                
                if (success) {
                    session.setAttribute("message", "User updated successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to update user");
                }
                
                // Redirect back to user list
                response.sendRedirect(request.getContextPath() + "/admin/users");
                
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid user ID");
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } catch (SQLException e) {
                session.setAttribute("errorMessage", "Database error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } else if ("createUser".equals(action)) {
            try {
                // Get form parameters
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                
                // Validate required fields
                if (name == null || email == null || password == null || role == null) {
                    session.setAttribute("errorMessage", "All required fields must be filled");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
                    return;
                }
                
                // Validate password match
                if (!password.equals(confirmPassword)) {
                    session.setAttribute("errorMessage", "Passwords do not match");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
                    return;
                }
                
                // Validate password length
                if (password.length() < 6) {
                    session.setAttribute("errorMessage", "Password must be at least 6 characters long");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
                    return;
                }
                
                // Check if email already exists
                if (userDAO.emailExists(email)) {
                    session.setAttribute("errorMessage", "Email already exists");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
                    return;
                }
                
                // Create new user object
                User newUser = new User();
                newUser.setName(name);
                newUser.setEmail(email);
                newUser.setPassword(password);
                newUser.setRole(role);
                newUser.setPhone(phone);
                
                // Add user to database
                boolean success = userDAO.createUserByAdmin(newUser);
                
                if (success) {
                    session.setAttribute("message", "User created successfully");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                } else {
                    session.setAttribute("errorMessage", "Failed to create user");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
                }
                
            } catch (SQLException e) {
                session.setAttribute("errorMessage", "Database error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/users?action=new");
            }
        } else {
            // Unrecognized action, redirect to user list
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}