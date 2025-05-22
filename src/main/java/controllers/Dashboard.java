package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import model.DashboardActivity;
import dao.UserDAO;
import dao.EventsDAO;
import dao.DashboardDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet("/Dashboard")
public class Dashboard extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Check if user is logged in and is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Initialize DAOs
            UserDAO userDAO = new UserDAO();
            EventsDAO eventsDAO = new EventsDAO();
            DashboardDAO dashboardDAO = new DashboardDAO();
            
            // Get statistics
            int totalUsers = userDAO.countTotalUsers();
            int totalEvents = eventsDAO.countTotalEvents();
            int totalBookings = dashboardDAO.countTotalBookings();
            double totalRevenue = dashboardDAO.calculateTotalRevenue();
            int totalCategories = dashboardDAO.countTotalCategories();
            
            // Get recent activities
            List<DashboardActivity> recentActivities = dashboardDAO.getRecentActivities();
            
            // Format the revenue
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
            String formattedRevenue = currencyFormatter.format(totalRevenue).replace("NPR", "NPR. ");
            
            // Set attributes for the JSP
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", formattedRevenue);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("recentActivities", recentActivities);
            
            // Forward to the dashboard view
            request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            // Log the error
            getServletContext().log("Database error in Dashboard servlet", e);
            
            // Set error message and forward to error page
            request.setAttribute("errorMessage", "A database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
}
