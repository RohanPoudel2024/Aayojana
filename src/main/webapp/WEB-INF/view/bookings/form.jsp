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
</head>
<body>
<div class="container">
    <jsp:include page="../common/userHeader.jsp" />
    
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
        </div>    </div>
    
    <jsp:include page="../common/userFooter.jsp" />
</div>
</body>
</html>