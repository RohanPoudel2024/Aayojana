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
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
    
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
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (events != null && !events.isEmpty()) {
                    for (Event event : events) { %>
                    <tr>
                        <td>#<%= event.getEventId() %></td>
                        <td><%= event.getTitle() %></td>
                        <td><%= event.getLocation() %></td>
                        <td><%= dateFormat.format(event.getDate()) %></td>
                        <td><%= event.getTime() %></td>
                        <td class="seats <%= event.getAvailableSeats() <= 10 ? "low-seats" : "" %>">
                            <%= event.getAvailableSeats() %>
                        </td>
                        <td class="price">NPR. <%= priceFormat.format(event.getPrice()) %></td>
                        <td>
                            <div class="event-actions">
                                <a href="${pageContext.request.contextPath}/admin/events?action=edit&id=<%= event.getEventId() %>" 
                                   class="btn-action btn-edit">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/events" method="post" 
                                      onsubmit="return confirm('Are you sure you want to delete this event?');" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= event.getEventId() %>">
                                    <button type="submit" class="btn-action btn-delete">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% }
                } else { %>
                    <tr>
                        <td colspan="8" style="text-align: center;">No events found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>        </div>
    </div>
</div>
</body>
</html>