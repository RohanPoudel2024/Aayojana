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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/heroSection.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/timingLocation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/aboutEvent.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/eventGallery.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/similarEvents.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/ctaSection.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/floatingBtn.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animations.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pageTransitions.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="page-transition">
    <div class="page-transition-content">
        <div class="page-transition-spinner"></div>
        <div class="page-transition-text">Loading amazing events...</div>
    </div>
</div>

<div class="container page-content">
    <jsp:include page="common/userHeader.jsp" />
        </div>
    </div>
      <div class="hero-section animate-fadeIn">
        <div class="event-card animate-scaleIn">
            <div class="date animate-fadeInUp delay-200"><%= dateFormat.format(event.getDate()) %></div>
            <h1 class="animate-fadeInUp delay-300"><%= event.getTitle() %></h1>
            <p class="animate-fadeInUp delay-400"><%= event.getDescription() != null ? event.getDescription() : "Join us for this amazing event!" %></p>
        </div>
    </div>
    
    <div class="main-content">
        <div class="section timing-location animate-fadeInUp">
            <h2>Timing and location</h2>
            <div class="info-card animate-fadeInLeft delay-200">
                <h3>Date and Time</h3>
                <p><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %></p>
                <p><span class="icon"><i class="fas fa-clock"></i></span> <%= event.getTime() %></p>
            </div>
            <div class="info-card animate-fadeInLeft delay-300">
                <h3>Place</h3>
                <p><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
            </div>
            <div class="price-card animate-fadeInRight delay-400">
                <% if(event.getPrice() > 0) { %>
                    <p class="animate-pulse">NPR. <%= priceFormat.format(event.getPrice()) %> Ticket</p>
                <% } else { %>
                    <div class="free-tag animate-pulse">FREE</div>
                    <p>Free Entry</p>
                <% } %>
                <p class="seats-info">Available Seats: <span class="seat-count animate-fadeIn delay-500"><%= event.getAvailableSeats() %></span></p>
                <% if(currentUser != null) { %>
                    <a href="${pageContext.request.contextPath}/booking?eventId=<%= event.getEventId() %>" class="btn btn-primary animate-fadeIn delay-700">Book Ticket</a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login?redirect=events/details?id=<%= event.getEventId() %>" class="btn btn-primary animate-fadeIn delay-700">Login to Book</a>
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
                    <div class="overlay-icon"><i class="fas fa-search-plus"></i></div>
                    <div class="caption">Event showcase image</div>
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
                            <div class="event-content">
                                <h3><%= similarEvent.getTitle() %></h3>
                                <p><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(similarEvent.getDate()) %> | <%= similarEvent.getTime() %></p>
                                <p><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= similarEvent.getLocation() %></p>
                                <p class="price">From NPR. <%= priceFormat.format(similarEvent.getPrice()) %></p>
                            </div>
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
                </a>            </div>
        </div>
        
        <div class="section cta-section">
            <div class="cta-decoration cta-decoration-1"></div>
            <div class="cta-decoration cta-decoration-2"></div>
            <div class="cta-decoration cta-decoration-3"></div>
            <div class="cta-content">
                <h2>Ready to Join This Event?</h2>
                <p>Don't miss out on this incredible opportunity to be part of <%= event.getTitle() %>. Book your tickets now and create unforgettable memories!</p>
                <div class="cta-buttons">
                    <% if(currentUser != null) { %>
                        <a href="${pageContext.request.contextPath}/booking?eventId=<%= event.getEventId() %>" class="cta-btn cta-btn-primary">
                            <i class="fas fa-ticket-alt"></i>&nbsp; Book Tickets Now
                        </a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login?redirect=events/details?id=<%= event.getEventId() %>" class="cta-btn cta-btn-primary">
                            <i class="fas fa-sign-in-alt"></i>&nbsp; Login to Book
                        </a>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/EventsServlet" class="cta-btn cta-btn-secondary">
                        <i class="fas fa-calendar-alt"></i>&nbsp; Explore More Events
                    </a>
                </div>
            </div>
        </div>
    </div>    <jsp:include page="common/userFooter.jsp" />
</div>

<% if(currentUser != null) { %>
<a href="${pageContext.request.contextPath}/booking?eventId=<%= event.getEventId() %>" class="floating-action-btn">
    <i class="fas fa-ticket-alt"></i>
    <span class="fab-tooltip">Book Now</span>
</a>
<% } else { %>
<a href="${pageContext.request.contextPath}/login?redirect=events/details?id=<%= event.getEventId() %>" class="floating-action-btn">
    <i class="fas fa-sign-in-alt"></i>
    <span class="fab-tooltip">Login to Book</span>
</a>
<% } %>

<script>
    // Toggle like button
    document.querySelector('.like')?.addEventListener('click', function() {
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
    
    // Add scroll reveal effects
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize page transition
        const pageTransition = document.querySelector('.page-transition');
        if (pageTransition) {
            // Hide transition overlay after page load
            setTimeout(() => {
                pageTransition.classList.remove('active');
            }, 300);
        }

        // Handle links for page transitions
        document.querySelectorAll('a').forEach(link => {
            // Skip links that open in new tabs or are anchors
            if (link.getAttribute('target') === '_blank' || 
                link.getAttribute('href')?.startsWith('#') ||
                link.getAttribute('href')?.startsWith('javascript:')) {
                return;
            }
            
            link.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                
                // Skip if no href
                if (!href) return;
                
                // Handle page transition
                e.preventDefault();
                
                // Show transition overlay
                if (pageTransition) {
                    pageTransition.classList.add('active');
                    
                    // Navigate after animation
                    setTimeout(() => {
                        window.location.href = href;
                    }, 500);
                } else {
                    // If no transition element, just navigate
                    window.location.href = href;
                }
            });
        });
        
        // Handle floating action button visibility
        const fab = document.querySelector('.floating-action-btn');
        const footer = document.querySelector('footer');
        if (fab && footer) {
            window.addEventListener('scroll', function() {
                const footerRect = footer.getBoundingClientRect();
                
                // Hide FAB when footer is visible
                if (footerRect.top < window.innerHeight) {
                    fab.classList.add('fab-hidden');
                } else {
                    fab.classList.remove('fab-hidden');
                }
            });
        }
        
        // Animate elements on scroll
        const animateOnScroll = () => {
            const elements = document.querySelectorAll('.section:not(.animate-active)');
            
            elements.forEach(element => {
                const elementPosition = element.getBoundingClientRect().top;
                const screenPosition = window.innerHeight / 1.2;
                
                if (elementPosition < screenPosition) {
                    element.classList.add('animate-active');
                    element.style.animation = 'fadeInUp 0.8s ease-out forwards';
                }
            });
        };
        
        // Initial check
        animateOnScroll();
        
        // Listen for scroll
        window.addEventListener('scroll', animateOnScroll);
        
        // Animate event items with staggered delay
        const eventItems = document.querySelectorAll('.event-item');
        
        eventItems.forEach((item, index) => {
            setTimeout(() => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    item.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, 100);
            }, index * 150);
        });
        
        // Image gallery interaction
        const albumImages = document.querySelectorAll('.album-image');
        albumImages.forEach(image => {
            image.addEventListener('click', function() {
                createLightbox(this.querySelector('img').src, this.querySelector('.caption')?.textContent);
            });
        });
        
        // Hover effects for buttons
        const buttons = document.querySelectorAll('.btn, .cta-btn');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.boxShadow = '0 10px 20px rgba(0, 0, 0, 0.15)';
            });
            
            button.addEventListener('mouseleave', function() {
                this.style.transform = '';
                this.style.boxShadow = '';
            });
        });
    });
      // Create a lightbox for gallery images
    function createLightbox(imgSrc, caption) {
        // Create lightbox container
        const lightbox = document.createElement('div');
        lightbox.className = 'lightbox animate-fadeIn';
        lightbox.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.9); display: flex; align-items: center; justify-content: center; z-index: 9999; padding: 2rem;';
        
        // Create image container
        const imgContainer = document.createElement('div');
        imgContainer.style.cssText = 'position: relative; max-width: 90%; max-height: 80%;';
        imgContainer.className = 'animate-scaleIn';
        
        // Create image
        const img = document.createElement('img');
        img.src = imgSrc;
        img.style.cssText = 'max-width: 100%; max-height: 80vh; object-fit: contain; border-radius: 8px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);';
        
        // Close button
        const closeBtn = document.createElement('button');
        closeBtn.innerHTML = '&times;';
        closeBtn.style.cssText = 'position: absolute; top: -20px; right: -20px; background-color: white; color: #18181b; border-radius: 50%; width: 40px; height: 40px; font-size: 24px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);';
        
        // Caption
        if (caption) {
            const captionElement = document.createElement('div');
            captionElement.textContent = caption;
            captionElement.style.cssText = 'color: white; text-align: center; margin-top: 1rem; font-size: 1rem; font-weight: 500;';
            imgContainer.appendChild(captionElement);
        }
        
        // Add elements to DOM
        imgContainer.appendChild(img);
        imgContainer.appendChild(closeBtn);
        lightbox.appendChild(imgContainer);
        document.body.appendChild(lightbox);
        
        // Close on click
        closeBtn.addEventListener('click', () => {
            lightbox.classList.add('animate-fadeOut');
            setTimeout(() => {
                document.body.removeChild(lightbox);
            }, 300);
        });
        
        // Close on outside click
        lightbox.addEventListener('click', (e) => {
            if (e.target === lightbox) {
                lightbox.classList.add('animate-fadeOut');
                setTimeout(() => {
                    document.body.removeChild(lightbox);
                }, 300);
            }
        });
    }
</script>
</body>
</html>