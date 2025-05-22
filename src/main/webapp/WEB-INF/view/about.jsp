<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Aayojana - Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .about-section {
            padding: 120px 0 60px;
        }
        
        .about-content {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            margin-bottom: 60px;
        }
        
        .about-text {
            flex: 1;
            min-width: 300px;
        }
        
        .about-image {
            flex: 1;
            min-width: 300px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .about-image img {
            width: 100%;
            height: auto;
            display: block;
        }
        
        .about-text h2 {
            font-size: 36px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .about-text p {
            margin-bottom: 20px;
            line-height: 1.8;
            color: var(--gray);
        }
        
        .mission-values {
            background-color: #f8f9fa;
            padding: 60px 0;
        }
        
        .mission-values h2 {
            text-align: center;
            margin-bottom: 50px;
            color: var(--primary);
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }
        
        .value-card {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
        }
        
        .value-card:hover {
            transform: translateY(-10px);
        }
        
        .value-icon {
            width: 60px;
            height: 60px;
            background-color: rgba(89, 40, 229, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
        
        .value-icon i {
            font-size: 24px;
            color: var(--primary);
        }
        
        .value-card h3 {
            margin-bottom: 15px;
            color: var(--dark);
        }
        
        .team-section {
            padding: 60px 0;
        }
        
        .team-section h2 {
            text-align: center;
            margin-bottom: 50px;
            color: var(--primary);
        }
        
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }
        
        .team-member {
            text-align: center;
        }
        
        .member-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 20px;
            border: 5px solid rgba(89, 40, 229, 0.1);
        }
        
        .member-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .team-member h3 {
            margin-bottom: 5px;
            color: var(--dark);
        }
        
        .team-member p {
            color: var(--gray);
            margin-bottom: 15px;
        }
        
        .social-links {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        
        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background-color: rgba(89, 40, 229, 0.1);
            border-radius: 50%;
            color: var(--primary);
            transition: all 0.3s;
        }
        
        .social-links a:hover {
            background-color: var(--primary);
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="common/userHeader.jsp" %>

    <section class="about-section">
        <div class="container">
            <div class="about-content">
                <div class="about-text">
                    <h2>About Aayojana</h2>
                    <p>Aayojana (meaning "planning" in Sanskrit) was founded in 2022 with a vision to transform how events are organized and experienced in India. What started as a small team of passionate event enthusiasts has grown into a comprehensive platform serving thousands of event creators and attendees nationwide.</p>
                    <p>Our mission is to make event planning and attendance as seamless as possible. We provide organizers with powerful tools to create, manage, and promote their events, while giving attendees a simple way to discover and book tickets for experiences they'll love.</p>
                    <p>Today, Aayojana is the preferred platform for events of all sizes - from intimate workshops to large-scale conferences, cultural festivals to technical summits. We're proud to have helped facilitate over 5,000 successful events and counting.</p>
                </div>
                <div class="about-image">
                    <img src="https://images.unsplash.com/photo-1540317580384-e5d43867caa6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80" alt="Aayojana Team">
                </div>
            </div>
        </div>
    </section>

    <section class="mission-values">
        <div class="container">
            <h2>Our Values</h2>
            <div class="values-grid">
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <h3>Trust & Transparency</h3>
                    <p>We believe in building trust through transparent practices. From clear pricing to honest communication, we ensure all stakeholders are respected.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <h3>Innovation</h3>
                    <p>We constantly seek new ways to improve the event experience. Our team is dedicated to developing innovative solutions that address real needs.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Community</h3>
                    <p>We're more than a platform - we're building a community of event lovers. We celebrate the connections and experiences that events create.</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-globe-asia"></i>
                    </div>
                    <h3>Inclusivity</h3>
                    <p>We strive to make our platform accessible to everyone. We embrace diversity and ensure our tools work for events of all types and sizes.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="team-section">
        <div class="container">
            <h2>Meet Our Team</h2>
            <div class="team-grid">
                <div class="team-member">
                    <div class="member-image">
                        <img src="https://randomuser.me/api/portraits/women/45.jpg" alt="Ananya Sharma">
                    </div>
                    <h3>Ananya Sharma</h3>
                    <p>Founder & CEO</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Vikram Patel">
                    </div>
                    <h3>Vikram Patel</h3>
                    <p>CTO</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#"><i class="fab fa-github"></i></a>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Meera Desai">
                    </div>
                    <h3>Meera Desai</h3>
                    <p>Head of Operations</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="https://randomuser.me/api/portraits/men/75.jpg" alt="Rohan Joshi">
                    </div>
                    <h3>Rohan Joshi</h3>
                    <p>Lead Developer</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#"><i class="fab fa-github"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>
</body>
</html>
