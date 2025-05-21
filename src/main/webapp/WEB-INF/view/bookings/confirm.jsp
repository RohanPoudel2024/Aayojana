<!-- filepath: c:\Users\Rohan\Aayojana\src\main\webapp\WEB-INF\view\bookings\confirm.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    Event event = (Event) request.getAttribute("event");
    int seats = (Integer) request.getAttribute("seats");
    double totalPrice = (Double) request.getAttribute("totalPrice");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Booking - <%= event.getTitle() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
    <style>
        .booking-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .booking-card {
            background-color: var(--surface);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(0, 0, 0, 0.04);
        }
        
        .event-header {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #edf2f7;
        }
        
        .event-image {
            width: 160px;
            height: 160px;
            border-radius: var(--border-radius-md);
            object-fit: cover;
            flex-shrink: 0;
        }
        
        .event-info h2 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }
        
        .event-info p {
            color: #718096;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }
        
        .event-info p i {
            color: var(--primary-color);
            margin-right: 0.5rem;
            width: 20px;
        }
        
        .booking-summary {
            margin-top: 2rem;
            background-color: #f7fafc;
            border-radius: var(--border-radius-md);
            padding: 1.5rem;
        }
        
        .booking-summary h3 {
            margin-bottom: 1rem;
            font-size: 1.2rem;
            color: var(--on-surface);
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #edf2f7;
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-row .label {
            color: #718096;
        }
        
        .summary-row .value {
            font-weight: 600;
        }
        
        .summary-row.total {
            margin-top: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid #cbd5e0;
            font-size: 1.1rem;
        }
        
        .summary-row.total .label,
        .summary-row.total .value {
            font-weight: 700;
            color: var(--on-surface);
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 2rem;
        }
        
        .confirm-notice {
            margin-top: 1.5rem;
            padding: 1rem;
            background-color: #ebf8ff;
            border-left: 4px solid #4299e1;
            border-radius: var(--border-radius-sm);
        }
        
        .confirm-notice p {
            color: #2b6cb0;
            margin: 0;
        }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="../common/userHeader.jsp" />
    
    <div class="main-content">
        <div class="booking-container">
            <h1>Confirm Booking</h1>
            
            <div class="booking-card">
                <div class="event-header">
                    <% if (event.hasImage()) { %>
                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                             alt="<%= event.getTitle() %>" class="event-image">
                    <% } else { %>
                        <div class="image-placeholder event-image">
                            <i class="fas fa-images"></i>
                        </div>
                    <% } %>
                    <div class="event-info">
                        <h2><%= event.getTitle() %></h2>
                        <p><i class="fas fa-calendar"></i> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                        <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>
                    </div>
                </div>
                
                <div class="booking-summary">
                    <h3>Booking Summary</h3>
                    <div class="summary-row">
                        <span class="label">Event</span>
                        <span class="value"><%= event.getTitle() %></span>
                    </div>
                    <div class="summary-row">
                        <span class="label">Date & Time</span>
                        <span class="value"><%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></span>
                    </div>
                    <div class="summary-row">
                        <span class="label">Number of Seats</span>
                        <span class="value"><%= seats %></span>
                    </div>
                    <% if (event.getPrice() > 0) { %>
                        <div class="summary-row">
                            <span class="label">Price per Seat</span>
                            <span class="value">NPR <%= priceFormat.format(event.getPrice()) %></span>
                        </div>
                        <div class="summary-row total">
                            <span class="label">Total Price</span>
                            <span class="value">NPR <%= priceFormat.format(totalPrice) %></span>
                        </div>
                    <% } else { %>
                        <div class="summary-row total">
                            <span class="label">Total Price</span>
                            <span class="value">Free</span>
                        </div>
                    <% } %>
                </div>
                  <div class="confirm-notice">
                    <p><i class="fas fa-info-circle"></i> By confirming this booking, you agree to our terms and conditions.</p>
                </div>
                
                <form action="${pageContext.request.contextPath}/booking" method="post">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="seats" value="<%= seats %>">
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/booking?eventId=<%= event.getEventId() %>" class="btn btn-outline">Back</a>
                        <button type="submit" class="btn btn-primary">Confirm Booking</button>
                    </div>
                </form>            </div>
        </div>
    </div>
    
    <jsp:include page="../common/userFooter.jsp" />
</div>
</body>
</html>