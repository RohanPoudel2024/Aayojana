package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.AuthService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");
        
        logger.info("Login attempt for email: " + email);
        
        try {
            User user = AuthService.validateLogin(email, password);
            if (user != null && user.getUserId() > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                logger.info("User logged in successfully. UserID: " + user.getUserId() + ", Name: " + user.getName());
                
                // Check if there's a redirect URL specified
                if (redirect != null && !redirect.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/" + redirect);
                } else {
                    // Check if we have a stored redirect URL in the session
                    String storedRedirect = (String) session.getAttribute("redirectAfterLogin");
                    if (storedRedirect != null && !storedRedirect.isEmpty()) {
                        session.removeAttribute("redirectAfterLogin");
                        response.sendRedirect(storedRedirect);
                    } else {
                        // Default redirects based on role
                        if ("admin".equals(user.getRole())) {
                            response.sendRedirect(request.getContextPath() + "/Dashboard");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/EventsServlet");
                        }
                    }
                }
            } else {
                logger.warning("Login failed for email: " + email + " (user null or invalid ID)");
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            logger.severe("Database error during login: " + e.getMessage());
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        
        // Save any redirect parameter to the session
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isEmpty()) {
            if (session == null) {
                session = request.getSession();
            }
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/" + redirect);
        }
        
        if (user != null) {
            // User is already logged in
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/Dashboard");
            } else {
                // Check if there's a redirect URL in the session
                String storedRedirect = (String) session.getAttribute("redirectAfterLogin");
                if (storedRedirect != null && !storedRedirect.isEmpty()) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(storedRedirect);
                } else {
                    response.sendRedirect(request.getContextPath() + "/EventsServlet");
                }
            }
        } else {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

}

