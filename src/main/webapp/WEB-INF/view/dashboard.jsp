
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
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard" class="active"><span class="icon"><i class="fas fa-chart-bar"></i></span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"><span class="icon"><i class="fas fa-users"></i></span>Users</a>
        <a href="${pageContext.request.contextPath}/admin/events"><span class="icon"><i class="fas fa-calendar-alt"></i></span>Events</a>
        <a href="${pageContext.request.contextPath}/admin/categories"><span class="icon"><i class="fas fa-tag"></i></span>Categories</a>
        <a href="#"><span class="icon"><i class="fas fa-clipboard-list"></i></span>Reports</a>
        <a href="#"><span class="icon"><i class="fas fa-cog"></i></span>Settings</a>
        <div class="user-account">
            <a href="#"><span class="icon"><i class="fas fa-user"></i></span>User Account</a>
            <a href="${pageContext.request.contextPath}/profile"><span class="icon"><i class="fas fa-eye"></i></span>View profile</a>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" style="background: none; border: none; color: #666; text-align: left; width: 100%; padding: 12px 0; cursor: pointer; display: flex; align-items: center;">
                    <span class="icon" style="margin-right: 10px;"><i class="fas fa-sign-out-alt"></i></span>Logout
                </button>
            </form>
        </div>
    </div>
    <div class="main-content">
        <div class="header">
            <div class="nav-links">
                <a href="#" class="active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                <a href="#">Reports</a>
            </div>
            <div class="user">
                <%
                    User user = (User) session.getAttribute("currentUser");
                    if (user != null) {
                %>
                <span><%=user.getName()%></span>
                <span class="icon"><i class="fas fa-bell"></i></span>
                <span class="icon"><i class="fas fa-user-circle"></i></span>
            </div>
            <%
                } else {
                    response.sendRedirect(request.getContextPath() + "/login");
                }
            %>
        </div>

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