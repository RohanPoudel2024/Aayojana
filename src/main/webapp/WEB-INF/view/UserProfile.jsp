<%--
  Created by IntelliJ IDEA.
  User: rupsa
  Date: 22-Apr-25
  Time: 2:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Profile - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userProfile.css">
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">AYO-JANA</div>
        <div class="nav-links">
            <a href="#">Dashboard</a>
            <a href="#" class="active">Profile</a>
            <a href="#">Settings</a>
        </div>
        <div class="user">
            <span class="icon">🔔</span>
            <span class="icon">👤</span>
        </div>
    </div>
    <div class="main-content">
        <div class="profile-section">
            <div class="profile-avatar">
                <div class="avatar"></div>
                <div class="profile-info">
                    <h3>User Account</h3>
                    <p>user@account.com</p>
                    <p>(977) 9813217654</p>
                    <p>Dharan-08, Bargachhi</p>
                    <p class="location">Nepal</p>
                </div>
            </div>
            <div class="profile-form">
                <h2>User Details Customization</h2>
                <form>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" value="User Account" readonly>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" value="user@account.com" readonly>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" value="(977) 9813217654" readonly>
                    </div>
                    <div class="form-group">
                        <label>Address Line 1</label>
                        <input type="text" placeholder="Street Address">
                    </div>
                    <div class="form-group">
                        <label>Address Line 2</label>
                        <input type="text" placeholder="Apartment, suite, unit, etc. (optional)">
                    </div>
                    <div class="form-group">
                        <label>City</label>
                        <input type="text" placeholder="City">
                    </div>
                    <div class="form-group">
                        <label>State / Province / Region</label>
                        <input type="text" placeholder="State / Province / Region">
                    </div>
                    <div class="form-group">
                        <label>Zip / Postal Code</label>
                        <input type="text" placeholder="Zip / Postal Code">
                    </div>
                    <div class="form-group">
                        <label>Country / Nationality</label>
                        <input type="text" placeholder="Country / Nationality">
                    </div>
                    <button type="submit" class="save-button">Save Changes</button>
                </form>
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
        <p>&copy; 2025 AYO-JANA, Inc. • Privacy • Terms • Sitemap</p>
        <div class="social-icons">
            <a href="#">🐦</a>
            <a href="#">📘</a>
            <a href="#">📹</a>
        </div>
    </div>
</div>

</body>
</html>
