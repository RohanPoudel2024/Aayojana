<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="service.EventService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    
    // Get message from session, not request parameter
    String message = (String) session.getAttribute("message");
    // Clear the message from session after displaying it
    if (message != null) {
        session.removeAttribute("message");
    }
    
    EventService eventService = new EventService();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
</head>
<body>
<div class="container">
    <jsp:include page="../common/userHeader.jsp" />
    <div class="main-content">
        <div class="bookings-container">
            <h1>My Bookings</h1>
            
            <% if (message != null && !message.isEmpty()) { %>
                <div class="success-message">
                    <%= message %>
                </div>
            <% } %>
            
            <% if (bookings != null && !bookings.isEmpty()) { %>
                <div class="bookings-list">
                    <% for (Booking booking : bookings) { 
                        Event event = eventService.getEventById(booking.getEventId());
                        if (event != null) {
                    %>
                        <div class="booking-item">
                            <div class="booking-details">
                                <h2><%= event.getTitle() %></h2>
                                <p><i class="fas fa-calendar"></i> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                                <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>                                <p><i class="fas fa-ticket-alt"></i> Seats Booked: <%= booking.getSeatsBooked() %></p>
                                <p><i class="fas fa-receipt"></i> Total Price: NPR <%= priceFormat.format(booking.getTotalPrice()) %></p>
                                <p><i class="fas fa-clock"></i> Booked on: <%= dateFormat.format(booking.getBookingDate()) %></p>
                                <p><i class="fas fa-info-circle"></i> Status: 
                                    <span class="booking-status <%= booking.getStatus() != null && booking.getStatus().equals("CANCELLED") ? "status-cancelled" : "status-confirmed" %>">
                                        <%= booking.getStatus() != null ? booking.getStatus() : "CONFIRMED" %>
                                    </span>
                                </p>
                            </div>
                            <div class="booking-actions">
                                <a href="${pageContext.request.contextPath}/booking?action=view&bookingId=<%= booking.getBookingId() %>" class="btn btn-outline">View Details</a>
                                <% if(booking.getStatus() == null || !booking.getStatus().equals("CANCELLED")) { %>
                                <form action="${pageContext.request.contextPath}/booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel Booking</button>
                                </form>
                                <% } %>
                            </div>
                        </div>
                    <% 
                        }
                    } %>
                </div>
            <% } else { %>
                <div class="no-bookings">
                    <i class="fas fa-calendar-times"></i>
                    <p>You haven't made any bookings yet.</p>
                    <a href="${pageContext.request.contextPath}/EventsServlet" class="btn btn-primary">Explore Events</a>
                </div>
            <% } %>
        </div>
    </div>    
    <jsp:include page="../common/userFooter.jsp" />
</div>
</body>
</html>