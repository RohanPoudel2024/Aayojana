<!-- filepath: c:\Users\Rohan\Aayojana\src\main\webapp\WEB-INF\view\eventList.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Map" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Event> newEvents = (List<Event>) request.getAttribute("newEvents");
    List<Event> upcomingEvents = (List<Event>) request.getAttribute("upcomingEvents");
    List<Event> moreEvents = (List<Event>) request.getAttribute("moreEvents");
    Event highlightEvent = (Event) request.getAttribute("highlightEvent");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Event> filteredEvents = (List<Event>) request.getAttribute("filteredEvents");
    Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    
    // Helper variable for no events message
    String noEventsMessage = "<div class=\"no-events\"><i class=\"fas fa-calendar-times\"></i>No events available</div>";
%>
<html>
<head>
    <title>Search Events - AayoJana</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
    <style>
        /* Enhanced styling for event cards */
        .event-item {
            position: relative;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }
        
        .event-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            
            height: 100%;
            background: linear-gradient(135deg, rgba(74, 0, 224, 0.1), rgba(142, 45, 226, 0.1));
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
            border-radius: 16px;
        }
        
        .event-item:hover::before {
            opacity: 1;
        }
        
        .event-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(74, 0, 224, 0.15);
        }
        
        /* Shiny button effect */
        .search-actions button, .highlight-event button {
            position: relative;
            overflow: hidden;
        }
        
        .search-actions button::after, .highlight-event button::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.13), transparent);
            transform: rotate(45deg);
            transition: transform 0.6s;
        }
        
        .search-actions button:hover::after, .highlight-event button:hover::after {
            transform: rotate(45deg) translateX(100%) translateY(-100%);
        }
        
        /* Enhanced category items */
        .category-item .icon {
            position: relative;
            transition: transform 0.3s;
        }
        
        .category-item:hover .icon {
            transform: rotate(5deg) scale(1.1);
        }
        
        .category-item .icon i {
            font-size: 32px;
            background: linear-gradient(135deg, #4a00e0, #8e2de2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            transition: all 0.3s;
        }
        
        .category-item:hover .icon i {
            filter: brightness(1.2);
        }
        
        /* Price tag styling */
        .event-item p:last-child {
            background: linear-gradient(135deg, #f0e6ff, #eff6ff);
            padding: 8px 12px;
            border-radius: 8px;
            margin-top: 15px;
            text-align: center;
            font-weight: 700;
        }
        
        /* Improved hero section */
        .hero-section {
            background-image: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.7)), 
                url('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&q=80&w=1200');
            background-size: cover;
            background-position: center;
            position: relative;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at center, rgba(74, 0, 224, 0.4), transparent);
            pointer-events: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/EventsServlet" class="active">Explore</a>
            <a href="#">Upcoming Events</a>
            <a href="#">Popular</a>
        </div>
        <%
            if (currentUser != null) {
        %>
        <div class="user-actions">
            <a href="${pageContext.request.contextPath}/profile" class="user-profile">
                <span class="username"><%= currentUser.getName() %></span>
                <span class="icon"><i class="fas fa-user"></i></span>
            </a>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
        <%
        } else {
        %>
        <div class="auth-links">
            <a href="${pageContext.request.contextPath}/login" class="sign-in">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="sign-up">Sign Up</a>
        </div>
        <%
            }
        %>
    </div>
    
    <div class="hero-section">
        <div class="hero-content">
            <h1>Discover Amazing Events</h1>
            <h2>Find Your Next Experience & Create Memories</h2>
            <form action="${pageContext.request.contextPath}/EventsServlet" method="get" class="search-form">
                <div class="search-inputs">
                    <input type="text" name="keyword" placeholder="Search events by name, location or category...">
                    <div class="search-actions">
                        <button type="submit"><i class="fas fa-search"></i> Find Events</button>
                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/EventsServlet'">
                            <i class="fas fa-th-large"></i> Browse All
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <div class="main-content">
        <!-- Display filtered events if a category is selected -->
        <% if (filteredEvents != null && selectedCategoryId != null) { 
            String categoryName = "";
            for (Category cat : categories) {
                if (cat.getCategoryId() == selectedCategoryId) {
                    categoryName = cat.getName();
                    break;
                }
            }
        %>
            <div class="section">
                <h2><%= categoryName.toUpperCase() %> EVENTS</h2>
                <a href="${pageContext.request.contextPath}/EventsServlet" class="clear-filter">× Clear filter</a>
                <div class="events-grid">
                    <% if (filteredEvents.isEmpty()) { %>
                        <%= noEventsMessage %>
                    <% } else { 
                        for (Event event : filteredEvents) { 
                    %>
                        <div class="event-item">
                            <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>">
                                <% if (event.hasImage()) { %>
                                    <div class="image-wrapper">
                                        <div class="loading-overlay">
                                            <i class="fas fa-circle-notch fa-spin"></i>
                                        </div>
                                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                             alt="<%= event.getTitle() %>" class="event-image"
                                             onload="this.parentNode.classList.add('loaded')">
                                    </div>
                                <% } else { %>
                                    <div class="image-placeholder">
                                        <i class="fas fa-images"></i>
                                        <span>No Image Available</span>
                                    </div>
                                <% } %>
                                <div class="like"><i class="far fa-heart"></i></div>
                                <h3><%= event.getTitle() %></h3>
                                <p class="event-info"><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                                <p class="event-info"><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
                                <p class="event-price <%= event.getPrice() <= 0 ? "free" : "" %>">
                                    <% if(event.getPrice() > 0) { %>
                                        From $<%= priceFormat.format(event.getPrice()) %>
                                        <span class="event-tag">Paid</span>
                                    <% } else { %>
                                        Free entry
                                        <span class="event-tag">Free</span>
                                    <% } %>
                                </p>
                            </a>
                        </div>
                    <% 
                        }
                    } %>
                </div>
            </div>
        <% } else { %>
            <!-- Regular event display when no category is selected -->
            <div class="section">
                <h2>NEW EVENTS</h2>
                <div class="events-grid">
                    <% if (newEvents == null || newEvents.isEmpty()) { %>
                        <%= noEventsMessage %>
                    <% } else { 
                        for (Event event : newEvents) { 
                    %>
                        <div class="event-item">
                            <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>">
                                <% if (event.hasImage()) { %>
                                    <div class="image-wrapper">
                                        <div class="loading-overlay">
                                            <i class="fas fa-circle-notch fa-spin"></i>
                                        </div>
                                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                             alt="<%= event.getTitle() %>" class="event-image"
                                             onload="this.parentNode.classList.add('loaded')">
                                    </div>
                                <% } else { %>
                                    <div class="image-placeholder">
                                        <i class="fas fa-images"></i>
                                        <span>No Image Available</span>
                                    </div>
                                <% } %>
                                <div class="like"><i class="far fa-heart"></i></div>
                                <h3><%= event.getTitle() %></h3>
                                <p class="event-info"><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                                <p class="event-info"><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
                                <p class="event-price <%= event.getPrice() <= 0 ? "free" : "" %>">
                                    <% if(event.getPrice() > 0) { %>
                                        From $<%= priceFormat.format(event.getPrice()) %>
                                        <span class="event-tag">Paid</span>
                                    <% } else { %>
                                        Free entry
                                        <span class="event-tag">Free</span>
                                    <% } %>
                                </p>
                            </a>
                        </div>
                    <% 
                        }
                    } %>
                </div>
            </div>

            <div class="section">
                <h2>EXPLORE BY CATEGORY</h2>
                <div class="category-grid">
                    <% if (categories == null || categories.isEmpty()) { %>
                        <div>No categories available</div>
                    <% } else { 
                        for (Category category : categories) { 
                            if (category.isActive()) {
                    %>
                        <a href="${pageContext.request.contextPath}/EventsServlet?category=<%= category.getCategoryId() %>" 
                           class="category-item <%= (selectedCategoryId != null && selectedCategoryId == category.getCategoryId()) ? "active" : "" %>">
                            <div class="icon">
                                <% String categoryClass = "fa-theater-masks"; // default icon
                                   if (category.getName() != null) {
                                       String catName = category.getName().toLowerCase();
                                       if (catName.equals("music")) categoryClass = "fa-music";
                                       else if (catName.equals("sport")) categoryClass = "fa-basketball-ball";
                                       else if (catName.equals("exhibition")) categoryClass = "fa-palette";
                                       else if (catName.equals("business")) categoryClass = "fa-briefcase";
                                       else if (catName.equals("photography")) categoryClass = "fa-camera";
                                   }
                                %>
                                <i class="fas <%= categoryClass %>"></i>
                            </div>
                            <p><%= category.getName().toUpperCase() %></p>
                            <div class="event-count">
                                <% 
                                int count = 0;
                                if (filteredEvents != null && selectedCategoryId != null && selectedCategoryId == category.getCategoryId()) {
                                    count = filteredEvents.size();
                                } else {
                                    // Estimate count - this would ideally come from your backend
                                    count = 4 + (int)(Math.random() * 15);
                                }
                                %>
                                <%= count %> events
                            </div>
                        </a>
                    <% 
                            }
                        }
                    } %>
                </div>
            </div>

            <div class="section">
                <h2>UPCOMING EVENTS</h2>
                <div class="events-grid">
                    <% if (upcomingEvents == null || upcomingEvents.isEmpty()) { %>
                        <%= noEventsMessage %>
                    <% } else { 
                        for (Event event : upcomingEvents) { 
                    %>
                        <div class="event-item">
                            <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>">
                                <% if (event.hasImage()) { %>
                                    <div class="image-wrapper">
                                        <div class="loading-overlay">
                                            <i class="fas fa-circle-notch fa-spin"></i>
                                        </div>
                                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                             alt="<%= event.getTitle() %>" class="event-image"
                                             onload="this.parentNode.classList.add('loaded')">
                                    </div>
                                <% } else { %>
                                    <div class="image-placeholder">
                                        <i class="fas fa-images"></i>
                                        <span>No Image Available</span>
                                    </div>
                                <% } %>
                                <div class="like"><i class="far fa-heart"></i></div>
                                <h3><%= event.getTitle() %></h3>
                                <p class="event-info"><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                                <p class="event-info"><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
                                <p class="event-price <%= event.getPrice() <= 0 ? "free" : "" %>">
                                    <% if(event.getPrice() > 0) { %>
                                        From $<%= priceFormat.format(event.getPrice()) %>
                                        <span class="event-tag">Paid</span>
                                    <% } else { %>
                                        Free entry
                                        <span class="event-tag">Free</span>
                                    <% } %>
                                </p>
                            </a>
                        </div>
                    <% 
                        }
                    } %>
                </div>
                <div class="view-more">
                    <a href="${pageContext.request.contextPath}/events/upcoming">
                        View more events <i class="fas fa-chevron-right"></i>
                    </a>
                </div>
            </div>

            <% if (highlightEvent != null) { %>
            <div class="section">
                <h2>HIGHLIGHT EVENT THIS WEEK</h2>
                <div class="highlight-event">
                    <div class="highlight-event-image">
                        <% if (highlightEvent.hasImage()) { %>
                            <div class="loading-overlay">
                                <i class="fas fa-circle-notch fa-spin"></i>
                            </div>
                            <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= highlightEvent.getEventId() %>" 
                                alt="<%= highlightEvent.getTitle() %>"
                                onload="this.parentNode.querySelector('.loading-overlay').style.opacity = '0'">
                        <% } else { %>
                            <div class="image-placeholder">
                                <i class="fas fa-images"></i>
                                <span>No Image Available</span>
                            </div>
                        <% } %>
                    </div>
                    <div class="details">
                        <span class="event-tag">Featured Event</span>
                        <h3><%= highlightEvent.getTitle() %></h3>
                        <p class="event-info"><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(highlightEvent.getDate()) %> | <%= highlightEvent.getTime() %></p>
                        <p class="event-info"><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= highlightEvent.getLocation() %></p>
                        <div class="event-price <%= highlightEvent.getPrice() <= 0 ? "free" : "" %>">
                            <% if(highlightEvent.getPrice() > 0) { %>
                                From $<%= priceFormat.format(highlightEvent.getPrice()) %>
                            <% } else { %>
                                Free entry
                            <% } %>
                        </div>
                        <div class="book-button">
                            <a href="${pageContext.request.contextPath}/events/details?id=<%= highlightEvent.getEventId() %>" class="btn btn-primary">
                                View Event <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        <% } %>
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
            <h4>Categories</h4>
            <a href="${pageContext.request.contextPath}/EventsServlet">All Events</a>
            <% if (categories != null) {
                for (Category category : categories) {
                    if (category.isActive()) {
            %>
                <a href="${pageContext.request.contextPath}/EventsServlet?category=<%= category.getCategoryId() %>">
                    <i class="fas 
                    <% String catClass = "fa-theater-masks";
                       if (category.getName() != null) {
                           String catName = category.getName().toLowerCase();
                           if (catName.equals("music")) catClass = "fa-music";
                           else if (catName.equals("sport")) catClass = "fa-basketball-ball";
                           else if (catName.equals("exhibition")) catClass = "fa-palette";
                           else if (catName.equals("business")) catClass = "fa-briefcase";
                           else if (catName.equals("photography")) catClass = "fa-camera";
                       }
                    %>
                    <%= catClass %>"></i> <%= category.getName() %>
                </a>
            <% 
                    }
                }
            } %>
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
            <a href="#">Contact Us</a>
            <a href="#">Careers</a>
            <a href="#">Blog</a>
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
document.addEventListener('DOMContentLoaded', function() {
    // Like button functionality
    const likeButtons = document.querySelectorAll('.like');
    likeButtons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            this.classList.toggle('active');
            const icon = this.querySelector('i');
            if (this.classList.contains('active')) {
                icon.classList.replace('far', 'fas');
            } else {
                icon.classList.replace('fas', 'far');
            }
        });
    });
    
    // Lazy loading images (simple version)
    const images = document.querySelectorAll('.event-image:not(.loaded)');
    const options = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };
    
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    const wrapper = img.parentNode;
                    img.onload = () => wrapper.classList.add('loaded');
                    img.src = img.dataset.src;
                    imageObserver.unobserve(img);
                }
            });
        }, options);
        
        images.forEach(img => {
            if (img.dataset.src === undefined) {
                img.dataset.src = img.src;
                img.src = '';
            }
            imageObserver.observe(img);
        });
    }
});
</script>
</body>
</html>