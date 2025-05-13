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
<style>
    body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f8f9fa;
    color: #333;
}

.container {
    display: flex;
    min-height: 100vh;
}

.sidebar {
    width: 220px;
    background-color: #fff;
    padding: 20px;
    box-shadow: 2px 0 5px rgba(0,0,0,0.05);
    display: flex;
    flex-direction: column;
}

.sidebar .logo {
    font-size: 20px;
    font-weight: bold;
    color: #4a00e0;
    margin-bottom: 40px;
}

.sidebar a {
    display: flex;
    align-items: center;
    padding: 12px 0;
    color: #666;
    text-decoration: none;
    font-size: 16px;
}

.sidebar a .icon {
    margin-right: 10px;
    font-size: 18px;
}

.sidebar a.active {
    color: #4a00e0;
}

.sidebar a:hover {
    color: #4a00e0;
}

.sidebar .user-account {
    margin-top: auto;
}

.main-content {
    flex-grow: 1;
    padding: 0;
    background-color: #fff;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #fff;
    padding: 15px 30px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.header .nav-links a {
    margin: 0 20px;
    text-decoration: none;
    color: #666;
    font-size: 16px;
    padding-bottom: 5px;
}

.header .nav-links a.active {
    color: #ff4d4d;
    border-bottom: 2px solid #ff4d4d;
}

.header .user {
    display: flex;
    align-items: center;
    color: #666;
}

.header .user .icon {
    margin-left: 10px;
    font-size: 18px;
}

.stats-section {
    padding: 30px;
    background-color: #f8f9fa;
}

.stats-section h2 {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 20px;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}

.stat-card {
    background-color: #fff;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.stat-card .stat-info {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.stat-card h3 {
    font-size: 36px;
    font-weight: 700;
    margin: 0;
    color: #333;
}

.stat-card p {
    margin: 0;
    color: #999;
    font-size: 14px;
}

.stat-card .change {
    font-size: 14px;
    font-weight: 500;
}

.stat-card .increase {
    color: #28a745;
}

.stat-card .decrease {
    color: #dc3545;
}

.stat-card .chart-placeholder {
    width: 80px;
    height: 80px;
    background-color: #f0f0f0;
    border-radius: 50%;
}

.events-section {
    padding: 0 30px 30px;
    background-color: #f8f9fa;
}

.events-section h2 {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 20px;
}

.events-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.event-card {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    text-align: center;
}

.event-card .placeholder {
    width: 100%;
    height: 180px;
    background-color: #f0f0f0;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 15px;
    border-radius: 8px;
    color: #999;
    font-size: 16px;
}

.event-card p {
    margin: 0;
    font-size: 16px;
    color: #333;
}

.table-section {
    padding: 0 30px 30px;
    background-color: #f8f9fa;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    border-radius: 10px;
    overflow: hidden;
}

th, td {
    padding: 15px 20px;
    text-align: left;
    border-bottom: 1px solid #eee;
    font-size: 14px;
}

th {
    background-color: #fafafa;
    font-weight: 600;
    color: #666;
}

td {
    color: #333;
}

.status-confirmed {
    color: #28a745;
    font-weight: 500;
}

.status-pending {
    color: #ffc107;
    font-weight: 500;
}

.status-cancelled {
    color: #dc3545;
    font-weight: 500;
}

.actions {
    display: flex;
    gap: 10px;
}

.actions button {
    padding: 6px 12px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    background-color: #ffcccc;
    color: #dc3545;
    font-weight: 500;
}

.actions .edit, .actions .view, .actions .delete {
    background-color: #ffcccc;
    color: #dc3545;
}

.actions button:hover {
    background-color: #ffe6e6;
}
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
    
        .card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
        }
    
        .card-icon {
            font-size: 30px;
            margin-bottom: 15px;
        }
    
        .card-info h3 {
            margin: 0;
            color: #666;
            font-size: 16px;
        }
    
        .card-number {
            font-size: 24px;
            font-weight: bold;
            margin: 5px 0 15px 0;
            color: #333;
        }
    
        .card-link {
            margin-top: auto;
            color: #4a00e0;
            text-decoration: none;
            font-weight: 500;
        }
    
        .card-link:hover {
            text-decoration: underline;
        }
    
        .activity-list {
            margin-top: 20px;
        }
    
        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
    
        .activity-icon {
            font-size: 24px;
            margin-right: 15px;
        }
    
        .activity-details {
            flex-grow: 1;
        }
    
        .activity-text {
            margin: 0;
            color: #333;
        }
    
        .activity-time {
            margin: 5px 0 0 0;
            color: #999;
            font-size: 14px;
        }
</style>
<body>
<div class="container">
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard" class="active"><span class="icon">📊</span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"><span class="icon">👥</span>Users</a>
        <a href="${pageContext.request.contextPath}/admin/events"><span class="icon">🎉</span>Events</a>
        <a href="${pageContext.request.contextPath}/admin/categories"><span class="icon">🏷️</span>Categories</a>
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
                        <p class="card-number">NPR. 125,000</p>
                    </div>
                    <a href="#" class="card-link">Financial Reports</a>
                </div>
                <div class="card">
                    <div class="card-icon">🏷️</div>
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
