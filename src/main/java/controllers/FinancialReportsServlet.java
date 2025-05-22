package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.FinancialReportsDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@WebServlet("/admin/financial-reports")
public class FinancialReportsServlet extends HttpServlet {
    private FinancialReportsDAO reportsDAO;
    
    @Override
    public void init() {
        reportsDAO = new FinancialReportsDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Check if user is authenticated and has admin privileges
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get report type from request parameters (default to "overview")
            String reportType = request.getParameter("report");
            if (reportType == null) {
                reportType = "overview";
            }
            
            // Prepare data based on report type
            switch (reportType) {
                case "overview":
                    prepareOverviewReport(request);
                    break;
                case "monthly":
                    prepareMonthlyReport(request);
                    break;
                case "events":
                    prepareEventsReport(request);
                    break;
                case "categories":
                    prepareCategoriesReport(request);
                    break;
                case "transactions":
                    prepareTransactionsReport(request);
                    break;
                default:
                    prepareOverviewReport(request);
                    reportType = "overview";
                    break;
            }
            
            // Set the selected report type
            request.setAttribute("selectedReport", reportType);
            
            // Add debugging information
            try {
                int bookingsCount = reportsDAO.getBookingsCount();
                String schemaInfo = reportsDAO.checkDatabaseSchema();
                request.setAttribute("bookingsCount", bookingsCount);
                request.setAttribute("debugInfo", "Total bookings in database: " + bookingsCount + 
                                     "\nDatabase schema info: " + schemaInfo);
            } catch (Exception e) {
                request.setAttribute("debugInfo", "Error getting bookings count: " + e.getMessage());
            }
            
            // Forward to the financial reports page
            request.getRequestDispatcher("/WEB-INF/view/admin/financialReports.jsp").forward(request, response);
            
        } catch (SQLException e) {
            // Log error and set error message
            getServletContext().log("Database error in FinancialReportsServlet", e);
            request.setAttribute("errorMessage", "A database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Check if user is authenticated and has admin privileges
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if this is a request to add sample data
        String action = request.getParameter("action");
        if ("addSampleData".equals(action)) {
            try {
                boolean dataAdded = reportsDAO.addSampleBookingsData();
                request.setAttribute("dataSampleAdded", dataAdded);
                
                // Proceed to show the reports page
                doGet(request, response);
            } catch (SQLException e) {
                getServletContext().log("Error adding sample data", e);
                request.setAttribute("errorMessage", "Failed to add sample data: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
            }
        } else {
            // For any other POST actions, redirect to GET
            response.sendRedirect(request.getContextPath() + "/admin/financial-reports");
        }
    }
    
    private void prepareOverviewReport(HttpServletRequest request) throws SQLException {
        try {
            // Get revenue overview
            Map<String, Double> revenueOverview = reportsDAO.getRevenueOverview();
            
            // Format currency values
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
            
            for (Map.Entry<String, Double> entry : revenueOverview.entrySet()) {
                String key = entry.getKey() + "Revenue";
                Double value = entry.getValue() != null ? entry.getValue() : 0.0;
                String formattedValue = currencyFormatter.format(value).replace("NPR", "NPR. ");
                request.setAttribute(key, formattedValue);
            }
            
            // Set default values if not present
            if (!request.getAttributeNames().hasMoreElements()) {
                request.setAttribute("totalRevenue", "NPR. 0.00");
                request.setAttribute("yearRevenue", "NPR. 0.00");
                request.setAttribute("monthRevenue", "NPR. 0.00");
                request.setAttribute("weekRevenue", "NPR. 0.00");
            }
            
            // Get monthly revenue for chart
            Map<String, Double> monthlyRevenue = reportsDAO.getMonthlyRevenue();
            request.setAttribute("monthlyRevenueData", monthlyRevenue);
            
            // Get top 5 events by revenue
            List<Map<String, Object>> topEvents = reportsDAO.getTopEventsByRevenue();
            request.setAttribute("topEvents", topEvents);
            
            // Get category breakdown
            Map<String, Double> categoryRevenue = reportsDAO.getRevenueByCategoryChart();
            request.setAttribute("categoryRevenueData", categoryRevenue);
            
            // Get recent transactions
            List<Map<String, Object>> recentTransactions = reportsDAO.getRecentTransactions(5);
            request.setAttribute("recentTransactions", recentTransactions);
            
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error preparing overview report", e);
            
            // Set default values
            request.setAttribute("totalRevenue", "NPR. 0.00");
            request.setAttribute("yearRevenue", "NPR. 0.00");
            request.setAttribute("monthRevenue", "NPR. 0.00");
            request.setAttribute("weekRevenue", "NPR. 0.00");
            request.setAttribute("monthlyRevenueData", new HashMap<String, Double>());
            request.setAttribute("categoryRevenueData", new HashMap<String, Double>());
            request.setAttribute("topEvents", new ArrayList<>());
            request.setAttribute("recentTransactions", new ArrayList<>());
            request.setAttribute("errorInfo", "Error: " + e.getMessage());
        }
    }
    
    private void prepareMonthlyReport(HttpServletRequest request) throws SQLException {
        // Get monthly revenue data
        Map<String, Double> monthlyRevenue = reportsDAO.getMonthlyRevenue();
        request.setAttribute("monthlyRevenueData", monthlyRevenue);
        
        // Calculate total revenue for the period
        double totalRevenue = monthlyRevenue.values().stream().mapToDouble(Double::doubleValue).sum();
        
        // Format currency value
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
        String formattedTotal = currencyFormatter.format(totalRevenue).replace("NPR", "NPR. ");
        request.setAttribute("totalRevenue", formattedTotal);
        
        // Set period description
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM yyyy");
        LocalDate today = LocalDate.now();
        String fromMonth = today.minusMonths(5).format(formatter);
        String toMonth = today.format(formatter);
        request.setAttribute("periodDescription", fromMonth + " to " + toMonth);
    }
    
    private void prepareEventsReport(HttpServletRequest request) throws SQLException {
        // Get top events by revenue
        List<Map<String, Object>> topEvents = reportsDAO.getTopEventsByRevenue();
        request.setAttribute("topEvents", topEvents);
        
        // Format currency for top events
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
        for (Map<String, Object> event : topEvents) {
            double revenue = (Double) event.get("total_revenue");
            event.put("formatted_revenue", currencyFormatter.format(revenue).replace("NPR", "NPR. "));
        }
        
        // Calculate total revenue
        double totalRevenue = topEvents.stream()
                .mapToDouble(event -> (Double) event.get("total_revenue"))
                .sum();
                
        // Format total revenue
        String formattedTotal = currencyFormatter.format(totalRevenue).replace("NPR", "NPR. ");
        request.setAttribute("totalRevenue", formattedTotal);
    }
    
    private void prepareCategoriesReport(HttpServletRequest request) throws SQLException {
        // Get revenue breakdown by category
        Map<String, Double> categoryRevenue = reportsDAO.getRevenueByCategoryChart();
        request.setAttribute("categoryRevenueData", categoryRevenue);
        
        // Calculate total revenue
        double totalRevenue = categoryRevenue.values().stream().mapToDouble(Double::doubleValue).sum();
        
        // Format currency value
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
        String formattedTotal = currencyFormatter.format(totalRevenue).replace("NPR", "NPR. ");
        request.setAttribute("totalRevenue", formattedTotal);
        
        // Format revenue for each category
        for (Map.Entry<String, Double> entry : categoryRevenue.entrySet()) {
            double percentage = (entry.getValue() / totalRevenue) * 100;
            entry.setValue(percentage);
        }
    }
    
    private void prepareTransactionsReport(HttpServletRequest request) throws SQLException {
        // Get transactions (use a larger limit for detailed report)
        List<Map<String, Object>> transactions = reportsDAO.getRecentTransactions(100);
        request.setAttribute("transactions", transactions);
        
        // Format currency for transactions
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
        for (Map<String, Object> transaction : transactions) {
            double price = (Double) transaction.get("price");
            transaction.put("formatted_price", currencyFormatter.format(price).replace("NPR", "NPR. "));
        }
        
        // Calculate total revenue
        double totalRevenue = transactions.stream()
                .filter(t -> "CONFIRMED".equals(t.get("status")))
                .mapToDouble(t -> (Double) t.get("price"))
                .sum();
                
        // Format total revenue
        String formattedTotal = currencyFormatter.format(totalRevenue).replace("NPR", "NPR. ");
        request.setAttribute("totalRevenue", formattedTotal);
    }
}
