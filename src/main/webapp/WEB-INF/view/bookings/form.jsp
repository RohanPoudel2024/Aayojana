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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bookingForm.css">
</head>
<body>
<div class="container">
    <jsp:include page="../common/userHeader.jsp" />
    
    <div class="main-content">
        <div class="booking-container">
            <h1><i class="fas fa-ticket-alt"></i> Book Tickets</h1>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <div class="event-summary">
                <h2><%= event.getTitle() %></h2>
                <p><i class="fas fa-calendar-alt"></i> <%= dateFormat.format(event.getDate()) %></p>
                <p><i class="fas fa-clock"></i> <%= event.getTime() %></p>
                <p><i class="fas fa-map-marker-alt"></i> <%= event.getLocation() %></p>
                <p><i class="fas fa-chair"></i> Available Seats: <strong><%= event.getAvailableSeats() %></strong></p>
                <p><i class="fas fa-tag"></i> Price: 
                    <% if(event.getPrice() > 0) { %>
                        <strong>NPR <%= priceFormat.format(event.getPrice()) %></strong> per seat
                    <% } else { %>
                        <span class="free-badge">Free Entry</span>
                    <% } %>
                </p>
            </div>
              <form action="${pageContext.request.contextPath}/booking" method="get" id="bookingForm">
                <input type="hidden" name="action" value="confirm">                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                <input type="hidden" id="ticketPrice" value="<%= event.getPrice() %>">
                <input type="hidden" id="maxSeats" value="<%= event.getAvailableSeats() %>">>
                
                <div class="form-group">
                    <label for="seats"><i class="fas fa-users"></i> Number of Seats:</label>
                    <div class="seats-control">
                        <button type="button" id="decrementSeats" class="btn-control" aria-label="Decrease seats">
                            <i class="fas fa-minus"></i>
                        </button>
                        <input type="number" id="seats" name="seats" min="1" max="<%= event.getAvailableSeats() %>" value="1" required>
                        <button type="button" id="incrementSeats" class="btn-control" aria-label="Increase seats">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <small>Maximum <%= event.getAvailableSeats() %> seats available</small>
                </div>
                
                <% if(event.getPrice() > 0) { %>
                <div class="ticket-price-summary">
                    <div class="price-row">
                        <span>Ticket price:</span>
                        <span>NPR <%= priceFormat.format(event.getPrice()) %></span>
                    </div>
                    <div class="price-row">
                        <span>Number of seats:</span>
                        <span id="seatCount">1</span>
                    </div>
                    <div class="price-row price-total">
                        <span>Total price:</span>
                        <span id="totalPrice">NPR <%= priceFormat.format(event.getPrice()) %></span>
                    </div>
                </div>
                <% } %>
                
                <div class="ticket-preview">
                    <div class="ticket-preview-header">
                        <i class="fas fa-eye"></i> Ticket Preview
                    </div>
                    <div class="ticket-preview-content">
                        <div>
                            <strong><%= event.getTitle() %></strong><br>
                            <small><%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></small>
                        </div>
                        <div>
                            <span id="previewSeats">1</span> seat(s)
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>" class="btn btn-outline">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-shopping-cart"></i> Continue to Booking
                    </button>
                </div>
            </form>
        </div>
    </div>
      <jsp:include page="../common/userFooter.jsp" />
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const seatsInput = document.getElementById('seats');
        const seatCount = document.getElementById('seatCount');
        const previewSeats = document.getElementById('previewSeats');
        const totalPrice = document.getElementById('totalPrice');
        const decrementBtn = document.getElementById('decrementSeats');
        const incrementBtn = document.getElementById('incrementSeats');
        
        // Get values from hidden fields to avoid JSP expression issues
        const ticketPrice = parseFloat(document.getElementById('ticketPrice').value);
        const maxSeats = parseInt(document.getElementById('maxSeats').value);
        
        // Function to update displayed values
        function updateDisplayedValues() {
            const seats = parseInt(seatsInput.value) || 0;
            if (seatCount) seatCount.textContent = seats;
            if (previewSeats) previewSeats.textContent = seats;
            if (totalPrice) totalPrice.textContent = 'NPR ' + (seats * ticketPrice).toFixed(2);
        }
        
        // Add event listeners for manual input
        if (seatsInput) {
            seatsInput.addEventListener('input', updateDisplayedValues);
        }
        
        // Add event listeners for decrement/increment buttons
        if (decrementBtn) {
            decrementBtn.addEventListener('click', function() {
                const currentValue = parseInt(seatsInput.value) || 0;
                if (currentValue > 1) {
                    seatsInput.value = currentValue - 1;
                    updateDisplayedValues();
                }
            });
        }
        
        if (incrementBtn) {
            incrementBtn.addEventListener('click', function() {
                const currentValue = parseInt(seatsInput.value) || 0;
                if (currentValue < maxSeats) {
                    seatsInput.value = currentValue + 1;
                    updateDisplayedValues();
                }
            });
        }
    });
</script>
</body>
</html>