package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Event;
import model.User;
import service.BookingService;
import service.EventService;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/booking")
public class BookingsServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(BookingsServlet.class.getName());
    private BookingService bookingService;
    private EventService eventService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        eventService = new EventService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("BookingsServlet doGet called with URI: " + request.getRequestURI() + " and QueryString: " + request.getQueryString());
        String action = request.getParameter("action");
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        
        if (action == null) {
            // Show booking form
            showBookingForm(request, response);
        } else if (action.equals("confirm")) {
            // Show booking confirmation
            showBookingConfirmation(request, response);
        } else if (action.equals("list")) {
            // Show user's bookings
            listUserBookings(request, response, currentUser.getUserId());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null || currentUser.getUserId() <= 0) {
            logger.severe("Invalid user in session. User: " + (currentUser == null ? "null" : "ID=" + currentUser.getUserId()));
            session.invalidate(); // Clear invalid session
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String eventIdStr = request.getParameter("eventId");
        String seatsStr = request.getParameter("seats");
        
        // Log all request parameters for debugging
        logger.info("Request parameters: eventId=" + eventIdStr + ", seats=" + seatsStr);
        
        if (eventIdStr == null || seatsStr == null) {
            logger.severe("Missing required parameters: eventId or seats");
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            // Print detailed user information for debugging
            logger.info("User info from session - ID: " + currentUser.getUserId() + 
                       ", Name: " + currentUser.getName() + 
                       ", Email: " + currentUser.getEmail());
            
            // Create booking object
            Booking booking = new Booking();
            booking.setUserId(currentUser.getUserId());
            booking.setEventId(eventId);
            booking.setBookingDate(Date.valueOf(LocalDate.now()));
            booking.setSeatsBooked(seats);
            
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                logger.severe("Event not found with ID: " + eventId);
                request.setAttribute("errorMessage", "Event not found.");
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
                return;
            }

            // Log event details
            logger.info("Event details - Title: " + event.getTitle() + 
                       ", Available seats: " + event.getAvailableSeats() + 
                       ", Price: " + event.getPrice());
            
            booking.setTotalPrice(event.getPrice() * seats);
            
            // Process booking
            logger.info("Attempting to create booking: EventID=" + eventId + 
                       ", UserID=" + currentUser.getUserId() + 
                       ", Seats=" + seats + 
                       ", Total Price=" + booking.getTotalPrice());
                       
            int bookingId = bookingService.createBooking(booking);
            
            if (bookingId > 0) {
                // Booking successful
                logger.info("Booking successful with ID: " + bookingId);
                session.setAttribute("message", "Booking successful! Your booking ID is " + bookingId);
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
            } else {
                // Booking failed
                logger.severe("Booking creation failed with bookingId: " + bookingId);
                request.setAttribute("errorMessage", "Booking failed. Please ensure sufficient seats are available and try again.");
                request.setAttribute("event", event);
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format in parameters: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        } catch (Exception e) {
            logger.severe("Unexpected error during booking: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
        }
    }
    
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventService.getEventById(eventId);
            
            if (event == null || event.getAvailableSeats() <= 0) {
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            request.setAttribute("event", event);
            request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
    
    private void showBookingConfirmation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String seatsStr = request.getParameter("seats");
        
        if (eventIdStr == null || seatsStr == null) {
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            if (seats <= 0 || seats > event.getAvailableSeats()) {
                request.setAttribute("errorMessage", "Invalid number of seats requested.");
                request.setAttribute("event", event);
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
                return;
            }
            
            double totalPrice = event.getPrice() * seats;
            
            request.setAttribute("event", event);
            request.setAttribute("seats", seats);
            request.setAttribute("totalPrice", totalPrice);
            request.getRequestDispatcher("/WEB-INF/view/bookings/confirm.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        logger.info("Creating booking with user ID: " + userId);
        String eventIdStr = request.getParameter("eventId");
        String seatsStr = request.getParameter("seats");
        
        // Enhanced debug logging
        logger.info("POST Parameters: eventId=" + eventIdStr + ", seats=" + seatsStr);
        
        if (eventIdStr == null || seatsStr == null) {
            logger.severe("Missing required parameters: eventId or seats");
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            // Verify user ID in session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            
            if (currentUser == null || currentUser.getUserId() <= 0) {
                // Handle case where user is not logged in properly
                session.setAttribute("errorMessage", "Please log in again to complete your booking.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Print detailed user information for debugging
            logger.info("User info from session - ID: " + currentUser.getUserId() + ", Name: " + currentUser.getName() + ", Email: " + currentUser.getEmail());
            
            // Create booking object
            Booking booking = new Booking();
            booking.setUserId(currentUser.getUserId());
            booking.setEventId(eventId);
            booking.setBookingDate(Date.valueOf(LocalDate.now()));
            booking.setSeatsBooked(seats);
            
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                request.setAttribute("errorMessage", "Event not found.");
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
                return;
            }
            
            booking.setTotalPrice(event.getPrice() * seats);
            
            // Process booking
            logger.info("Attempting to create booking: EventID=" + eventId + ", UserID=" + currentUser.getUserId() + ", Seats=" + seats);
            int bookingId = bookingService.createBooking(booking);
            
            if (bookingId > 0) {
                // Booking successful
                session.setAttribute("message", "Booking successful! Your booking ID is " + bookingId);
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
            } else {
                // Booking failed - show error on the form instead of redirecting
                request.setAttribute("errorMessage", "Booking failed. Please ensure you are logged in and try again.");
                request.setAttribute("event", event);
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Error processing booking: " + e.getMessage());
            e.printStackTrace();
            
            // IMPORTANT: Don't redirect to EventsServlet; show an error to the user instead
            HttpSession session = request.getSession();
            Event event = null;
            try {
                int eventId = Integer.parseInt(eventIdStr);
                event = eventService.getEventById(eventId);
            } catch (Exception ex) {
                // Ignore if we can't get the event at this point
            }
            
            request.setAttribute("errorMessage", "Error creating booking: " + e.getMessage());
            request.setAttribute("event", event);
            
            // Forward back to the form instead of redirecting
            request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
        }
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Get booking to verify ownership
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null || booking.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Cancel booking
            boolean success = bookingService.cancelBooking(bookingId);
            
            if (success) {
                request.setAttribute("message", "Booking cancelled successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel booking.");
            }
            
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        }
    }
    
    private void listUserBookings(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        // Double-check that we have a valid user ID
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            List<Booking> bookings = bookingService.getBookingsByUserId(userId);
            request.setAttribute("bookings", bookings);
            
            // Pass any message from the session to the request
            HttpSession session = request.getSession();
            String message = (String) session.getAttribute("message");
            if (message != null) {
                request.setAttribute("message", message);
                // Don't remove it here - we'll remove it in the JSP after displaying
            }
            
            request.getRequestDispatcher("/WEB-INF/view/bookings/list.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Error loading bookings: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
}
