<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aayojana - Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #5928E5;
            --primary-dark: #4A20C5;
            --secondary: #FF6B6B;
            --accent: #FFD166;
            --light: #F8F9FA;
            --dark: #212529;
            --gray: #6C757D;
            --success: #28A745;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: var(--light);
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            z-index: 1000;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
        }

        .logo span {
            color: var(--secondary);
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 30px;
        }

        nav ul li a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: var(--primary);
        }

        .auth-buttons {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }

        /* Hero Section */
        .hero {
            padding-top: 120px;
            padding-bottom: 80px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 40px;
        }

        .hero-text {
            flex: 1;
        }

        .hero-text h1 {
            font-size: 48px;
            line-height: 1.2;
            margin-bottom: 20px;
            color: var(--dark);
        }

        .hero-text h1 span {
            color: var(--primary);
        }

        .hero-text p {
            font-size: 18px;
            color: var(--gray);
            margin-bottom: 30px;
        }

        .hero-image {
            flex: 1;
            text-align: center;
        }

        .hero-image img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* Features Section */
        .features {
            padding: 80px 0;
            background-color: white;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 36px;
            color: var(--dark);
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 18px;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .feature-card {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background-color: rgba(89, 40, 229, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .feature-icon i {
            font-size: 24px;
            color: var(--primary);
        }

        .feature-card h3 {
            font-size: 20px;
            margin-bottom: 15px;
            color: var(--dark);
        }

        .feature-card p {
            color: var(--gray);
        }

        /* How It Works Section */
        .how-it-works {
            padding: 80px 0;
            background-color: #f8f9fa;
        }

        .steps {
            display: flex;
            justify-content: space-between;
            margin-top: 50px;
            flex-wrap: wrap;
        }

        .step {
            flex: 1;
            min-width: 250px;
            text-align: center;
            padding: 0 20px;
            position: relative;
        }

        .step:not(:last-child)::after {
            content: "";
            position: absolute;
            top: 40px;
            right: -30px;
            width: 60px;
            height: 2px;
            background-color: var(--primary);
        }

        .step-number {
            width: 80px;
            height: 80px;
            background-color: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 600;
            margin: 0 auto 20px;
        }

        .step h3 {
            font-size: 20px;
            margin-bottom: 15px;
            color: var(--dark);
        }

        .step p {
            color: var(--gray);
        }

        /* Popular Events Section */
        .popular-events {
            padding: 80px 0;
            background-color: white;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .event-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .event-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .event-image {
            height: 200px;
            overflow: hidden;
        }

        .event-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .event-card:hover .event-image img {
            transform: scale(1.1);
        }

        .event-details {
            padding: 20px;
        }

        .event-date {
            display: inline-block;
            background-color: var(--accent);
            color: var(--dark);
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .event-details h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: var(--dark);
        }

        .event-details p {
            color: var(--gray);
            margin-bottom: 15px;
        }

        .event-meta {
            display: flex;
            justify-content: space-between;
            color: var(--gray);
            font-size: 14px;
        }

        /* CTA Section */
        .cta {
            padding: 80px 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            text-align: center;
        }

        .cta h2 {
            font-size: 36px;
            margin-bottom: 20px;
        }

        .cta p {
            font-size: 18px;
            margin-bottom: 30px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-light {
            background-color: white;
            color: var(--primary);
            border: none;
        }

        .btn-light:hover {
            background-color: rgba(255, 255, 255, 0.9);
        }

        /* Testimonials Section */
        .testimonials {
            padding: 80px 0;
            background-color: #f8f9fa;
        }

        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .testimonial-card {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .testimonial-text {
            font-style: italic;
            color: var(--gray);
            margin-bottom: 20px;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
        }

        .author-image {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 15px;
        }

        .author-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .author-info h4 {
            font-size: 16px;
            color: var(--dark);
        }

        .author-info p {
            font-size: 14px;
            color: var(--gray);
        }

        /* Newsletter Section */
        .newsletter {
            padding: 80px 0;
            background-color: white;
            text-align: center;
        }

        .newsletter-form {
            max-width: 600px;
            margin: 40px auto 0;
            display: flex;
            gap: 10px;
        }

        .newsletter-form input {
            flex: 1;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            outline: none;
        }

        .newsletter-form input:focus {
            border-color: var(--primary);
        }

        /* Footer */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 60px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-column h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: white;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 10px;
        }

        .footer-column ul li a {
            color: #adb5bd;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-column ul li a:hover {
            color: white;
        }

        .social-links {
            display: flex;
            gap: 15px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: white;
            transition: background-color 0.3s;
        }

        .social-links a:hover {
            background-color: var(--primary);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #adb5bd;
            font-size: 14px;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .hero-content {
                flex-direction: column;
            }

            .hero-text, .hero-image {
                text-align: center;
            }

            .step:not(:last-child)::after {
                display: none;
            }

            .steps {
                flex-direction: column;
                gap: 40px;
            }
        }

        @media (max-width: 768px) {
            nav {
                display: none;
            }

            .auth-buttons {
                display: none;
            }

            .mobile-menu-btn {
                display: block;
            }

            .hero-text h1 {
                font-size: 36px;
            }

            .section-title h2 {
                font-size: 30px;
            }

            .newsletter-form {
                flex-direction: column;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<!-- Header -->
<header>
    <div class="container header-container">
        <a href="#" class="logo">Aayo<span>jana</span></a>
        <nav>
            <ul>
                <li><a href="#">Home</a></li>
                <li><a href="#">Events</a></li>
                <li><a href="#">Features</a></li>
                <li><a href="#">Pricing</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="btn btn-primary">Sign Up</a>

        </div>
    </div>
</header>

<!-- Hero Section -->
<section class="hero">
    <div class="container hero-content">
        <div class="hero-text">
            <h1>Plan Your <span>Perfect Event</span> With Aayojana</h1>
            <p>The all-in-one platform for planning, managing, and hosting successful events of any size. From corporate conferences to intimate gatherings.</p>
            <div class="hero-buttons">
                <a href="#" class="btn btn-primary">Get Started</a>
                <a href="#" class="btn btn-outline">Learn More</a>
            </div>
        </div>
        <div class="hero-image">
            <img src="https://images.unsplash.com/photo-1511578314322-379afb476865?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80" alt="Event Planning">
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="container">
        <div class="section-title">
            <h2>Why Choose Aayojana?</h2>
            <p>Our platform offers everything you need to create memorable events</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3>Easy Scheduling</h3>
                <p>Effortlessly schedule and manage your events with our intuitive calendar interface.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <h3>Ticket Management</h3>
                <p>Create, sell, and manage tickets with customizable options and pricing tiers.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3>Attendee Management</h3>
                <p>Track registrations, send reminders, and manage your guest list all in one place.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3>Analytics & Insights</h3>
                <p>Gain valuable insights with detailed analytics on attendance, engagement, and revenue.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h3>Mobile Friendly</h3>
                <p>Access your event dashboard on any device with our responsive design.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Secure Payments</h3>
                <p>Process payments securely with our integrated payment gateway system.</p>
            </div>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section class="how-it-works">
    <div class="container">
        <div class="section-title">
            <h2>How Aayojana Works</h2>
            <p>Get your event up and running in just a few simple steps</p>
        </div>
        <div class="steps">
            <div class="step">
                <div class="step-number">1</div>
                <h3>Create Account</h3>
                <p>Sign up and create your organizer profile in minutes.</p>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <h3>Set Up Event</h3>
                <p>Add event details, create tickets, and customize your event page.</p>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <h3>Promote & Sell</h3>
                <p>Share your event and start selling tickets through multiple channels.</p>
            </div>
            <div class="step">
                <div class="step-number">4</div>
                <h3>Host Successfully</h3>
                <p>Use our tools to check in guests and manage your event smoothly.</p>
            </div>
        </div>
    </div>
</section>

<!-- Popular Events Section -->
<section class="popular-events">
    <div class="container">
        <div class="section-title">
            <h2>Upcoming Events</h2>
            <p>Discover and book tickets for these exciting events</p>
        </div>
        <div class="events-grid">
            <%
                // This would typically come from a database
                String[] eventNames = {"Tech Conference 2023", "Music Festival", "Food & Wine Expo", "Business Summit"};
                String[] eventDates = {"Oct 15-16, 2023", "Nov 5, 2023", "Dec 10, 2023", "Jan 20, 2024"};
                String[] eventLocations = {"New Delhi", "Mumbai", "Bangalore", "Hyderabad"};

                for(int i = 0; i < 4; i++) {
            %>
            <div class="event-card">
                <div class="event-image">
                    <img src="https://source.unsplash.com/random/300x200?event,<%= i %>" alt="<%= eventNames[i] %>">
                </div>
                <div class="event-details">
                    <span class="event-date"><%= eventDates[i] %></span>
                    <h3><%= eventNames[i] %></h3>
                    <p>Join us for an amazing experience with industry experts and networking opportunities.</p>
                    <div class="event-meta">
                        <span><i class="fas fa-map-marker-alt"></i> <%= eventLocations[i] %></span>
                        <span><i class="fas fa-ticket-alt"></i> From ₹1,999</span>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta">
    <div class="container">
        <h2>Ready to Host Your Next Event?</h2>
        <p>Join thousands of event organizers who trust Aayojana for their event management needs.</p>
        <div class="cta-buttons">
            <a href="#" class="btn btn-light">Create Event</a>
            <a href="#" class="btn btn-outline">Contact Sales</a>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials">
    <div class="container">
        <div class="section-title">
            <h2>What Our Customers Say</h2>
            <p>Hear from event organizers who have used Aayojana</p>
        </div>
        <div class="testimonials-grid">
            <%
                // This would typically come from a database
                String[] testimonialTexts = {
                        "Aayojana transformed how we manage our corporate events. The platform is intuitive and the customer support is exceptional.",
                        "We've increased our ticket sales by 40% since switching to Aayojana. The marketing tools are game-changing!",
                        "As a first-time event organizer, Aayojana made the process simple and stress-free. Highly recommended!"
                };
                String[] authorNames = {"Rahul Sharma", "Priya Patel", "Amit Singh"};
                String[] authorRoles = {"Event Manager, TechCorp", "Festival Organizer", "Wedding Planner"};

                for(int i = 0; i < 3; i++) {
            %>
            <div class="testimonial-card">
                <div class="testimonial-text">
                    "<%= testimonialTexts[i] %>"
                </div>
                <div class="testimonial-author">
                    <div class="author-image">
                        <img src="https://randomuser.me/api/portraits/men/<%= 20 + i %>.jpg" alt="<%= authorNames[i] %>">
                    </div>
                    <div class="author-info">
                        <h4><%= authorNames[i] %></h4>
                        <p><%= authorRoles[i] %></p>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Newsletter Section -->
<section class="newsletter">
    <div class="container">
        <div class="section-title">
            <h2>Stay Updated</h2>
            <p>Subscribe to our newsletter for the latest event trends and platform updates</p>
        </div>
        <form class="newsletter-form" action="subscribe.jsp" method="post">
            <input type="email" name="email" placeholder="Enter your email address" required>
            <button type="submit" class="btn btn-primary">Subscribe</button>
        </form>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-column">
                <h3>AayoJana</h3>
                <p>The platform for organizers and attendees.</p>
                <div class="social-linultimate event management ks">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="footer-column">
                <h3>Company</h3>
                <ul>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">Press</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Resources</h3>
                <ul>
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">Guides</a></li>
                    <li><a href="#">API Documentation</a></li>
                    <li><a href="#">Community</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Legal</h3>
                <ul>
                    <li><a href="#">Terms of Service</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Cookie Policy</a></li>
                    <li><a href="#">GDPR Compliance</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Aayojana. All rights reserved.</p>
        </div>
    </div>
</footer>

<script>
    // Simple JavaScript for demonstration
    document.addEventListener('DOMContentLoaded', function() {
        // You could add event listeners, animations, etc. here
        console.log('Aayojana Event Booking System loaded!');

        // Example: Highlight the current page in navigation
        const currentPage = window.location.pathname;
        const navLinks = document.querySelectorAll('nav ul li a');

        navLinks.forEach(link => {
            if(link.getAttribute('href') === currentPage) {
                link.style.color = '#5928E5';
            }
        });
    });
</script>
</body>
</html>