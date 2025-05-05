<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 1:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page session="true" %>
<%@page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" >
</head>
<body>
<div class="container">
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard" class="active"><span class="icon">📊</span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"><span class="icon">👥</span>Users</a>
        <a href="#"><span class="icon">🎉</span>Events</a>
        <a href="#"><span class="icon">📋</span>Reports</a>
        <a href="#"><span class="icon">⚙️</span>Settings</a>
        <div class="user-account">
            <a href="#"><span class="icon">👤</span>User Account</a>
            <a href="${pageContext.request.contextPath}/profile"><span class="icon">👓</span>View profile</a>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" style="background: none; border: none; color: #666; text-align: left; width: 100%; padding: 12px 0; cursor: pointer; display: flex; align-items: center;">
                    <span class="icon" style="margin-right: 10px;">🚪</span>Logout
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
                <span class="icon">🔔</span>
                <span class="icon">👤</span>
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
                    <div class="card-icon">👥</div>
                    <div class="card-info">
                        <h3>Users</h3>
                        <p class="card-number">150</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="card-link">Manage Users</a>
                </div>
                <div class="card">
                    <div class="card-icon">🎉</div>
                    <div class="card-info">
                        <h3>Events</h3>
                        <p class="card-number">45</p>
                    </div>
                    <a href="#" class="card-link">Manage Events</a>
                </div>
                <div class="card">
                    <div class="card-icon">🎟️</div>
                    <div class="card-info">
                        <h3>Bookings</h3>
                        <p class="card-number">320</p>
                    </div>
                    <a href="#" class="card-link">View Bookings</a>
                </div>
                <div class="card">
                    <div class="card-icon">💰</div>
                    <div class="card-info">
                        <h3>Revenue</h3>
                        <p class="card-number">₹125,000</p>
                    </div>
                    <a href="#" class="card-link">Financial Reports</a>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity -->
        <div class="section">
            <h2>Recent Activity</h2>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon">👤</div>
                    <div class="activity-details">
                        <p class="activity-text">New user registered: <strong>Rahul Sharma</strong></p>
                        <p class="activity-time">2 hours ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">🎉</div>
                    <div class="activity-details">
                        <p class="activity-text">New event created: <strong>Tech Conference 2023</strong></p>
                        <p class="activity-time">5 hours ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">🎟️</div>
                    <div class="activity-details">
                        <p class="activity-text">New booking: <strong>3 tickets</strong> for Music Festival</p>
                        <p class="activity-time">Yesterday</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">⚙️</div>
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
