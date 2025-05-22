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
import java.util.List;

@WebServlet("/SearchEvents")
public class SearchEventsServlet extends HttpServlet {
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
        doGet(request, response);
    }
}
