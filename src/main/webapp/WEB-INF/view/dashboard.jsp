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
    </style>
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