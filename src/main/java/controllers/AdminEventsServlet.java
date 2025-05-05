package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Event;
import model.User;
import model.Category;
import service.EventService;
import service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/events")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 5 * 1024 * 1024,       // 5MB max file size
    maxRequestSize = 10 * 1024 * 1024    // 10MB max request size
)
public class AdminEventsServlet extends HttpServlet {
    private EventService eventService;
    
    @Override
    public void init() {
        eventService = new EventService();
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
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Default action - list events
            listEvents(request, response);
        } else {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                default:
                    listEvents(request, response);
                    break;
            }
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
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/events");
            return;
        }
        
        switch (action) {
            case "create":
                createEvent(request, response);
                break;
            case "update":
                updateEvent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/events");
                break;
        }
    }
    
    private void listEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get events from service
        List<Event> events = eventService.getAllEvents();
        request.setAttribute("events", events);
        request.getRequestDispatcher("/WEB-INF/view/admin/events.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        CategoryService categoryService = new CategoryService();
        List<Category> activeCategories = categoryService.getActiveCategories();
        request.setAttribute("categories", activeCategories);
        
        request.getRequestDispatcher("/WEB-INF/view/admin/eventForm.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventService.getEventById(eventId);
        
        if (event == null) {
            // Event not found, redirect to events list
            response.sendRedirect(request.getContextPath() + "/admin/events");
            return;
        }
        
        CategoryService categoryService = new CategoryService();
        List<Category> activeCategories = categoryService.getActiveCategories();
        request.setAttribute("categories", activeCategories);
        
        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/view/admin/eventForm.jsp").forward(request, response);
    }
    
    private void createEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        String time = request.getParameter("time");
        String seatsStr = request.getParameter("availableSeats");
        String priceStr = request.getParameter("price");
        
        // Get image file
        Part filePart = request.getPart("eventImage");
        
        // Process event creation via service
        boolean success = eventService.processEventCreation(
            title, location, dateStr, time, seatsStr, priceStr, filePart
        );
        
        if (success) {
            // Set success message
            request.getSession().setAttribute("successMessage", "Event created successfully.");
        } else {
            // Set error message
            request.getSession().setAttribute("errorMessage", "Failed to create event. Please check your input.");
        }
        
        // Redirect to events list
        response.sendRedirect(request.getContextPath() + "/admin/events");
    }
    
    private void updateEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        int eventId = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        String time = request.getParameter("time");
        String seatsStr = request.getParameter("availableSeats");
        String priceStr = request.getParameter("price");
        
        // Get image file if uploaded
        Part filePart = request.getPart("eventImage");
        
        // Process event update via service
        boolean success = eventService.processEventUpdate(
            eventId, title, location, dateStr, time, seatsStr, priceStr, filePart
        );
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Event updated successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update event. Please check your input.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events");
    }
    
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        boolean success = eventService.deleteEvent(eventId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Event deleted successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to delete event.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events");
    }
}