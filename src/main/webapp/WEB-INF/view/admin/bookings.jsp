<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="service.BookingService" %>
<%@ page import="service.EventService" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    BookingService bookingService = new BookingService();
    List<Booking> allBookings = bookingService.getAllBookings();
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<User> users = (List<User>) request.getAttribute("users");

    String message = (String) request.getAttribute("message");
    String errorMessage = (String) request.getAttribute("errorMessage");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .bookings-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .bookings-table th,
        .bookings-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .bookings-table th {
            background-color: #f8fafc;
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .bookings-table tr:hover {
            background-color: #f8fafc;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-active {
            background-color: #dcfce7;
            color: #16a34a;
        }

        .status-cancelled {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .cancel-btn {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .cancel-btn:hover {
            background-color: #fecaca;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 0.375rem;
        }

        .alert-success {
            background-color: #dcfce7;
            color: #16a34a;
        }

        .alert-error {
            background-color: #fee2e2;
            color: #dc2626;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
        <div class="bookings-container">
            <h1>Manage Bookings</h1>

            <% if (message != null) { %>
            <div class="alert alert-success">
                <%= message %>
            </div>
            <% } %>

            <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <%= errorMessage %>
            </div>
            <% } %>

            <div class="booking-filters">
                <div class="search-box">
                    <input type="text" id="searchBookings" placeholder="Search bookings...">
                </div>
            </div>

            <table class="bookings-table">
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Event</th>
                    <th>User</th>
                    <th>Date</th>
                    <th>Seats</th>
                    <th>Total Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Booking booking : allBookings) {
                    Event event = events.stream()
                            .filter(e -> e.getEventId() == booking.getEventId())
                            .findFirst()
                            .orElse(null);

                    User user = users.stream()
                            .filter(u -> u.getUserId() == booking.getUserId())
                            .findFirst()
                            .orElse(null);

                    if (event != null && user != null) {
                %>
                <tr>
                    <td>#<%= booking.getBookingId() %></td>
                    <td><%= event.getTitle() %></td>
                    <td><%= user.getName() %></td>
                    <td><%= dateFormat.format(booking.getBookingDate()) %></td>                    <td><%= booking.getSeatsBooked() %></td>
                    <td>NPR. <%= priceFormat.format(booking.getTotalPrice()) %></td>
                    <td>
                        <% String status = booking.getStatus() != null ? booking.getStatus() : "CONFIRMED"; %>
                        <span class="status-badge <%= status.equals("CANCELLED") ? "status-cancelled" : "status-active" %>">
                            <%= status %>
                        </span>
                    </td>
                    <td>
                        <% if(!status.equals("CANCELLED")) { %>
                        <form action="${pageContext.request.contextPath}/admin/bookings" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                            <button type="submit" class="action-btn cancel-btn"
                                    onclick="return confirm('Are you sure you want to cancel this booking?')">
                                Cancel
                            </button>
                        </form>
                        <% } else { %>
                        <span class="action-btn" style="background-color: #f3f4f6; color: #6b7280;">Cancelled</span>
                        <% } %>
                    </td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    document.getElementById('searchBookings').addEventListener('input', function(e) {
        const searchValue = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('.bookings-table tbody tr');

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchValue) ? '' : 'none';
        });
    });
</script>
</body>
</html>