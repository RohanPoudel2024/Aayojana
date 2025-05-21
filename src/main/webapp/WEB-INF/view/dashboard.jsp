
<%@ page session="true" %>
<%@page import="model.User" %>
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
            <div class="dashboard-cards">
                <div class="card">
                    <div class="card-icon"><i class="fas fa-users"></i></div>
                    <div class="card-info">
                        <h3>Users</h3>
                        <p class="card-number">150</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="card-link">Manage Users</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="card-info">
                        <h3>Events</h3>
                        <p class="card-number">45</p>
                    </div>
                    <a href="#" class="card-link">Manage Events</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-ticket-alt"></i></div>
                    <div class="card-info">
                        <h3>Bookings</h3>
                        <p class="card-number">320</p>
                    </div>
                    <a href="#" class="card-link">View Bookings</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="card-info">
                        <h3>Revenue</h3>
                        <p class="card-number">NPR. 125,000</p>
                    </div>
                    <a href="#" class="card-link">Financial Reports</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-tags"></i></div>
                    <div class="card-info">
                        <h3>Categories</h3>
                        <p class="card-number">12</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="card-link">Manage Categories</a>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="section">
            <h2>Recent Activity</h2>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-user-plus"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">New user registered: <strong>Rahul Sharma</strong></p>
                        <p class="activity-time">2 hours ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-calendar-plus"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">New event created: <strong>Tech Conference 2023</strong></p>
                        <p class="activity-time">5 hours ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-ticket-alt"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">New booking: <strong>3 tickets</strong> for Music Festival</p>
                        <p class="activity-time">Yesterday</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-cog"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">System update completed</p>
                        <p class="activity-time">2 days ago</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>