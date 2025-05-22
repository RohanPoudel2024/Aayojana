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
import java.time.Year;
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
    }    @Override
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
        } else if (action.equals("view")) {
            // Show booking details
            viewBookingDetails(request, response, currentUser.getUserId());
        } else if (action.equals("download-ticket")) {
            // Download booking ticket
            downloadTicket(request, response, currentUser.getUserId());
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

        // Check if this is a booking cancellation
        String action = request.getParameter("action");
        if (action != null && action.equals("cancel")) {
            // This is a cancellation request
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Booking booking = bookingService.getBookingById(bookingId);
                    
                    // Check if booking exists and belongs to the current user
                    if (booking != null && booking.getUserId() == currentUser.getUserId()) {
                        boolean cancelled = bookingService.cancelBooking(bookingId);
                        if (cancelled) {
                            session.setAttribute("message", "Your booking has been cancelled successfully.");
                        } else {
                            session.setAttribute("errorMessage", "Failed to cancel booking. Please try again.");
                        }
                    } else {
                        session.setAttribute("errorMessage", "You don't have permission to cancel this booking.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Invalid booking ID.");
                }
                
                // Redirect to the appropriate page
                String redirectUrl = request.getParameter("returnUrl");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    response.sendRedirect(redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/booking?action=list");
                }
                return;
            }
        }

        // This is a normal booking creation
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
            booking.setStatus("CONFIRMED"); // Set initial status
            
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
            booking.setStatus("CONFIRMED"); // Set initial status
            
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
      
    private void viewBookingDetails(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.getBookingById(bookingId);
            
            // Check if booking exists and belongs to current user
            if (booking == null || booking.getUserId() != userId) {
                request.setAttribute("errorMessage", "Booking not found or you don't have permission to view it.");
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Get event details for this booking
            Event event = eventService.getEventById(booking.getEventId());
            if (event == null) {
                request.setAttribute("errorMessage", "Event details not found for this booking.");
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Set attributes for the view
            request.setAttribute("booking", booking);
            request.setAttribute("event", event);
            
            // Forward to details page
            request.getRequestDispatcher("/WEB-INF/view/bookings/details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            logger.severe("Invalid booking ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        } catch (Exception e) {
            logger.severe("Error viewing booking details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        }
    }
    
    private void downloadTicket(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.getBookingById(bookingId);
            
            // Check if booking exists and belongs to current user
            if (booking == null || booking.getUserId() != userId) {
                request.setAttribute("errorMessage", "Booking not found or you don't have permission to download this ticket.");
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Get event details for this booking
            Event event = eventService.getEventById(booking.getEventId());
            if (event == null) {
                request.setAttribute("errorMessage", "Event details not found for this booking.");
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Set response headers for file download
            response.setContentType("text/html");
            response.setHeader("Content-Disposition", "attachment; filename=ticket_" + bookingId + ".html");
              // Create ticket HTML content
            StringBuilder ticketHtml = new StringBuilder();
            ticketHtml.append("<!DOCTYPE html>");
            ticketHtml.append("<html>");
            ticketHtml.append("<head>");
            ticketHtml.append("<title>Event Ticket #").append(bookingId).append("</title>");
            ticketHtml.append("<style>");
            ticketHtml.append("* { box-sizing: border-box; margin: 0; padding: 0; }");
            ticketHtml.append("body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 40px; }");
            ticketHtml.append(".ticket { max-width: 800px; margin: 0 auto; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15); background-color: #fff; }");
            ticketHtml.append(".ticket-header { background: linear-gradient(135deg, #6200ee, #9e47ff); color: white; padding: 30px; text-align: center; position: relative; }");
            ticketHtml.append(".ticket-header h1 { margin-bottom: 5px; font-size: 28px; }");
            ticketHtml.append(".ticket-header h2 { font-weight: 500; opacity: 0.9; font-size: 18px; }");
            ticketHtml.append(".ticket-body { padding: 30px; }");
            ticketHtml.append(".ticket-event-title { font-size: 24px; font-weight: 700; margin-bottom: 15px; color: #333; }");
            ticketHtml.append(".ticket-event-description { color: #666; margin-bottom: 25px; line-height: 1.6; }");
            ticketHtml.append(".ticket-details { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }");
            ticketHtml.append(".ticket-detail-item { border-radius: 8px; padding: 15px; background-color: #f9f9f9; }");
            ticketHtml.append(".ticket-detail-label { font-size: 12px; text-transform: uppercase; color: #888; margin-bottom: 5px; }");
            ticketHtml.append(".ticket-detail-value { font-weight: 600; font-size: 16px; color: #333; }");
            ticketHtml.append(".ticket-qr { margin: 20px auto; width: 150px; height: 150px; background-color: #f1f1f1; border: 1px dashed #ccc; display: flex; align-items: center; justify-content: center; font-size: 12px; color: #666; text-align: center; }");
            ticketHtml.append(".ticket-footer { border-top: 1px solid #eee; padding: 20px 30px; text-align: center; background-color: #f9f9f9; font-size: 14px; color: #666; }");
            ticketHtml.append(".ticket-validation { font-size: 12px; color: #888; margin-top: 10px; }");
            ticketHtml.append(".ticket-status { position: absolute; top: 20px; right: 20px; padding: 6px 12px; border-radius: 30px; font-size: 12px; font-weight: 600; text-transform: uppercase; background-color: rgba(0, 200, 83, 0.2); color: #00c853; }");
            ticketHtml.append("@media print { body { padding: 0; } .ticket { box-shadow: none; } }");
            ticketHtml.append("</style>");
            ticketHtml.append("</head>");
            ticketHtml.append("<body>");
            ticketHtml.append("<div class='ticket'>");
            
            // Ticket header
            ticketHtml.append("<div class='ticket-header'>");
            ticketHtml.append("<h1>Event Ticket</h1>");
            ticketHtml.append("<h2>AayoJana</h2>");
            ticketHtml.append("<div class='ticket-status'>CONFIRMED</div>");
            ticketHtml.append("</div>");
            
            // Ticket body
            ticketHtml.append("<div class='ticket-body'>");
            ticketHtml.append("<div class='ticket-event-title'>").append(event.getTitle()).append("</div>");
            ticketHtml.append("<div class='ticket-event-description'>").append(event.getDescription()).append("</div>");
            
            ticketHtml.append("<div class='ticket-details'>");
            
            // Date
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>DATE</div>");
            ticketHtml.append("<div class='ticket-detail-value'>").append(new java.text.SimpleDateFormat("dd MMM yyyy").format(event.getDate())).append("</div>");
            ticketHtml.append("</div>");
            
            // Time
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>TIME</div>");
            ticketHtml.append("<div class='ticket-detail-value'>").append(event.getTime()).append("</div>");
            ticketHtml.append("</div>");
            
            // Venue
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>VENUE</div>");
            ticketHtml.append("<div class='ticket-detail-value'>").append(event.getLocation()).append("</div>");
            ticketHtml.append("</div>");
            
            // Booking ID
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>BOOKING ID</div>");
            ticketHtml.append("<div class='ticket-detail-value'>#").append(booking.getBookingId()).append("</div>");
            ticketHtml.append("</div>");
            
            // Seats
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>SEATS</div>");
            ticketHtml.append("<div class='ticket-detail-value'>").append(booking.getSeatsBooked()).append("</div>");
            ticketHtml.append("</div>");
            
            // Price
            ticketHtml.append("<div class='ticket-detail-item'>");
            ticketHtml.append("<div class='ticket-detail-label'>TOTAL PRICE</div>");
            ticketHtml.append("<div class='ticket-detail-value'>NPR ").append(new java.text.DecimalFormat("#,##0.00").format(booking.getTotalPrice())).append("</div>");
            ticketHtml.append("</div>");
            
            ticketHtml.append("</div>"); // End ticket details
            
            // QR Code
            ticketHtml.append("<div class='ticket-qr'>QR Code Placeholder</div>");
            
            ticketHtml.append("</div>"); // End ticket body
            
            // Ticket footer
            ticketHtml.append("<div class='ticket-footer'>");
            ticketHtml.append("<p>Please present this ticket at the venue. This ticket serves as proof of purchase.</p>");
            ticketHtml.append("<div class='ticket-validation'>Booking Date: ").append(new java.text.SimpleDateFormat("dd MMM yyyy").format(booking.getBookingDate())).append("</div>");
            ticketHtml.append("<div class='ticket-validation'>&copy; ").append(Year.now()).append(" AayoJana. All rights reserved.</div>");
            ticketHtml.append("</div>");
            
            ticketHtml.append("</div>"); // End ticket
            
            // Print script
            ticketHtml.append("<script>");
            ticketHtml.append("window.onload = function() { setTimeout(function() { window.print(); }, 500); };");
            ticketHtml.append("</script>");
            
            ticketHtml.append("</body>");
            ticketHtml.append("</html>");
            
            // Write ticket HTML to response
            response.getWriter().write(ticketHtml.toString());
            
        } catch (NumberFormatException e) {
            logger.severe("Invalid booking ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        } catch (Exception e) {
            logger.severe("Error generating ticket: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        }
    }
}
