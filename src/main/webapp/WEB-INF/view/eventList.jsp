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
    List<Event> allEvents = (List<Event>) request.getAttribute("allEvents");
    Boolean isUpcomingView = (Boolean) request.getAttribute("isUpcomingView");
    String pageTitle = (String) request.getAttribute("pageTitle");
    
    if (isUpcomingView == null) {
        isUpcomingView = false;
    }
    
    if (pageTitle == null) {
        pageTitle = "Search Events";
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    
    // Helper variable for no events message
    String noEventsMessage = "<div class=\"no-events\"><i class=\"fas fa-calendar-times\"></i>No events available</div>";
%>
<html>
<head>
    <title><%= pageTitle %> - AayoJana</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">

</head>
<body>
<div class="container">
    <jsp:include page="common/userHeader.jsp" />
      <div class="hero-section">
        <div class="hero-content">
            <% if (isUpcomingView) { %>
                <h1>Upcoming Events</h1>
                <h2>Discover What's Coming Up Soon</h2>
            <% } else { %>
                <h1>Discover Amazing Events</h1>
                <h2>Find Your Next Experience & Create Memories</h2>
            <% } %>
            <form action="${pageContext.request.contextPath}/EventsServlet" method="get" class="search-form">
                <% if (isUpcomingView) { %>
                    <input type="hidden" name="view" value="upcoming">
                <% } %>
                <div class="search-inputs">
                    <input type="text" name="keyword" placeholder="Search events by name, location or category...">
                    <div class="search-actions">
                        <button type="submit"><i class="fas fa-search"></i> Find Events</button>
                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/EventsServlet<%= isUpcomingView ? "?view=upcoming" : "" %>'">
                            <i class="fas fa-th-large"></i> Browse All
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <div class="main-content">
        <!-- Display filtered events if a category is selected -->        <% if (filteredEvents != null && selectedCategoryId != null) { 
            String categoryName = "";
            for (Category cat : categories) {
                if (cat.getCategoryId() == selectedCategoryId) {
                    categoryName = cat.getName();
                    break;
                }
            }
            
            String viewUrlParam = (String) request.getAttribute("viewUrlParam");
            if (viewUrlParam == null) {
                viewUrlParam = "";
            }
        %>
            <div class="section">
                <h2><%= categoryName.toUpperCase() %> EVENTS</h2>
                <a href="${pageContext.request.contextPath}/EventsServlet<%= isUpcomingView ? "?view=upcoming" : "" %>" class="clear-filter">× Clear filter</a>
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
                                        From NPR. <%= priceFormat.format(event.getPrice()) %>
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
        <% } else if (isUpcomingView && (allEvents == null || allEvents.isEmpty())) { %>
            <div class="section">
                <h2>UPCOMING EVENTS</h2>
                <div class="events-grid">
                    <%= noEventsMessage %>
                </div>
            </div>
        <% } else if (isUpcomingView) { %>
            <div class="section">
                <h2>UPCOMING EVENTS</h2>
                <div class="events-grid">
                    <% for (Event event : allEvents) { %>
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
                                        From NPR. <%= priceFormat.format(event.getPrice()) %>
                                        <span class="event-tag">Paid</span>
                                    <% } else { %>
                                        Free entry
                                        <span class="event-tag">Free</span>
                                    <% } %>
                                </p>
                            </a>
                        </div>
                    <% } %>
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
                        <a href="${pageContext.request.contextPath}/EventsServlet?view=upcoming&category=<%= category.getCategoryId() %>" 
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
                                Map<Integer, Integer> categoryEventCounts = (Map<Integer, Integer>) request.getAttribute("categoryEventCounts");
                                if (categoryEventCounts != null && categoryEventCounts.containsKey(category.getCategoryId())) {
                                    count = categoryEventCounts.get(category.getCategoryId());
                                }
                                %>
                                <%= count %> event<%= count != 1 ? "s" : "" %>
                            </div>
                        </a>
                    <% 
                            }
                        }
                    } %>                </div>
            </div>
        <% } else if (!isUpcomingView) { %>
            <!-- Regular event display when no category is selected and not in upcoming view -->
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
                                        From NPR. <%= priceFormat.format(event.getPrice()) %>
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
                            <p><%= category.getName().toUpperCase() %></p>                            <div class="event-count">
                                <% 
                                int count = 0;
                                Map<Integer, Integer> categoryEventCounts = (Map<Integer, Integer>) request.getAttribute("categoryEventCounts");
                                if (categoryEventCounts != null && categoryEventCounts.containsKey(category.getCategoryId())) {
                                    count = categoryEventCounts.get(category.getCategoryId());
                                }
                                %>
                                <!-- <%= count %> event<%= count != 1 ? "s" : "" %> -->
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
                                        From NPR. <%= priceFormat.format(event.getPrice()) %>
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
                </div>                <div class="view-more">
                    <a href="${pageContext.request.contextPath}/EventsServlet?view=upcoming">
                        View more upcoming events <i class="fas fa-chevron-right"></i>
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
                                From NPR. <%= priceFormat.format(highlightEvent.getPrice()) %>
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
    
    <jsp:include page="common/userFooter.jsp" />
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
            if (icon) {
                if (this.classList.contains('active')) {
                    icon.classList.replace('far', 'fas');
                } else {
                    icon.classList.replace('fas', 'far');
                }
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

    // Make event cards clickable
    const eventItems = document.querySelectorAll('.event-item');
    eventItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Don't trigger if clicking on like button
            if (e.target.closest('.like')) {
                e.stopPropagation();
                return;
            }
            
            // Get the link inside the card and follow it
            const link = this.querySelector('a').getAttribute('href');
            if (link) {
                window.location.href = link;
            }
        });
        
        // Add keyboard accessibility
        item.setAttribute('tabindex', '0');
        item.addEventListener('keydown', function(e) {
            // Enter or space key
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                const link = this.querySelector('a').getAttribute('href');
                if (link) {
                    window.location.href = link;
                }
            }
        });
    });
});
</script>
</body>
</html>