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
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #333;
        }

        .container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fff;
            padding: 15px 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .header .logo {
            font-size: 20px;
            font-weight: bold;
            color: #4a00e0;
        }

        .header .nav-links a {
            margin: 0 15px;
            text-decoration: none;
            color: #666;
            font-size: 16px;
            padding: 5px 10px;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
        }

        .header .nav-links a.active {
            background-color: #4a00e0;
            color: #fff;
        }

        .header .nav-links a:hover {
            background-color: #e6e6ff;
            color: #4a00e0;
        }

        .header .user {
            display: flex;
            align-items: center;
            background-color: #f0f0f0;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            color: #666;
        }

        .header .user .icon {
            margin-left: 10px;
            font-size: 18px;
        }

        .main-content {
            flex-grow: 1;
            padding: 40px 30px;
            background-color: #f8f9fa;
        }

        .search-bar {
            text-align: center;
            margin-bottom: 40px;
        }

        .search-bar h1 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #333;
        }

        .search-inputs {
            display: flex;
            justify-content: center;
            gap: 15px;
            max-width: 600px;
            margin: 0 auto;
        }

        .search-inputs input {
            padding: 12px 20px;
            border: 1px solid #ddd;
            border-radius: 25px;
            font-size: 14px;
            color: #333;
            flex: 1;
        }

        .search-inputs input::placeholder {
            color: #999;
        }

        .search-inputs button {
            background: linear-gradient(90deg, #4a00e0, #8e2de2);
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: transform 0.1s;
        }

        .search-inputs button:hover {
            transform: scale(1.05);
        }

        .content-wrapper {
            display: flex;
            gap: 30px;
        }

        .filter-section {
            width: 250px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .filter-section h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
        }

        .filter-group {
            margin-bottom: 20px;
        }

        .filter-group h4 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }

        .filter-group label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }

        .filter-group input[type="checkbox"] {
            width: 16px;
            height: 16px;
        }

        .filter-group a {
            color: #4a00e0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .filter-group a:hover {
            text-decoration: underline;
        }

        .filter-actions {
            display: flex;
            gap: 10px;
        }

        .filter-actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .filter-actions .clear {
            background-color: #f0f0f0;
            color: #666;
        }

        .filter-actions .apply {
            background: linear-gradient(90deg, #4a00e0, #8e2de2);
            color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .filter-actions .apply:hover {
            transform: scale(1.05);
        }

        .events-section {
            flex: 1;
        }

        .events-section .results-count {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .event-item {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            position: relative;
        }

        .event-item .image-placeholder {
            background-color: #f0f0f0;
            height: 150px;
            border-radius: 10px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 14px;
        }

        .event-item .discount {
            background-color: #ff4d4d;
            color: #fff;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            position: absolute;
            top: 10px;
            right: 10px;
        }

        .event-item .tag {
            background-color: #e6e6ff;
            color: #4a00e0;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            position: absolute;
            top: 40px;
            right: 10px;
        }

        .event-item .sold-out {
            background-color: #f0f0f0;
            color: #666;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            position: absolute;
            top: 40px;
            right: 10px;
        }

        .event-item .like {
            position: absolute;
            top: 10px;
            left: 10px;
            font-size: 16px;
            color: #666;
        }

        .event-item .like.active {
            color: #ff4d4d;
        }

        .event-item h3 {
            font-size: 16px;
            font-weight: 700;
            margin: 0 0 10px;
            color: #333;
        }

        .event-item p {
            font-size: 14px;
            color: #666;
            margin: 5px 0;
            display: flex;
            align-items: center;
        }

        .event-item .icon {
            margin-right: 8px;
            font-size: 16px;
        }

        .event-item p:last-child {
            font-weight: 600;
            color: #333;
        }

        .view-more {
            text-align: center;
            margin-top: 30px;
        }

        .view-more button {
            background: linear-gradient(90deg, #4a00e0, #8e2de2);
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: transform 0.1s;
        }

        .view-more button:hover {
            transform: scale(1.05);
        }

        .recommended-section {
            margin-top: 50px;
        }

        .recommended-section h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 25px;
            color: #4a00e0;
        }

        .recommended-grid {
            position: relative;
        }

        .recommended-grid .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .carousel {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 100%;
            display: flex;
            justify-content: space-between;
            pointer-events: none;
        }

        .carousel button {
            background-color: #fff;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            cursor: pointer;
            pointer-events: auto;
            font-size: 20px;
            color: #666;
        }

        .carousel button:hover {
            background-color: #f0f0f0;
        }

        .recommended-section .view-more {
            text-align: right;
            margin-top: 20px;
        }

        .recommended-section .view-more a {
            color: #4a00e0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .recommended-section .view-more a:hover {
            text-decoration: underline;
        }

        .footer {
            background-color: #1a1a1a;
            padding: 40px 30px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 30px;
        }

        .footer .logo {
            font-size: 20px;
            font-weight: bold;
            color: #4a00e0;
            margin-bottom: 20px;
        }

        .footer-column {
            flex: 1;
            min-width: 150px;
        }

        .footer-column h4 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 15px;
            color: #fff;
        }

        .footer-column a {
            display: block;
            color: #ccc;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .footer-column a:hover {
            color: #fff;
        }

        .footer-column .subscribe {
            display: flex;
            gap: 10px;
        }

        .footer-column input {
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            flex-grow: 1;
            background-color: #333;
            color: #fff;
        }

        .footer-column input::placeholder {
            color: #ccc;
        }

        .footer-column button {
            background: linear-gradient(90deg, #4a00e0, #8e2de2);
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .footer-column button:hover {
            background: linear-gradient(90deg, #5a1ff0, #9e4df2);
        }

        .footer-bottom {
            background-color: #1a1a1a;
            padding: 15px 30px;
            text-align: center;
            color: #ccc;
            font-size: 12px;
            border-top: 1px solid #333;
        }

        .footer-bottom .social-icons {
            margin-top: 10px;
        }

        .footer-bottom .social-icons a {
            color: #ccc;
            font-size: 18px;
            margin: 0 10px;
            text-decoration: none;
        }

        .footer-bottom .social-icons a:hover {
            color: #fff;
        }
    </style>
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