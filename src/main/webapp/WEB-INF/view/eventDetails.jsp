<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    Event event = (Event) request.getAttribute("event");
    Category category = (Category) request.getAttribute("category");
    List<Event> similarEvents = (List<Event>) request.getAttribute("similarEvents");
    
    // Format dates and prices
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    
    // Check if event exists
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/EventsServlet");
        return;
    }
%>

<html>
<head>
    <title><%= event.getTitle() %> - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventDetails.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/EventsServlet" class="active">Explore</a>
            <a href="${pageContext.request.contextPath}/events/upcoming">Upcoming Events</a>
            <a href="#">My Events</a>
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
    
    <div class="hero-section">
        <div class="event-card">
            <div class="date"><%= dateFormat.format(event.getDate()) %></div>
            <h1><%= event.getTitle() %></h1>
            <p><%= event.getDescription() != null ? event.getDescription() : "Join us for this amazing event!" %></p>
            <div class="event-actions">
                <div class="like"><i class="far fa-heart"></i> <span class="like-count">0</span></div>
                <div class="share"><i class="fas fa-share-alt"></i> <span class="share-count">0</span></div>
            </div>
        </div>
    </div>
    
    <div class="main-content">
        <div class="section timing-location">
            <h2>Timing and location</h2>
            <div class="info-card">
                <h3>Date and Time</h3>
                <p><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %></p>
                <p><span class="icon"><i class="fas fa-clock"></i></span> <%= event.getTime() %></p>
            </div>
            <div class="info-card">
                <h3>Place</h3>
                <p><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
            </div>
            <div class="price-card">
                <% if(event.getPrice() > 0) { %>
                    <div class="discount">20% OFF</div>
                    <p>NPR. <%= priceFormat.format(event.getPrice()) %> Ticket</p>
                <% } else { %>
                    <div class="free-tag">FREE</div>
                    <p>Free Entry</p>
                <% } %>
                <% if(currentUser != null) { %>
                    <a href="${pageContext.request.contextPath}/booking?eventId=<%= event.getEventId() %>" class="btn btn-primary">Book Ticket</a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login?redirect=events/details?id=<%= event.getEventId() %>" class="btn btn-primary">Login to Book</a>
                <% } %>
            </div>
        </div>
        
        <div class="section about-event">
            <h2>About event</h2>
            <div class="about-details">
                <p><%= event.getDescription() != null ? event.getDescription() : "Join us for this amazing event that promises an unforgettable experience!" %></p>
                <% if(event.getDescription() != null && event.getDescription().length() > 200) { %>
                    <a href="#" class="read-more" onclick="toggleDescription(event)">Read more</a>
                <% } %>
            </div>
            <div class="about-stats">
                <div class="stat">
                    <div class="icon"><i class="fas fa-hourglass"></i></div>
                    <p>Duration</p>
                    <p>2 Hours</p>
                </div>
                <div class="stat">
                    <div class="icon"><i class="fas fa-ticket-alt"></i></div>
                    <p>Ticket</p>
                    <p>E-ticket</p>
                </div>
            </div>
        </div>
        
        <% if(event.hasImage()) { %>
        <div class="section event-album">
            <h2>Event Gallery</h2>
            <div class="album-images">
                <div class="album-image">
                    <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                         alt="<%= event.getTitle() %>">
                </div>
            </div>
        </div>
        <% } %>
        
        <div class="section similar-events">
            <h2>Similar Events</h2>
            <div class="events-grid">
                <% if(similarEvents != null && !similarEvents.isEmpty()) { 
                     for(Event similarEvent : similarEvents) { %>
                    <div class="event-item">
                        <a href="${pageContext.request.contextPath}/events/details?id=<%= similarEvent.getEventId() %>">
                            <% if(similarEvent.hasImage()) { %>
                                <div class="image-wrapper">
                                    <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= similarEvent.getEventId() %>" 
                                         alt="<%= similarEvent.getTitle() %>" class="event-image">
                                </div>
                            <% } else { %>
                                <div class="image-placeholder">
                                    <i class="fas fa-images"></i>
                                    <span>No Image</span>
                                </div>
                            <% } %>
                            <h3><%= similarEvent.getTitle() %></h3>
                            <p><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(similarEvent.getDate()) %> | <%= similarEvent.getTime() %></p>
                            <p><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= similarEvent.getLocation() %></p>
                            <p class="price">From NPR. <%= priceFormat.format(similarEvent.getPrice()) %></p>
                        </a>
                    </div>
                <% } 
                } else { %>
                    <div class="no-events">
                        <i class="fas fa-calendar-times"></i>
                        No similar events available
                    </div>
                <% } %>
            </div>
            <div class="view-more">
                <a href="${pageContext.request.contextPath}/EventsServlet?category=<%= category.getCategoryId() %>">
                    View more events <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <div class="footer-column">
            <div class="logo">AYO-JANA</div>
            <p>Your premier platform for discovering and booking the best events in town.</p>
        </div>
        <div class="footer-column">
            <h4>Categories</h4>
            <a href="${pageContext.request.contextPath}/EventsServlet">All</a>
            <a href="${pageContext.request.contextPath}/EventsServlet?category=1">Music</a>
            <a href="${pageContext.request.contextPath}/EventsServlet?category=2">Sport</a>
            <a href="${pageContext.request.contextPath}/EventsServlet?category=3">Exhibition</a>
            <a href="${pageContext.request.contextPath}/EventsServlet?category=4">Business</a>
            <a href="${pageContext.request.contextPath}/EventsServlet?category=5">Photography</a>
        </div>
        <div class="footer-column">
            <h4>Resources</h4>
            <a href="#">User guides</a>
            <a href="#">Help Center</a>
            <a href="#">Partners</a>
            <a href="#">Taxes</a>
        </div>
        <div class="footer-column">
            <h4>Company</h4>
            <a href="#">About</a>
        </div>
        <div class="footer-column">
            <h4>Stay in the loop</h4>
            <p>For Event announcements and exclusive insights</p>
            <div class="subscribe">
                <input type="email" placeholder="Input your email">
                <button>Subscribe</button>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2025 AYO-JANA, Inc. • Privacy • Terms • Sitemap</p>
        <div class="social-icons">
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-youtube"></i></a>
        </div>
    </div>
</div>

<script>
    // Toggle like button
    document.querySelector('.like').addEventListener('click', function() {
        this.classList.toggle('active');
        const icon = this.querySelector('i');
        if (this.classList.contains('active')) {
            icon.classList.replace('far', 'fas');
            this.querySelector('.like-count').textContent = parseInt(this.querySelector('.like-count').textContent) + 1;
        } else {
            icon.classList.replace('fas', 'far');
            this.querySelector('.like-count').textContent = parseInt(this.querySelector('.like-count').textContent) - 1;
        }
    });
    
    // Toggle description for read more
    function toggleDescription(e) {
        e.preventDefault();
        const aboutDetails = document.querySelector('.about-details');
        aboutDetails.classList.toggle('expanded');
        
        const readMoreBtn = document.querySelector('.read-more');
        if (aboutDetails.classList.contains('expanded')) {
            readMoreBtn.textContent = 'Read less';
        } else {
            readMoreBtn.textContent = 'Read more';
        }
    }
</script>
</body>
</html>