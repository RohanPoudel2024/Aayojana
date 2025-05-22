
<%@ page session="true" %>
<%@page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <!-- Added Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Additional styles for enhanced icons */
        .card-icon {
            font-size: 2.5rem;
            color: #4a00e0;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .card {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 25px;
            text-align: center;
        }
        
        .card-info h3 {
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }
        
        .activity-icon {
            font-size: 1.8rem;
            color: #4a00e0;
            margin-right: 15px;
        }
    </style>
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
            <h2>Dashboard Overview</h2>            <div class="dashboard-cards">                <div class="card">
                    <div class="card-icon"><i class="fas fa-users"></i></div>
                    <div class="card-info">
                        <h3>Users</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="card-link">Manage Users</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="card-info">
                        <h3>Events</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/events" class="card-link">Manage Events</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-ticket-alt"></i></div>
                    <div class="card-info">
                        <h3>Bookings</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="card-link">View Bookings</a>
                </div>                <div class="card">
                    <div class="card-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="card-info">
                        <h3>Revenue</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/financial-reports" class="card-link">Financial Reports</a>
                </div>
                <div class="card">
                    <div class="card-icon"><i class="fas fa-tags"></i></div>
                    <div class="card-info">
                        <h3>Categories</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="card-link">Manage Categories</a>
                </div>
            </div>
        </div>        <!-- Recent Activity -->
        <div class="section">
            <h2>Recent Activity</h2>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-user-plus"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">User Registration</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-ticket-alt"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">Event Booking</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-calendar-plus"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">New Event</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon"><i class="fas fa-cog"></i></div>
                    <div class="activity-details">
                        <p class="activity-text">System Update</p>
                    </div>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>