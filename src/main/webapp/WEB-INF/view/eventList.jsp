<%--
  Created by IntelliJ IDEA.
  User: Rohan
  Date: 4/21/2025
  Time: 10:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 1:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Events - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/eventList.css">
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <button class="sign-in">Sign In</button>
    </div>
    <div class="hero-section">
        <div class="hero-content">
            <h1>Search Events</h1>
            <h2>For the Weekend</h2>
            <div class="search-inputs">
                <input type="text" placeholder="Find the event">
                <input type="text" placeholder="Location" value="Bharat, Nepal">
                <button>Search</button>
            </div>
        </div>
    </div>
    <div class="main-content">
        <div class="section">
            <h2>NEW EVENTS</h2>
            <div class="events-grid">
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>10th Celebration</h3>
                    <p><span class="icon">📅</span>Monday, June 30 | 06:00 PM</p>
                    <p><span class="icon">📍</span>New York, NY</p>
                    <p>From $25</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like active">❤️</div>
                    <h3>Marriage Ceremony</h3>
                    <p><span class="icon">📅</span>Wednesday, June 30 | 07:00 PM</p>
                    <p><span class="icon">📍</span>New York, NY</p>
                    <p>Free ticket</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>The Elements Concert</h3>
                    <p><span class="icon">📅</span>Monday, March 14 | 06:00 PM</p>
                    <p><span class="icon">📍</span>New York, NY</p>
                    <p>From $250.00</p>
                </div>
            </div>
        </div>
        <div class="section">
            <h2>EXPLORE BY CATEGORY</h2>
            <div class="category-grid">
                <div class="category-item">
                    <div class="icon">🎵</div>
                    <p>MUSIC</p>
                </div>
                <div class="category-item">
                    <div class="icon">🏀</div>
                    <p>SPORT</p>
                </div>
                <div class="category-item">
                    <div class="icon">🎨</div>
                    <p>EXHIBITION</p>
                </div>
                <div class="category-item">
                    <div class="icon">💼</div>
                    <p>BUSINESS</p>
                </div>
                <div class="category-item">
                    <div class="icon">📸</div>
                    <p>PHOTOGRAPHY</p>
                </div>
            </div>
        </div>
        <div class="section">
            <h2>UPCOMING IN 24h</h2>
            <div class="events-grid">
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>MUSIC FESTIVAL</h3>
                    <p><span class="icon">📅</span>Wednesday, April 20 | 05:00 PM</p>
                    <p><span class="icon">📍</span>Kathmandu, Nepal</p>
                    <p>From $100</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like active">❤️</div>
                    <h3>12th Celebration</h3>
                    <p><span class="icon">📅</span>Friday, April 20 | 07:00 PM</p>
                    <p><span class="icon">📍</span>Dharan, Nepal</p>
                    <p>From $50</p>
                </div>
            </div>
            <div class="view-more">
                <a href="#">View more</a>
            </div>
        </div>
        <div class="section">
            <h2>HIGHLIGHT EVENT THIS WEEK</h2>
            <div class="highlight-event">
                <div class="image-placeholder">Event Image</div>
                <div class="details">
                    <div>
                        <h3>HC MUSIC FEST 2025</h3>
                        <p><span class="icon">📅</span>Monday, April 20 | 05:00 PM</p>
                        <p><span class="icon">📍</span>Dharan, Nepal</p>
                        <p>From $8</p>
                    </div>
                    <button>Book Ticket</button>
                </div>
            </div>
            <div class="view-more">
                <a href="#">View more</a>
            </div>
        </div>
        <div class="section">
            <h2>MORE EVENTS</h2>
            <div class="events-grid">
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>DHARAN 2025</h3>
                    <p><span class="icon">📅</span>Monday, April 20 | 05:00 PM</p>
                    <p><span class="icon">📍</span>Dharan, Nepal</p>
                    <p>From $500.00</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>BIC AUTUMN FEST</h3>
                    <p><span class="icon">📅</span>Friday, April 20 | 04:00 PM</p>
                    <p><span class="icon">📍</span>BIC College, Biratnagar</p>
                    <p>Free ticket</p>
                </div>
                <div class="event-item">
                    <div class="image-placeholder">Event Image</div>
                    <div class="like">❤️</div>
                    <h3>DHARAN EXPO 2025</h3>
                    <p><span class="icon">📅</span>Monday, April 20 | 05:00 PM</p>
                    <p><span class="icon">📍</span>Dharan Stadium</p>
                    <p>Free ticket</p>
                </div>
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
