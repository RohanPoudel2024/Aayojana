package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Event;
import model.Category;
import service.EventService;
import service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet("/events/details")
public class EventDetailsServlet extends HttpServlet {
    private EventService eventService;
    private CategoryService categoryService;
    
    @Override
    public void init() {
        eventService = new EventService();
        categoryService = new CategoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get event ID from request parameter
        String eventIdStr = request.getParameter("id");
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
            List<Event> similarEvents = eventService.getAllEvents().stream()
                    .filter(e -> e.getCategoryId() == event.getCategoryId() && e.getEventId() != event.getEventId())
                    .limit(3)
                    .toList();
            
            // Set attributes
            request.setAttribute("event", event);
            request.setAttribute("category", category);
            request.setAttribute("similarEvents", similarEvents);
            
            // Forward to event details page
            request.getRequestDispatcher("/WEB-INF/view/eventDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Invalid event ID format, redirect to event list
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
}