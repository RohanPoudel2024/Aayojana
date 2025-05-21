<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="model.Category" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventForm.css">

</head>
<body>
<div class="container">
    <!-- Include the admin sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include the admin header -->
        <jsp:include page="../common/adminHeader.jsp" />
        
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
                                if (categories != null) {                                    for (Category cat : categories) {
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