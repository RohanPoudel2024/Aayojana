<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 1:32 AM
  To change this template use File | Settings | File Templates.
--%>
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
        <a href="#" class="active"><span class="icon">📊</span>Dashboard</a>
        <a href="#"><span class="icon">👥</span>Users</a>
        <a href="#"><span class="icon">🎉</span>Events</a>
        <a href="#"><span class="icon">📋</span>Reports</a>
        <a href="#"><span class="icon">⚙️</span>Settings</a>
        <div class="user-account">
            <a href="#"><span class="icon">👤</span>User Account</a>
            <a href="#"><span class="icon">👓</span>View profile</a>
        </div>
    </div>
    <div class="main-content">
        <div class="header">
            <div class="nav-links">
                <a href="#" class="active">Dashboard</a>
                <a href="#">Users</a>
                <a href="#">Reports</a>
            </div>
            <div class="user">
                <span>User Account</span>
                <span class="icon">🔔</span>
                <span class="icon">👤</span>
            </div>
        </div>
        <div class="stats-section">
            <h2>Key Stats Overview</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>1,245</h3>
                        <p>Total Users</p>
                        <p class="change increase">+12.5%</p>
                    </div>
                    <div class="chart-placeholder"></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>$45,670</h3>
                        <p>Monthly Revenue</p>
                        <p class="change decrease">-8.2%</p>
                    </div>
                    <div class="chart-placeholder"></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>3,578</h3>
                        <p>Active Sessions</p>
                        <p class="change increase">+15.4%</p>
                    </div>
                    <div class="chart-placeholder"></div>
                </div>
            </div>
        </div>
        <div class="events-section">
            <h2>Top Events of The Week</h2>
            <div class="events-grid">
                <div class="event-card">
                    <div class="placeholder">Event 1</div>
                    <p>Event 1</p>
                </div>
                <div class="event-card">
                    <div class="placeholder">Event 2</div>
                    <p>Event 2</p>
                </div>
            </div>
        </div>
        <div class="table-section">
            <table>
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>User</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>12345</td>
                    <td>John Doe</td>
                    <td>2025-10-01</td>
                    <td class="status-confirmed">Confirmed</td>
                    <td class="actions">
                        <button class="edit">Edit</button>
                        <button class="view">View</button>
                        <button class="delete">Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>23456</td>
                    <td>Jane Smith</td>
                    <td>2025-11-01</td>
                    <td class="status-pending">Pending</td>
                    <td class="actions">
                        <button class="edit">Edit</button>
                        <button class="view">View</button>
                        <button class="delete">Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>34567</td>
                    <td>Alice Johnson</td>
                    <td>2024-12-01</td>
                    <td class="status-cancelled">Cancelled</td>
                    <td class="actions">
                        <button class="edit">Edit</button>
                        <button class="view">View</button>
                        <button class="delete">Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>45678</td>
                    <td>Robert Brown</td>
                    <td>2025-01-01</td>
                    <td class="status-confirmed">Confirmed</td>
                    <td class="actions">
                        <button class="edit">Edit</button>
                        <button class="view">View</button>
                        <button class="delete">Delete</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
