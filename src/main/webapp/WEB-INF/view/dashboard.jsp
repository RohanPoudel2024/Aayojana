
<%@ page session="true" %>
<%@page import="model.User" %>
<%@page import="java.util.List" %>
<%@page import="model.DashboardActivity" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <!-- Added Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="common/adminSidebar.jsp" />
      <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="common/adminHeader.jsp" />
        <%
            User user = (User) session.getAttribute("currentUser");
        %>

        <!-- Dashboard Overview -->
        <div class="section">
            <h2>Dashboard Overview</h2>
            <div class="dashboard-cards">                <div class="card">
                    <div class="card-icon"><i class="fas fa-users"></i></div>
                    <div class="card-info">
                        <h3>Users</h3>
                        <p class="card-number">${totalUsers}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="card-link">Manage Users</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="card-info">
                        <h3>Events</h3>
                        <p class="card-number">${totalEvents}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/events" class="card-link">Manage Events</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-ticket-alt"></i></div>
                    <div class="card-info">
                        <h3>Bookings</h3>
                        <p class="card-number">${totalBookings}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="card-link">View Bookings</a>
                </div>                <div class="card">
                    <div class="card-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="card-info">
                        <h3>Revenue</h3>
                        <p class="card-number">${totalRevenue}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/financial-reports" class="card-link">Financial Reports</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-tags"></i></div>
                    <div class="card-info">
                        <h3>Categories</h3>
                        <p class="card-number">${totalCategories}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="card-link">Manage Categories</a>
                </div>
            </div>
        </div>        <!-- Recent Activity -->
        <div class="section">
            <h2>Recent Activity</h2>
            <div class="activity-list">
                <% if (request.getAttribute("recentActivities") != null) { 
                    List<model.DashboardActivity> activities = (List<model.DashboardActivity>) request.getAttribute("recentActivities");
                    for (model.DashboardActivity activity : activities) {
                %>
                <div class="activity-item">
                    <div class="activity-icon"><i class="<%= activity.getIconClass() %>"></i></div>
                    <div class="activity-details">
                        <p class="activity-text"><%= activity.getDescription() %></p>
                        <p class="activity-time"><%= activity.getTimeAgo() %></p>
                    </div>
                </div>
                <% } } else { %>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-info-circle"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">No recent activities found</p>
                        <p class="activity-time">Now</p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>