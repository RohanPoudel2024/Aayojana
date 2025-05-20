<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    Event event = (Event) request.getAttribute("event");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Tickets - <%= event.getTitle() %></title>
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
            <a href="${pageContext.request.contextPath}/booking?action=list">My Bookings</a>
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
        <div class="booking-container">
            <h1>Book Tickets</h1>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <div class="event-summary">
                <h2><%= event.getTitle() %></h2>
                <p><i class="fas fa-calendar"></i> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>
                <p><i class="fas fa-ticket-alt"></i> Available Seats: <%= event.getAvailableSeats() %></p>
                <p><i class="fas fa-tag"></i> Price: 
                    <% if(event.getPrice() > 0) { %>
                        NPR <%= priceFormat.format(event.getPrice()) %> per seat
                    <% } else { %>
                        Free Entry
                    <% } %>
                </p>
            </div>
            
            <form action="${pageContext.request.contextPath}/booking" method="get">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                
                <div class="form-group">
                    <label for="seats">Number of Seats:</label>
                    <input type="number" id="seats" name="seats" min="1" max="<%= event.getAvailableSeats() %>" value="1" required>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Continue to Booking</button>
                </div>
            </form>
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