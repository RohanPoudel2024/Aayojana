package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import model.Event;
import service.BookingService;
import service.EventService;
import utils.ActivityLogger;
import dao.UserDAO;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;

@WebServlet("/admin/bookings")
public class AdminBookingsServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminBookingsServlet.class.getName());
    private BookingService bookingService;
    private EventService eventService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        eventService = new EventService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check if user is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all events for reference
        List<Event> events = eventService.getAllEvents();
        request.setAttribute("events", events);

        // Get all users for reference
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
        } catch (Exception e) {
            logger.severe("Error fetching users: " + e.getMessage());
        }

        // Handle any messages in session
        String message = (String) session.getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }

        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        // Forward to the admin bookings page
        request.getRequestDispatcher("/WEB-INF/view/admin/bookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check if user is admin
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if (action == null || bookingIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            if ("cancel".equals(action)) {
                // Get the booking details before canceling for logging
                Booking booking = bookingService.getBookingById(bookingId);
                
                if (bookingService.cancelBooking(bookingId)) {
                    session.setAttribute("message", "Booking cancelled successfully");
                    // Log admin action with event details
                    String activityLog = String.format("Admin cancelled booking #%d (Event: %d, User: %d)", 
                        bookingId, booking.getEventId(), booking.getUserId());
                    ActivityLogger.log(currentUser.getUserId(), activityLog);
                } else {
                    session.setAttribute("errorMessage", "Failed to cancel booking");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID");
        } catch (Exception e) {
            logger.severe("Error processing booking action: " + e.getMessage());
            session.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }
}
