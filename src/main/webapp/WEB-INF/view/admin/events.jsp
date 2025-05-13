<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Event> events = (List<Event>) request.getAttribute("events");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after displaying them
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Event Management - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .content-area {
            padding: 20px;
        }
        
        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .btn-add {
            background-color: #4a00e0;
            color: white;
            padding: 10px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-add:hover {
            background-color: #3c00b3;
        }
        
        .message {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 5px;
            overflow: hidden;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        th {
            background-color: #f8f8f8;
            font-weight: 600;
            color: #333;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .event-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-action {
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-edit {
            background-color: #f0f8ff;
            color: #0066cc;
        }
        
        .btn-delete {
            background-color: #fff0f0;
            color: #cc0000;
        }
        
        .price {
            color: #4a00e0;
            font-weight: 600;
        }
        
        .seats {
            font-weight: 600;
        }
        
        .low-seats {
            color: #cc0000;
        }
        
        .event-image {
            max-width: 100px;
            max-height: 100px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .image-placeholder {
            font-size: 12px;
            color: #999;
            text-align: center;
            border: 1px dashed #ccc;
            padding: 10px;
            border-radius: 5px;
            max-width: 100px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard"><span class="icon">📊</span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"><span class="icon">👥</span>Users</a>
        <a href="${pageContext.request.contextPath}/admin/events" class="active"><span class="icon">🎉</span>Events</a>
        <a href="#"><span class="icon">📋</span>Bookings</a>
        <a href="#"><span class="icon">⚙️</span>Settings</a>
        <div class="user-account">
            <a href="${pageContext.request.contextPath}/profile"><span class="icon">👤</span>User Account</a>
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
                <a href="${pageContext.request.contextPath}/Dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                <a href="${pageContext.request.contextPath}/admin/events" class="active">Events</a>
            </div>
            <div class="user">
                <% if (currentUser != null) { %>
                <span><%= currentUser.getName() %></span>
                <span class="icon">👤</span>
                <% } %>
            </div>
        </div>
        
        <div class="content-area">
            <div class="page-title">
                <h1>Event Management</h1>
                <a href="${pageContext.request.contextPath}/admin/events?action=new" class="btn-add">
                    <span style="margin-right: 5px;">+</span> Add New Event
                </a>
            </div>
            
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="message success-message">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="message error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Available Seats</th>
                        <th>Price</th>
                        <th>Image</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (events != null && !events.isEmpty()) { %>
                        <% for (Event event : events) { %>
                            <tr>
                                <td><%= event.getEventId() %></td>
                                <td><%= event.getTitle() %></td>
                                <td><%= event.getLocation() %></td>
                                <td><%= event.getDate() != null ? dateFormat.format(event.getDate()) : "-" %></td>
                                <td><%= event.getTime() != null ? event.getTime() : "-" %></td>
                                <td class="seats <%= event.getAvailableSeats() < 10 ? "low-seats" : "" %>">
                                    <%= event.getAvailableSeats() %>
                                </td>
                                <td class="price">NPR. <%= priceFormat.format(event.getPrice()) %></td>
                                <td>
                                    <% if (event.hasImage()) { %>
                                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                             alt="<%= event.getTitle() %>" class="event-image">
                                    <% } else { %>
                                        <div class="image-placeholder">No Image Available</div>
                                    <% } %>
                                </td>
                                <td class="event-actions">
                                    <a href="${pageContext.request.contextPath}/admin/events?action=edit&id=<%= event.getEventId() %>" class="btn-action btn-edit">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/events?action=delete&id=<%= event.getEventId() %>" 
                                       onclick="return confirm('Are you sure you want to delete this event?')" 
                                       class="btn-action btn-delete">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 30px;">No events found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>