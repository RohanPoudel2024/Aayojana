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
    String message = request.getParameter("message");
    
    EventService eventService = new EventService();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/EventsServlet">Explore</a>
            <a href="#">Upcoming Events</a>
            <a href="${pageContext.request.contextPath}/booking?action=list" class="active">My Bookings</a>
        </div>
        <div class="user">
            <% if (currentUser != null) { %>
            <a href="${pageContext.request.contextPath}/profile" class="user-profile">
                <span class="username"><%= currentUser.getName() %></span>
                <span class="icon"><i class="fas fa-user"></i></span>
            </a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/login" class="login-btn">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="signup-btn">Sign Up</a>
            <% } %>
        </div>
    </div>
    
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
                                <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>
                                <p><i class="fas fa-ticket-alt"></i> Seats Booked: <%= booking.getSeatsBooked() %></p>
                                <p><i class="fas fa-receipt"></i> Total Price: NPR <%= priceFormat.format(booking.getTotalPrice()) %></p>
                                <p><i class="fas fa-clock"></i> Booked on: <%= dateFormat.format(booking.getBookingDate()) %></p>
                            </div>
                            <div class="booking-actions">
                                <a href="${pageContext.request.contextPath}/booking?action=view&bookingId=<%= booking.getBookingId() %>" class="btn btn-outline">View Details</a>
                                <form action="${pageContext.request.contextPath}/booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel Booking</button>
                                </form>
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
    
    <div class="footer">
        <div class="footer-column">
            <div class="logo">AYO-JANA</div>
            <p>Your premier platform for discovering and booking the best events in town.</p>
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
            </div>
        </div>
        <div class="footer-column">
            <h4>Resources</h4>
            <a href="#">User guides</a>
            <a href="#">Help Center</a>
            <a href="#">Partners</a>
        </div>
        <div class="footer-column">
            <h4>Company</h4>
            <a href="#">About</a>
            <a href="#">Contact Us</a>
            <a href="#">Careers</a>
        </div>
    </div>
</div>
</body>
</html>