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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/EventsServlet")
public class EventsServlet extends HttpServlet {
    private EventService eventService;
    private CategoryService categoryService;
    
    @Override
    public void init() {
        eventService = new EventService();
        categoryService = new CategoryService();
    }
      @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for view type parameter
        String viewType = request.getParameter("view");
        boolean isUpcomingView = "upcoming".equals(viewType);
        
        // Get categories for the category grid
        List<Category> activeCategories = categoryService.getActiveCategories();
        request.setAttribute("categories", activeCategories);
        
        // Create a map of category IDs to event counts
        Map<Integer, Integer> categoryEventCounts = new HashMap<>();
        for (Category category : activeCategories) {
            int categoryId = category.getCategoryId();
            int eventCount = eventService.getEventCountByCategory(categoryId);
            categoryEventCounts.put(categoryId, eventCount);
        }
        request.setAttribute("categoryEventCounts", categoryEventCounts);
        
        List<Event> allEvents;
        
        // If upcoming view is requested, get only upcoming events
        if (isUpcomingView) {
            allEvents = eventService.getUpcomingEvents();
            request.setAttribute("isUpcomingView", true);
            request.setAttribute("pageTitle", "Upcoming Events");
        } else {
            // Get all events (default view)
            allEvents = eventService.getAllEvents();
            request.setAttribute("pageTitle", "Explore Events");
        }
          // Featured events (most recent 3)
        List<Event> newEvents = allEvents.stream()
                .limit(3)
                .collect(Collectors.toList());
        
        // Upcoming events (next 2)
        List<Event> upcomingEvents = allEvents.stream()
                .skip(3)
                .limit(2)
                .collect(Collectors.toList());
        
        // Highlight event (if exists)
        Event highlightEvent = allEvents.size() > 5 ? allEvents.get(5) : null;
        
        // More events (remaining)
        List<Event> moreEvents = allEvents.stream()
                .skip(6)
                .limit(3)
                .collect(Collectors.toList());
        
        // For upcoming view, adjust the display structure
        if (isUpcomingView) {
            // For upcoming view, use all events as the main list
            // and skip the smaller sections
            moreEvents = allEvents;
            request.setAttribute("showAllEvents", true);
        }
          // Add to request attributes
        request.setAttribute("newEvents", newEvents);
        request.setAttribute("upcomingEvents", upcomingEvents);
        request.setAttribute("highlightEvent", highlightEvent);
        request.setAttribute("moreEvents", moreEvents);
        request.setAttribute("allEvents", allEvents);
        
        // Category filter handling
        String categoryFilter = request.getParameter("category");
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryFilter);
                List<Event> filteredEvents = allEvents.stream()
                        .filter(event -> event.getCategoryId() == categoryId)
                        .collect(Collectors.toList());
                request.setAttribute("filteredEvents", filteredEvents);
                request.setAttribute("selectedCategoryId", categoryId);
                
                // If we're in upcoming view, update the URL parameter
                if (isUpcomingView) {
                    request.setAttribute("viewUrlParam", "view=upcoming&");
                } else {
                    request.setAttribute("viewUrlParam", "");
                }
            } catch (NumberFormatException e) {
                // Invalid category parameter, ignore
            }
        }
        
        // Forward to the eventList.jsp
        request.getRequestDispatcher("/WEB-INF/view/eventList.jsp").forward(request, response);
    }
}
