<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 2:38 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>

<html>
<head>
    <title>Event Details - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventDetails.css" >
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <div class="nav-links">
            <a href="#" class="active">Explore</a>
            <a href="#">Upcoming Events</a>
            <a href="#">My Events</a>
        </div>
        <div class="user">
            <span class="icon">🔔</span>
            <span>User Account</span>
            <span class="icon">👤</span>
        </div>
    </div>
    <div class="hero-section">
        <div class="event-card">
            <div class="date">February 20</div>
            <h1>Name of the Event</h1>
            <p>Consectetur tempor ipsum dolor sit amet fugiat aliquid id ex aliqua. Dolor Lorem ipsum commodo dolore adipiscing aliquid sit magna.</p>
            <div class="event-actions">
                <div class="like">345</div>
                <div class="share">124</div>
            </div>
        </div>
    </div>
    <div class="main-content">
        <div class="section timing-location">
            <h2>Timing and location</h2>
            <div class="info-card">
                <h3>Date and Time</h3>
                <p><span class="icon">📅</span>Saturday, February 20</p>
                <p><span class="icon">⏰</span>08:00 PM</p>
            </div>
            <div class="info-card">
                <h3>Place</h3>
                <p><span class="icon">📍</span>Central Park, New York, NY 10022</p>
            </div>
            <div class="price-card">
                <div class="discount">20% OFF</div>
                <p>Rs 300 Ticket</p>
                <button>Purchase Ticket</button>
            </div>
        </div>
        <div class="section about-event">
            <h2>About event</h2>
            <div class="about-details">
                <p>Verniam quia magna excepteur ipsum laborum mollit commodo exercitation elit aliquid Lorem autem tempore amet in fugiat. Tempor inure ipsum non sit eu sunt non sit ipsum consectetur qui dolor Lorem cupidatat. Animi nisl deserunt ad sint inure occaecat tempor cu</p>
                <a href="#">Read more</a>
            </div>
            <div class="about-stats">
                <div class="stat">
                    <div class="icon">⏳</div>
                    <p>Duration</p>
                    <p>5 Hours</p>
                </div>
                <div class="stat">
                    <div class="icon">🎟️</div>
                    <p>Ticket</p>
                    <p>E-ticket</p>
                </div>
            </div>
        </div>
        <div class="section event-album">
            <h2>The latest event's album</h2>
            <div class="album-image">Image 1</div>
            <div class="album-image">Image 2</div>
            <div class="album-image">Image 3</div>
            <div class="album-image">Image 4</div>
        </div>
        <div class="section similar-events">
            <h2>Similar Events</h2>
            <div class="events-grid">
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="discount">20% OFF</div>
                    <h3>Islington Spring Carnival 2025</h3>
                    <p><span class="icon">📅</span>Monday, August 12 03:00 PM</p>
                    <p><span class="icon">📍</span>Kathmandu, Nepal</p>
                    <p>From Rs150</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="discount">20% OFF</div>
                    <h3>Dharan Mayor's Cup 2025</h3>
                    <p><span class="icon">📅</span>Friday, May 12 03:00 PM</p>
                    <p><span class="icon">📍</span>Dharan Stadium, Dharan</p>
                    <p>From Rs150</p>
                </div>
            </div>
            <div class="carousel">
                <button>⬅️</button>
                <button>➡️</button>
            </div>
            <div class="view-more">
                <a href="#">View more</a>
            </div>
        </div>
    </div>
    <div class="footer">
        <div class="footer-column">
            <div class="logo">AYO-JANA</div>
        </div>
        <div class="footer-column">
            <h4>Categories</h4>
            <a href="#">All</a>
            <a href="#">Music</a>
            <a href="#">Sport</a>
            <a href="#">Exhibition</a>
            <a href="#">Business</a>
            <a href="#">Photography</a>
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
            <a href="#">🐦</a>
            <a href="#">📘</a>
            <a href="#">📹</a>
        </div>
    </div>
</div>
</body>
</html>