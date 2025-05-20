<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="model.Category" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    Event event = (Event) request.getAttribute("event");
    boolean isNewEvent = (event == null);
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat priceFormat = new DecimalFormat("#0.00");
    
    // Default values for the form
    String title = isNewEvent ? "" : event.getTitle();
    String location = isNewEvent ? "" : event.getLocation();
    String date = isNewEvent ? "" : (event.getDate() != null ? dateFormat.format(event.getDate()) : "");
    String time = isNewEvent ? "" : (event.getTime() != null ? event.getTime() : "");
    int availableSeats = isNewEvent ? 0 : event.getAvailableSeats();
    double price = isNewEvent ? 0 : event.getPrice();
%>
<!DOCTYPE html>
<html>
<head>    <meta charset="UTF-8">
    <title><%= isNewEvent ? "Create New Event" : "Edit Event" %> - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <style>
        .content-area {
            padding: 20px;
        }
        
        .page-title {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .form-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-group input[type="time"] {
            width: auto;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .btn-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-primary {
            background-color: #4a00e0;
            color: white;
        }
        
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
        }
        
        .btn-primary:hover {
            background-color: #3c00b3;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        
        .back-link {
            color: #666;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .back-link:hover {
            color: #4a00e0;
        }
        
        .required {
            color: #cc0000;
            margin-left: 3px;
        }
        
        .event-image-preview {
            width: 100%;
            max-width: 300px;
            margin-top: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .no-image {
            width: 100%;
            max-width: 300px;
            height: 150px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
            border-radius: 8px;
            color: #999;
            font-size: 14px;
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
                <h1><%= isNewEvent ? "Create New Event" : "Edit Event" %></h1>
                <a href="${pageContext.request.contextPath}/admin/events" class="back-link">
                    <span>←</span> Back to Events
                </a>
            </div>
            
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/events" method="post" id="eventForm" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="<%= isNewEvent ? "create" : "update" %>">
                    <% if (!isNewEvent) { %>
                        <input type="hidden" name="id" value="<%= event.getEventId() %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label for="title">Title<span class="required">*</span></label>
                        <input type="text" id="title" name="title" value="<%= title %>" required maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label for="location">Location<span class="required">*</span></label>
                        <input type="text" id="location" name="location" value="<%= location %>" required maxlength="100">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="date">Date<span class="required">*</span></label>
                            <input type="date" id="date" name="date" value="<%= date %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="time">Time<span class="required">*</span></label>
                            <input type="time" id="time" name="time" value="<%= time %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="availableSeats">Available Seats<span class="required">*</span></label>
                            <input type="number" id="availableSeats" name="availableSeats" value="<%= availableSeats %>" min="1" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Price (NPR. )<span class="required">*</span></label>
                            <input type="number" id="price" name="price" value="<%= price %>" min="0" step="0.01" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryId">Category<span class="required">*</span></label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">-- Select Category --</option>
                            <% 
                                // Get list of active categories from request attribute 
                                List<Category> categories = (List<Category>) request.getAttribute("categories");
                                if (categories != null) {
                                    for (Category cat : categories) {
                                        if (cat.isActive()) {
                                            boolean selected = !isNewEvent && event.getCategoryId() == cat.getCategoryId();
                            %>
                                            <option value="<%= cat.getCategoryId() %>" <%= selected ? "selected" : "" %>><%= cat.getName() %></option>
                            <%
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="eventImage">Event Image</label>
                        <input type="file" id="eventImage" name="eventImage" accept="image/*">
                        <p><small>Maximum file size: 5MB. Recommended formats: JPEG, PNG</small></p>
                        
                        <% if (!isNewEvent && event.hasImage()) { %>
                            <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                 alt="Event Image" class="event-image-preview">
                        <% } else { %>
                            <div class="no-image">No image uploaded</div>
                        <% } %>
                    </div>
                    
                    <div class="btn-group">
                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/admin/events'" class="btn btn-secondary">Cancel</button>
                        <button type="submit" class="btn btn-primary"><%= isNewEvent ? "Create Event" : "Save Changes" %></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('eventForm').addEventListener('submit', function(e) {
        const title = document.getElementById('title').value.trim();
        const location = document.getElementById('location').value.trim();
        const date = document.getElementById('date').value;
        const time = document.getElementById('time').value;
        const seats = document.getElementById('availableSeats').value;
        const price = document.getElementById('price').value;
        
        if (!title || !location || !date || !time || !seats || !price) {
            e.preventDefault();
            alert('Please fill all required fields.');
            return;
        }
        
        // Validate date (must be today or future)
        const selectedDate = new Date(date);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (selectedDate < today) {
            e.preventDefault();
            alert('Event date must be today or in the future.');
            return;
        }
        
        // Validate seats and price
        if (parseInt(seats) <= 0) {
            e.preventDefault();
            alert('Available seats must be greater than 0.');
            return;
        }
        
        if (parseFloat(price) < 0) {
            e.preventDefault();
            alert('Price cannot be negative.');
            return;
        }
        
        // Validate file size
        const fileInput = document.getElementById('eventImage');
        if (fileInput.files.length > 0) {
            if (fileInput.files[0].size > 5 * 1024 * 1024) { // 5MB
                e.preventDefault();
                alert('Image file size must be less than 5MB.');
                return;
            }
        }
    });
    
    // Preview image before upload
    document.getElementById('eventImage').addEventListener('change', function(e) {
        const fileInput = e.target;
        const preview = document.querySelector('.no-image') || document.querySelector('.event-image-preview');
        
        if (fileInput.files && fileInput.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                // If there was a no-image div, replace it with an img
                if (preview.classList.contains('no-image')) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'Event Image Preview';
                    img.className = 'event-image-preview';
                    preview.parentNode.replaceChild(img, preview);
                } else {
                    // Otherwise just update the img src
                    preview.src = e.target.result;
                }
            }
            
            reader.readAsDataURL(fileInput.files[0]);
        }
    });
</script>
</body>
</html>