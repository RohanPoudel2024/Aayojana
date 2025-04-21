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
            margin: 0 20px;
            text-decoration: none;
            color: #666;
            font-size: 16px;
            padding-bottom: 5px;
        }

        .header .nav-links a.active {
            color: #4a00e0;
            border-bottom: 2px solid #4a00e0;
        }

        .header .user {
            display: flex;
            align-items: center;
            color: #666;
        }

        .header .user .icon {
            margin-left: 10px;
            font-size: 18px;
        }

        .main-content {
            flex-grow: 1;
            padding: 30px;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .profile-section {
            display: flex;
            gap: 40px;
            max-width: 900px;
            width: 100%;
        }

        .profile-avatar {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        .avatar {
            width: 150px;
            height: 150px;
            background-color: #ff4d4d;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
            font-size: 50px;
        }

        .avatar::before {
            content: "👤";
        }

        .profile-info {
            text-align: center;
        }

        .profile-info h3 {
            margin: 5px 0;
            font-size: 18px;
            font-weight: 600;
        }

        .profile-info p {
            margin: 5px 0;
            color: #666;
            font-size: 14px;
        }

        .profile-info .location {
            color: #999;
            font-size: 14px;
        }

        .profile-form {
            flex-grow: 1;
        }

        .profile-form h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            color: #333;
        }

        .form-group input::placeholder {
            color: #999;
        }

        .save-button {
            background-color: #4a00e0;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
        }

        .save-button:hover {
            background-color: #5a1ff0;
        }

        .footer {
            background-color: #1a1a1a;
            padding: 30px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
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
            font-weight: 600;
            margin-bottom: 15px;
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
            padding: 8px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            flex-grow: 1;
        }

        .footer-column button {
            background-color: #4a00e0;
            color: #fff;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .footer-column button:hover {
            background-color: #5a1ff0;
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
            font-size: 16px;
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
