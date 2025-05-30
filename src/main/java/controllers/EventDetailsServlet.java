package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Event;
import model.Category;
import model.User;
import model.Booking;
import service.EventService;
import service.CategoryService;
import service.BookingService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/events/details")
public class EventDetailsServlet extends HttpServlet {    private static final long serialVersionUID = 1L;
    private EventService eventService;
    private CategoryService categoryService;
    private BookingService bookingService;
    private static final Logger logger = Logger.getLogger(EventDetailsServlet.class.getName());
    
    @Override
    public void init() {
        eventService = new EventService();
        categoryService = new CategoryService();
        bookingService = new BookingService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get event ID from request parameter
        String eventIdStr = request.getParameter("id");
        logger.info("Processing event details request for ID: " + eventIdStr);
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            // No event ID provided, redirect to event list
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventService.getEventById(eventId);
            
            if (event == null) {
                // Event not found, redirect to event list
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            // Get category of this event
            Category category = categoryService.getCategoryById(event.getCategoryId());
              // Get similar events (same category, exclude current)
            List<Event> similarEvents = eventService.getEventsByCategory(event.getCategoryId(), 3, event.getEventId());
              // Check if the current user has booked this event
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            Booking userBooking = null;
            
            if (currentUser != null) {
                userBooking = bookingService.getUserBookingForEvent(currentUser.getUserId(), eventId);
                request.setAttribute("userBooking", userBooking);
            } else {
                // For non-logged in users, store the current URL for redirection after login
                String redirectUrl = request.getRequestURI() + "?id=" + eventId;
                session.setAttribute("redirectAfterLogin", redirectUrl);
            }
            
            // Set attributes
            request.setAttribute("event", event);
            request.setAttribute("category", category);
            request.setAttribute("similarEvents", similarEvents);
            
            // Forward to event details page
            logger.info("Forwarding to details page for event: " + event.getTitle());
            request.getRequestDispatcher("/WEB-INF/view/eventDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.severe("Invalid event ID format: " + eventIdStr);
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        } catch (Exception e) {
            logger.severe("Error processing event details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
}