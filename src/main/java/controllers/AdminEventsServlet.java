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
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/events")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     
    maxFileSize = 5 * 1024 * 1024,       
    maxRequestSize = 10 * 1024 * 1024    
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
        
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            
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
        
        
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        String time = request.getParameter("time");
        String seatsStr = request.getParameter("availableSeats");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        
        
        Part filePart = request.getPart("eventImage");
        
        
        Event event = new Event();
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            event.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        
        
        if (filePart != null && filePart.getSize() > 0) {
            try {
                boolean imageAdded = eventService.handleEventImage(filePart, event);
                if (!imageAdded) {
                    
                    System.out.println("Warning: Image processing failed!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                
            }
        }
        
        
        boolean success = eventService.createEvent(event);
        
        if (success) {
            
            request.getSession().setAttribute("successMessage", "Event created successfully.");
        } else {
            
            request.getSession().setAttribute("errorMessage", "Failed to create event. Please check your input.");
        }
        
        
        response.sendRedirect(request.getContextPath() + "/admin/events");
    }
    
    private void updateEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        String time = request.getParameter("time");
        String seatsStr = request.getParameter("availableSeats");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        
        
        Part filePart = request.getPart("eventImage");
        
        
        Event event = new Event();
        event.setEventId(eventId);
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            event.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        
        
        if (filePart != null && filePart.getSize() > 0) {
            try {
                boolean imageAdded = eventService.handleEventImage(filePart, event);
                if (!imageAdded) {
                    
                    System.out.println("Warning: Image processing failed!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                
            }
        }
        
        
        boolean success = eventService.updateEvent(event);
        
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