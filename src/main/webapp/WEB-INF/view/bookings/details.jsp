<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    Booking booking = (Booking) request.getAttribute("booking");
    Event event = (Event) request.getAttribute("event");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Details - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/bookingTicket.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .booking-details-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 30px auto;
            max-width: 800px;
        }
        
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .booking-status {
            font-weight: bold;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .status-confirmed {
            background-color: #e1f7e9;
            color: #0f8a3a;
        }
        
        .status-cancelled {
            background-color: #ffebee;
            color: #d32f2f;
        }
        
        .event-details, .booking-info {
            margin-bottom: 30px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 15px;
        }
        
        .detail-label {
            flex: 1;
            font-weight: 600;
            color: #555;
        }
        
        .detail-value {
            flex: 2;
            color: #333;
        }
        
        .ticket-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 0 5px;
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
        
        .ticket-preview {
            border: 2px dashed #3498db;
            padding: 20px;
            margin-top: 30px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .ticket-preview h3 {
            text-align: center;
            color: #3498db;
            margin-bottom: 20px;
        }
        
        .qr-placeholder {
            width: 150px;
            height: 150px;
            margin: 20px auto;
            background-color: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #ddd;
        }
        
        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
            }
            
            .detail-label, .detail-value {
                flex: none;
            }
            
            .detail-label {
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="../common/userHeader.jsp" />
    <div class="main-content">
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="error-message">${errorMessage}</div>
        <% } %>
          <% if (booking != null && event != null) { %>
            <div class="booking-details-container">
                <div class="booking-header">
                    <h1>Booking #<%= booking.getBookingId() %></h1>
                    <span class="booking-status <%= booking.getStatus() != null && booking.getStatus().equals("CANCELLED") ? "status-cancelled" : "status-confirmed" %>">
                        <%= booking.getStatus() != null ? booking.getStatus() : "CONFIRMED" %>
                    </span>
                </div>
                
                <div class="event-details">
                    <h2><%= event.getTitle() %></h2>
                    <p><%= event.getDescription() %></p>
                </div>
                
                <div class="booking-info">
                    <h3>Event Details</h3>
                    <div class="detail-row">
                        <div class="detail-label">Event Date:</div>
                        <div class="detail-value"><%= dateFormat.format(event.getDate()) %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Event Time:</div>
                        <div class="detail-value"><%= event.getTime() %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Location:</div>
                        <div class="detail-value"><%= event.getLocation() %></div>
                    </div>
                    
                    <h3>Booking Details</h3>
                    <div class="detail-row">
                        <div class="detail-label">Booking Date:</div>
                        <div class="detail-value"><%= dateFormat.format(booking.getBookingDate()) %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Seats Booked:</div>
                        <div class="detail-value"><%= booking.getSeatsBooked() %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Price per Seat:</div>
                        <div class="detail-value">NPR <%= priceFormat.format(event.getPrice()) %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Total Price:</div>
                        <div class="detail-value"><strong>NPR <%= priceFormat.format(booking.getTotalPrice()) %></strong></div>
                    </div>
                </div>
                
                <% if (booking.getStatus() == null || !booking.getStatus().equals("CANCELLED")) { %>
                    <div class="ticket-container">
                        <div class="ticket-header">
                            <h1>Event Ticket</h1>
                            <h2>AayoJana</h2>
                            <div class="ticket-status ticket-status-confirmed">CONFIRMED</div>
                        </div>
                        
                        <div class="ticket-body">
                            <div class="ticket-event-title"><%= event.getTitle() %></div>
                            
                            <div class="ticket-details">
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">DATE</div>
                                    <div class="ticket-detail-value"><%= dateFormat.format(event.getDate()) %></div>
                                </div>
                                
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">TIME</div>
                                    <div class="ticket-detail-value"><%= event.getTime() %></div>
                                </div>
                                
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">VENUE</div>
                                    <div class="ticket-detail-value"><%= event.getLocation() %></div>
                                </div>
                                
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">BOOKING ID</div>
                                    <div class="ticket-detail-value">#<%= booking.getBookingId() %></div>
                                </div>
                                
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">SEATS</div>
                                    <div class="ticket-detail-value"><%= booking.getSeatsBooked() %></div>
                                </div>
                                
                                <div class="ticket-detail-item">
                                    <div class="ticket-detail-label">TOTAL PRICE</div>
                                    <div class="ticket-detail-value">NPR <%= priceFormat.format(booking.getTotalPrice()) %></div>
                                </div>
                            </div>
                            
                            <div class="ticket-qr">
                                QR Code<br>Will Appear Here
                            </div>
                        </div>
                        
                        <div class="ticket-footer">
                            <p>Please present this ticket at the venue. This ticket serves as proof of purchase.</p>
                            <div class="ticket-validation">Booking Date: <%= dateFormat.format(booking.getBookingDate()) %></div>
                        </div>
                    </div>
                <% } %>
                
                <div class="ticket-actions">
                    <a href="${pageContext.request.contextPath}/booking?action=list" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to My Bookings
                    </a>
                    
                    <% if (booking.getStatus() == null || !booking.getStatus().equals("CANCELLED")) { %>
                        <a href="${pageContext.request.contextPath}/booking?action=download-ticket&bookingId=<%= booking.getBookingId() %>" class="ticket-download-button">
                            <i class="fas fa-download"></i> Download Ticket
                        </a>
                        
                        <form action="${pageContext.request.contextPath}/booking" method="post" style="display: inline-block;" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                            <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/booking?action=list">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-times-circle"></i> Cancel Booking
                            </button>
                        </form>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <div class="error-message">
                <p>Booking not found or you don't have permission to view it.</p>
                <a href="${pageContext.request.contextPath}/booking?action=list" class="btn btn-primary">Back to My Bookings</a>
            </div>
        <% } %>
    </div>
    <jsp:include page="../common/userFooter.jsp" />
</div>
</body>
</html>
