package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Event;
import model.Category;
import service.EventService;
import service.CategoryService;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/search", "/Aayojana_war_exploded/search"})
public class SearchServlet extends HttpServlet {
    private EventService eventService;
    private CategoryService categoryService;
    
    @Override
    public void init() {
        eventService = new EventService();
        categoryService = new CategoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get search parameters
        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String categoryId = request.getParameter("category");
        String priceRange = request.getParameter("priceRange");
        String sortBy = request.getParameter("sortBy");
        
        // Search for events matching the criteria
        List<Event> searchResults = eventService.searchEvents(keyword, location, categoryId);
        
        // Apply price range filter if specified
        if (priceRange != null && !priceRange.isEmpty()) {
            searchResults = filterByPriceRange(searchResults, priceRange);
        }
        
        // Apply sorting if specified
        if (sortBy != null && !sortBy.isEmpty()) {
            searchResults = sortEvents(searchResults, sortBy);
        }
        
        // Get all categories for filters
        List<Category> categories = categoryService.getAllCategories();
        
        // Set attributes
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("location", location);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("selectedSortBy", sortBy);
        
        // Forward to search page
        request.getRequestDispatcher("/WEB-INF/view/searchPage.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For form submissions, redirect to GET
        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String categoryId = request.getParameter("category");
        String priceRange = request.getParameter("priceRange");
        String sortBy = request.getParameter("sortBy");
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/search?");
        
        if (keyword != null && !keyword.isEmpty()) {
            redirectUrl.append("keyword=").append(keyword);
        }
        
        if (location != null && !location.isEmpty()) {
            if (!redirectUrl.toString().endsWith("?")) {
                redirectUrl.append("&");
            }
            redirectUrl.append("location=").append(location);
        }
        
        if (categoryId != null && !categoryId.isEmpty()) {
            if (!redirectUrl.toString().endsWith("?")) {
                redirectUrl.append("&");
            }
            redirectUrl.append("category=").append(categoryId);
        }
        
        if (priceRange != null && !priceRange.isEmpty()) {
            if (!redirectUrl.toString().endsWith("?")) {
                redirectUrl.append("&");
            }
            redirectUrl.append("priceRange=").append(priceRange);
        }
        
        if (sortBy != null && !sortBy.isEmpty()) {
            if (!redirectUrl.toString().endsWith("?")) {
                redirectUrl.append("&");
            }
            redirectUrl.append("sortBy=").append(sortBy);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }
    
    private List<Event> filterByPriceRange(List<Event> events, String priceRange) {
        if (events == null || events.isEmpty() || priceRange == null || priceRange.isEmpty()) {
            return events;
        }
        
        switch (priceRange) {
            case "free":
                return events.stream()
                        .filter(e -> e.getPrice() == 0)
                        .collect(Collectors.toList());
            case "under500":
                return events.stream()
                        .filter(e -> e.getPrice() > 0 && e.getPrice() <= 500)
                        .collect(Collectors.toList());
            case "500to1000":
                return events.stream()
                        .filter(e -> e.getPrice() > 500 && e.getPrice() <= 1000)
                        .collect(Collectors.toList());
            case "1000to5000":
                return events.stream()
                        .filter(e -> e.getPrice() > 1000 && e.getPrice() <= 5000)
                        .collect(Collectors.toList());
            case "above5000":
                return events.stream()
                        .filter(e -> e.getPrice() > 5000)
                        .collect(Collectors.toList());
            default:
                return events;
        }
    }
    
    private List<Event> sortEvents(List<Event> events, String sortBy) {
        if (events == null || events.isEmpty() || sortBy == null || sortBy.isEmpty()) {
            return events;
        }
        
        switch (sortBy) {
            case "dateAsc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getDate))
                        .collect(Collectors.toList());
            case "dateDesc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getDate).reversed())
                        .collect(Collectors.toList());
            case "priceAsc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getPrice))
                        .collect(Collectors.toList());
            case "priceDesc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getPrice).reversed())
                        .collect(Collectors.toList());
            case "nameAsc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getTitle))
                        .collect(Collectors.toList());
            case "nameDesc":
                return events.stream()
                        .sorted(Comparator.comparing(Event::getTitle).reversed())
                        .collect(Collectors.toList());
            default:
                return events;
        }
    }
}
