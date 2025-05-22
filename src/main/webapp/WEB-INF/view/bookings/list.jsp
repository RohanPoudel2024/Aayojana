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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .bookings-container {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .success-message {
            background-color: #e1f7e9;
            color: #0f8a3a;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }
        
        .bookings-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .booking-item {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .booking-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .booking-image {
            height: 180px;
            background-color: #f5f5f5;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        
        .booking-status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 12px;
            text-transform: uppercase;
        }
        
        .status-confirmed {
            background-color: #e1f7e9;
            color: #0f8a3a;
        }
        
        .status-cancelled {
            background-color: #ffebee;
            color: #d32f2f;
        }
        
        .booking-details {
            padding: 20px;
        }
        
        .booking-details h2 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.3rem;
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .booking-details p {
            margin: 8px 0;
            color: #555;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
        }
        
        .booking-details p i {
            margin-right: 8px;
            width: 16px;
            color: #3498db;
        }
        
        .booking-price {
            font-weight: bold;
            color: #333;
            font-size: 1.1rem;
            margin-top: 15px;
        }
        
        .booking-actions {
            padding: 15px 20px;
            background-color: #f9f9f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-outline {
            background-color: transparent;
            color: #3498db;
            border: 2px solid #3498db;
        }
        
        .btn-outline:hover {
            background-color: #ecf0f1;
        }
        
        .btn-danger {
            background-color: #e74c3c;
            color: white;
            border: none;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
        }
        
        .no-bookings {
            text-align: center;
            padding: 60px 20px;
            background-color: #f9f9f9;
            border-radius: 10px;
            margin-top: 30px;
        }
        
        .no-bookings i {
            font-size: 60px;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        
        .no-bookings p {
            font-size: 1.2rem;
            color: #7f8c8d;
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .bookings-list {
                grid-template-columns: 1fr;
            }
            
            .booking-actions {
                flex-direction: column;
                gap: 10px;
            }
            
            .booking-actions form {
                width: 100%;
            }
            
            .booking-actions .btn {
                width: 100%;
                box-sizing: border-box;
            }
        }
    </style>
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
                            <div class="booking-image" style="background-image: url('${pageContext.request.contextPath}/EventImageServlet?eventId=<%= event.getEventId() %>&timestamp=<%= System.currentTimeMillis() %>')">
                                <div class="booking-status-badge <%= booking.getStatus() != null && booking.getStatus().equals("CANCELLED") ? "status-cancelled" : "status-confirmed" %>">
                                    <%= booking.getStatus() != null ? booking.getStatus() : "CONFIRMED" %>
                                </div>
                            </div>
                            <div class="booking-details">
                                <h2><%= event.getTitle() %></h2>
                                <p><i class="fas fa-calendar"></i> <%= dateFormat.format(event.getDate()) %></p>
                                <p><i class="fas fa-clock"></i> <%= event.getTime() %></p>
                                <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>
                                <p><i class="fas fa-ticket-alt"></i> <%= booking.getSeatsBooked() %> Seat(s)</p>
                                <div class="booking-price">
                                    <i class="fas fa-receipt"></i> NPR <%= priceFormat.format(booking.getTotalPrice()) %>
                                </div>
                            </div>
                            <div class="booking-actions">
                                <a href="${pageContext.request.contextPath}/booking?action=view&bookingId=<%= booking.getBookingId() %>" class="btn btn-outline">View Details</a>
                                <% if(booking.getStatus() == null || !booking.getStatus().equals("CANCELLED")) { %>
                                <form action="${pageContext.request.contextPath}/booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel</button>
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