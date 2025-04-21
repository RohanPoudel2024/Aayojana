<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 2:42 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Event - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchPage.css">
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
    <div class="main-content">
        <div class="search-bar">
            <h1>Search Event</h1>
            <div class="search-inputs">
                <input type="text" placeholder="Search Event" value="Rock">
                <input type="text" placeholder="Location" value="Kathmandu, Nepal">
                <button>Search</button>
            </div>
        </div>
        <div class="content-wrapper">
            <div class="filter-section">
                <h3>Filter</h3>
                <div class="filter-group">
                    <h4>Category</h4>
                    <label><input type="checkbox" checked> All</label>
                    <label><input type="checkbox"> Trending</label>
                    <label><input type="checkbox"> Upcoming</label>
                    <label><input type="checkbox"> Music</label>
                    <label><input type="checkbox"> Sport</label>
                    <label><input type="checkbox"> Exhibition</label>
                    <label><input type="checkbox"> Business</label>
                    <label><input type="checkbox"> Photography</label>
                    <a href="#">Show more</a>
                </div>
                <div class="filter-actions">
                    <button class="clear">Clear all</button>
                    <button class="apply">Apply</button>
                </div>
            </div>
            <div class="events-section">
                <div class="results-count">6 results</div>
                <div class="events-grid">
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="like">❤️</div>
                        <div class="discount">20% OFF</div>
                        <h3>Pokhara Music Fest | Rockheads</h3>
                        <p><span class="icon">📅</span>Saturday, May 20 | 08:00 PM</p>
                        <p><span class="icon">📍</span>Pokhara, Nepal</p>
                        <p>From Rs 499</p>
                    </div>
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="like active">❤️</div>
                        <div class="tag">New Event</div>
                        <h3>Rock Fest | The Elements | Rockheads | Purna Rai</h3>
                        <p><span class="icon">📅</span>Friday, December 10 | 08:00 PM</p>
                        <p><span class="icon">📍</span>New York, NY</p>
                    </div>
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="like">❤️</div>
                        <div class="sold-out">Sold Out</div>
                        <div class="tag">New Event</div>
                        <h3>Gathering of Rock ICONS | Surprise Event</h3>
                        <p><span class="icon">📅</span>Tuesday, June 20 | 08:00 PM</p>
                        <p><span class="icon">📍</span>Kathmandu, Nepal</p>
                    </div>
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="like">❤️</div>
                        <div class="tag">Invitation Only</div>
                        <h3>Rock Weds ANGLIA | DESTINATION Weeding</h3>
                        <p><span class="icon">📅</span>Monday, June 05 | 06:00 PM</p>
                        <p><span class="icon">📍</span>Upper Mustang, Nepal</p>
                    </div>
                </div>
                <div class="view-more">
                    <button>View more</button>
                </div>
            </div>
        </div>
        <div class="recommended-section">
            <h2>Recommended for you</h2>
            <div class="recommended-grid">
                <div class="events-grid">
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="discount">20% OFF</div>
                        <h3>Fuel Your Passion for Rock Music</h3>
                        <p><span class="icon">📅</span>Tuesday, August 18 | 06:00 PM</p>
                        <p><span class="icon">📍</span>Jhapa, Nepal</p>
                        <p>From Rs100</p>
                    </div>
                    <div class="event-item">
                        <div class="image-placeholder">Event Image</div>
                        <div class="discount">20% OFF</div>
                        <h3>Musical Fusion Festival for Wild Life Conservation</h3>
                        <p><span class="icon">📅</span>Monday, June 01 | 06:00 PM</p>
                        <p><span class="icon">📍</span>Koshi Tappu, Nepal</p>
                        <p>From Rs900</p>
                    </div>
                </div>
                <div class="carousel">
                    <button>⬅️</button>
                    <button>➡️</button>
                </div>
                <div class="view-more">
                    <a href="#">VIEW MORE</a>
                </div>
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