<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String selectedReport = (String) request.getAttribute("selectedReport");
    
    // Format for dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Financial Reports - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .report-nav {
            background-color: #f8f9fa;
            padding: 10px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .report-nav a {
            padding: 8px 15px;
            border-radius: 20px;
            text-decoration: none;
            color: #495057;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .report-nav a:hover {
            background-color: #e9ecef;
        }
        
        .report-nav a.active {
            background-color: #4a00e0;
            color: white;
        }
        
        .report-section {
            margin-bottom: 30px;
        }
        
        .report-section h2 {
            color: #212529;
            font-size: 1.5rem;
            margin-bottom: 15px;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
        
        .overview-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .overview-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
        }
        
        .overview-card .title {
            color: #6c757d;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 10px;
        }
        
        .overview-card .amount {
            color: #212529;
            font-size: 1.75rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .overview-card .period {
            color: #adb5bd;
            font-size: 0.75rem;
        }
        
        .charts-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .chart-wrapper {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .chart-title {
            color: #212529;
            font-size: 1.125rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .canvas-container {
            position: relative;
            height: 300px;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        .report-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .report-table th, .report-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        
        .report-table th {
            background-color: #f8f9fa;
            font-weight: 500;
            color: #495057;
        }
        
        .report-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .progress-bar {
            height: 8px;
            width: 100%;
            background-color: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .progress-value {
            height: 100%;
            background-color: #4a00e0;
        }
        
        .report-summary {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .summary-text {
            color: #212529;
            font-weight: 500;
        }
        
        .summary-amount {
            color: #212529;
            font-size: 1.25rem;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .charts-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
        
        <div class="content-area" style="padding: 20px;">            <div class="page-title">
                <h1>Financial Reports</h1>
            </div>            <% if (request.getAttribute("debugInfo") != null) { %>
            <div style="background-color: #f8f9fa; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #17a2b8; font-size: 0.875rem;">
                Debug Info: <%= request.getAttribute("debugInfo") %>
            </div>
            <% } %>
            
            <% if (request.getAttribute("errorInfo") != null) { %>
            <div style="background-color: #f8d7da; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #dc3545; font-size: 0.875rem;">
                <%= request.getAttribute("errorInfo") %>
            </div>
            <% } %>
            
            <!-- Include sample data widget -->
            <jsp:include page="addSampleDataWidget.jsp" />
            
            <!-- Include sample data widget -->
            <jsp:include page="sampleDataWidget.jsp" />
            
            <% if (request.getAttribute("bookingsCount") != null && ((Integer)request.getAttribute("bookingsCount")) == 0) { %>
            <div style="background-color: #fff3cd; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #ffc107; font-size: 0.875rem;">
                <p>No booking data found. You can add sample data for testing purposes:</p>
                <form action="${pageContext.request.contextPath}/admin/financial-reports" method="post">
                    <input type="hidden" name="action" value="addSampleData">
                    <button type="submit" style="background-color: #ffc107; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Add Sample Data</button>
                </form>
            </div>
            <% } %>
            
            <% if (request.getAttribute("dataSampleAdded") != null) { %>
            <div style="background-color: #d4edda; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #28a745; font-size: 0.875rem;">
                Sample data added successfully! Please refresh to see the reports.
            </div>
            <% } %>
            
            <!-- Report Navigation -->
            <div class="report-nav">
                <a href="${pageContext.request.contextPath}/admin/financial-reports?report=overview" 
                   class="<%= "overview".equals(selectedReport) ? "active" : "" %>">Overview</a>
                <a href="${pageContext.request.contextPath}/admin/financial-reports?report=monthly" 
                   class="<%= "monthly".equals(selectedReport) ? "active" : "" %>">Monthly Revenue</a>
                <a href="${pageContext.request.contextPath}/admin/financial-reports?report=events" 
                   class="<%= "events".equals(selectedReport) ? "active" : "" %>">Event Performance</a>
                <a href="${pageContext.request.contextPath}/admin/financial-reports?report=categories" 
                   class="<%= "categories".equals(selectedReport) ? "active" : "" %>">Category Breakdown</a>
                <a href="${pageContext.request.contextPath}/admin/financial-reports?report=transactions" 
                   class="<%= "transactions".equals(selectedReport) ? "active" : "" %>">Transactions</a>
            </div>
            
            <!-- Report Content -->
            <% if ("overview".equals(selectedReport)) { %>
                <div class="report-section">
                    <h2>Revenue Overview</h2>
                      <div class="overview-cards">
                        <div class="overview-card">
                            <div class="title">Total Revenue</div>
                            <div class="icon"><i class="fas fa-money-bill-wave fa-2x"></i></div>
                        </div>
                        <div class="overview-card">
                            <div class="title">This Year</div>
                            <div class="icon"><i class="fas fa-calendar-alt fa-2x"></i></div>
                        </div>
                        <div class="overview-card">
                            <div class="title">This Month</div>
                            <div class="icon"><i class="fas fa-calendar-check fa-2x"></i></div>
                        </div>
                        <div class="overview-card">
                            <div class="title">This Week</div>
                            <div class="icon"><i class="fas fa-calendar-week fa-2x"></i></div>
                        </div>
                    </div>
                </div>
                
                <div class="charts-container">
                    <div class="chart-wrapper">
                        <div class="chart-title">Revenue Trend (Last 6 Months)</div>
                        <div class="canvas-container">
                            <canvas id="monthlyRevenueChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="chart-wrapper">
                        <div class="chart-title">Revenue by Category</div>
                        <div class="canvas-container">
                            <canvas id="categoryRevenueChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <div class="report-section">
                    <h2>Top Performing Events</h2>
                    <div class="table-responsive">
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>Event</th>
                                    <th>Location</th>
                                    <th>Bookings</th>
                                    <th>Seats</th>
                                    <th>Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Map<String, Object>> topEvents = (List<Map<String, Object>>) request.getAttribute("topEvents");
                                    if (topEvents != null && !topEvents.isEmpty()) {
                                        for (Map<String, Object> event : topEvents) {
                                %>
                                <tr>
                                    <td><%= event.get("title") %></td>
                                    <td><%= event.get("location") %></td>
                                    <td><%= event.get("bookings_count") %></td>
                                    <td><%= event.get("total_seats") %></td>
                                    <td>NPR. <%= String.format("%,.2f", (Double) event.get("total_revenue")) %></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" style="text-align: center;">No event data available</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="report-section">
                    <h2>Recent Transactions</h2>
                    <div class="table-responsive">
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>User</th>
                                    <th>Event</th>
                                    <th>Seats</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Map<String, Object>> transactions = (List<Map<String, Object>>) request.getAttribute("recentTransactions");
                                    if (transactions != null && !transactions.isEmpty()) {
                                        for (Map<String, Object> transaction : transactions) {
                                %>
                                <tr>
                                    <td>#<%= transaction.get("id") %></td>
                                    <td><%= dateFormat.format((Date) transaction.get("date")) %></td>
                                    <td><%= transaction.get("userName") %></td>
                                    <td><%= transaction.get("eventTitle") %></td>
                                    <td><%= transaction.get("seats") %></td>
                                    <td>NPR. <%= String.format("%,.2f", (Double) transaction.get("price")) %></td>
                                    <td><span class="<%= "CANCELLED".equals(transaction.get("status")) ? "status-cancelled" : "status-confirmed" %>"><%= transaction.get("status") %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center;">No transaction data available</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            <% } else if ("monthly".equals(selectedReport)) { %>
                <div class="report-section">
                    <h2>Monthly Revenue Analysis</h2>
                    
                    <div class="report-summary">
                        <div class="summary-text">Total Revenue (${periodDescription})</div>
                        <div class="summary-amount">${totalRevenue}</div>
                    </div>
                    
                    <div class="chart-wrapper">
                        <div class="chart-title">Monthly Revenue Trend</div>
                        <div class="canvas-container">
                            <canvas id="monthlyRevenueChart"></canvas>
                        </div>
                    </div>
                </div>
                
            <% } else if ("events".equals(selectedReport)) { %>
                <div class="report-section">
                    <h2>Event Performance Analysis</h2>
                    
                    <div class="report-summary">
                        <div class="summary-text">Total Revenue from Top Events</div>
                        <div class="summary-amount">${totalRevenue}</div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>Event</th>
                                    <th>Location</th>
                                    <th>Bookings</th>
                                    <th>Seats</th>
                                    <th>Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Map<String, Object>> topEvents = (List<Map<String, Object>>) request.getAttribute("topEvents");
                                    if (topEvents != null && !topEvents.isEmpty()) {
                                        for (Map<String, Object> event : topEvents) {
                                %>
                                <tr>
                                    <td><%= event.get("title") %></td>
                                    <td><%= event.get("location") %></td>
                                    <td><%= event.get("bookings_count") %></td>
                                    <td><%= event.get("total_seats") %></td>
                                    <td><%= event.get("formatted_revenue") %></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" style="text-align: center;">No event data available</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            <% } else if ("categories".equals(selectedReport)) { %>
                <div class="report-section">
                    <h2>Revenue by Category</h2>
                    
                    <div class="report-summary">
                        <div class="summary-text">Total Revenue Across All Categories</div>
                        <div class="summary-amount">${totalRevenue}</div>
                    </div>
                    
                    <div class="chart-wrapper">
                        <div class="chart-title">Revenue Distribution by Category</div>
                        <div class="canvas-container">
                            <canvas id="categoryRevenueChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="table-responsive" style="margin-top: 30px;">
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Percentage</th>
                                    <th>Distribution</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    Map<String, Double> categoryData = (Map<String, Double>) request.getAttribute("categoryRevenueData");
                                    if (categoryData != null && !categoryData.isEmpty()) {
                                        for (Map.Entry<String, Double> entry : categoryData.entrySet()) {
                                %>
                                <tr>
                                    <td><%= entry.getKey() %></td>
                                    <td><%= String.format("%.1f%%", entry.getValue()) %></td>
                                    <td>
                                        <div class="progress-bar">
                                            <div class="progress-value" style="width: <%= entry.getValue() %>%;"></div>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="3" style="text-align: center;">No category data available</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            <% } else if ("transactions".equals(selectedReport)) { %>
                <div class="report-section">
                    <h2>Transaction History</h2>
                    
                    <div class="report-summary">
                        <div class="summary-text">Total Transaction Value</div>
                        <div class="summary-amount">${totalRevenue}</div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>User</th>
                                    <th>Event</th>
                                    <th>Seats</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Map<String, Object>> transactions = (List<Map<String, Object>>) request.getAttribute("transactions");
                                    if (transactions != null && !transactions.isEmpty()) {
                                        for (Map<String, Object> transaction : transactions) {
                                %>
                                <tr>
                                    <td>#<%= transaction.get("id") %></td>
                                    <td><%= dateFormat.format((Date) transaction.get("date")) %></td>
                                    <td><%= transaction.get("userName") %></td>
                                    <td><%= transaction.get("eventTitle") %></td>
                                    <td><%= transaction.get("seats") %></td>
                                    <td><%= transaction.get("formatted_price") %></td>
                                    <td><span class="<%= "CANCELLED".equals(transaction.get("status")) ? "status-cancelled" : "status-confirmed" %>"><%= transaction.get("status") %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center;">No transaction data available</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<!-- JavaScript for Charts -->
<script>
    // Monthly Revenue Chart
    <% if ("overview".equals(selectedReport) || "monthly".equals(selectedReport)) { %>
    window.addEventListener('load', function() {
        const monthlyRevenueData = {
            labels: [
                <% 
                    Map<String, Double> monthlyData = (Map<String, Double>) request.getAttribute("monthlyRevenueData");
                    if (monthlyData != null && !monthlyData.isEmpty()) {
                        boolean first = true;
                        for (String month : monthlyData.keySet()) {
                            if (!first) { out.print(", "); }
                            out.print("'" + month + "'");
                            first = false;
                        }
                    }
                %>
            ],
            datasets: [{
                label: 'Revenue',
                data: [
                    <% 
                        if (monthlyData != null && !monthlyData.isEmpty()) {
                            boolean first = true;
                            for (Double revenue : monthlyData.values()) {
                                if (!first) { out.print(", "); }
                                out.print(revenue);
                                first = false;
                            }
                        }
                    %>
                ],
                backgroundColor: 'rgba(74, 0, 224, 0.2)',
                borderColor: 'rgba(74, 0, 224, 1)',
                borderWidth: 2,
                tension: 0.3,
                fill: true
            }]
        };
        
        const ctx = document.getElementById('monthlyRevenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: monthlyRevenueData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'NPR. ' + value.toLocaleString();
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Revenue: NPR. ' + context.raw.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    });
    <% } %>
    
    // Category Revenue Chart
    <% if ("overview".equals(selectedReport) || "categories".equals(selectedReport)) { %>
    window.addEventListener('load', function() {
        const categoryRevenueData = {
            labels: [
                <% 
                    Map<String, Double> categoryData = (Map<String, Double>) request.getAttribute("categoryRevenueData");
                    if (categoryData != null && !categoryData.isEmpty()) {
                        boolean first = true;
                        for (String category : categoryData.keySet()) {
                            if (!first) { out.print(", "); }
                            out.print("'" + category + "'");
                            first = false;
                        }
                    }
                %>
            ],
            datasets: [{
                data: [
                    <% 
                        if (categoryData != null && !categoryData.isEmpty()) {
                            boolean first = true;
                            for (Double value : categoryData.values()) {
                                if (!first) { out.print(", "); }
                                out.print(value);
                                first = false;
                            }
                        }
                    %>
                ],
                backgroundColor: [
                    'rgba(74, 0, 224, 0.7)',
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(153, 102, 255, 0.7)',
                    'rgba(255, 159, 64, 0.7)'
                ],
                borderColor: [
                    'rgba(74, 0, 224, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        };
        
        const ctx = document.getElementById('categoryRevenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: categoryRevenueData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    tooltip: {
                        callbacks: {
                            <% if ("overview".equals(selectedReport)) { %>
                            label: function(context) {
                                return context.label + ': NPR. ' + context.raw.toLocaleString();
                            }
                            <% } else { %>
                            label: function(context) {
                                return context.label + ': ' + context.raw.toFixed(1) + '%';
                            }
                            <% } %>
                        }
                    }
                }
            }
        });
    });
    <% } %>
</script>

</body>
</html>
