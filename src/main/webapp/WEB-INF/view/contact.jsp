<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Aayojana Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .contact-hero {
            padding: 120px 0 60px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            text-align: center;
        }
        
        .contact-hero h1 {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .contact-hero p {
            font-size: 18px;
            color: var(--gray);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .contact-content {
            padding: 60px 0;
        }
        
        .contact-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
        }
        
        .contact-form {
            flex: 2;
            min-width: 300px;
        }
        
        .contact-form h2 {
            margin-bottom: 30px;
            color: var(--primary);
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }
        
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
        
        .submit-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
        }
        
        .submit-btn:hover {
            background-color: var(--primary-dark);
        }
        
        .contact-info {
            flex: 1;
            min-width: 300px;
        }
        
        .contact-info h2 {
            margin-bottom: 30px;
            color: var(--primary);
        }
        
        .info-card {
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        
        .info-card .icon {
            font-size: 24px;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .info-card h3 {
            margin-bottom: 10px;
            color: var(--dark);
        }
        
        .info-card p, .info-card a {
            color: var(--gray);
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .info-card a:hover {
            color: var(--primary);
        }
        
        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: rgba(89, 40, 229, 0.1);
            border-radius: 50%;
            color: var(--primary);
            transition: all 0.3s;
        }
        
        .social-links a:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .map-section {
            padding-bottom: 60px;
        }
        
        .map-section h2 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary);
        }
        
        .map-container {
            height: 400px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .map-container iframe {
            width: 100%;
            height: 100%;
            border: 0;
        }
    </style>
</head>
<body>
    <%@ include file="common/userHeader.jsp" %>

    <section class="contact-hero">
        <div class="container">
            <h1>Get In Touch</h1>
            <p>Have questions or need assistance? We're here to help you with anything related to event booking and management.</p>
        </div>
    </section>

    <section class="contact-content">
        <div class="container">
            <div class="contact-layout">
                <div class="contact-form">
                    <h2>Send Us a Message</h2>
                    <form action="${pageContext.request.contextPath}/contact" method="post">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="message">Your Message</label>
                            <textarea id="message" name="message" class="form-control" required></textarea>
                        </div>
                        <button type="submit" class="submit-btn">Send Message</button>
                    </form>
                </div>
                <div class="contact-info">
                    <h2>Contact Information</h2>
                    <div class="info-card">
                        <div class="icon"><i class="fas fa-map-marker-alt"></i></div>
                        <h3>Our Office</h3>
                        <p>123 Tech Park, Koramangala<br>Bengaluru, Karnataka 560034<br>India</p>
                    </div>
                    <div class="info-card">
                        <div class="icon"><i class="fas fa-phone-alt"></i></div>
                        <h3>Phone</h3>
                        <p><a href="tel:+918026529999">+91 80 2652 9999</a></p>
                        <p><a href="tel:+918026529000">+91 80 2652 9000</a> (Support)</p>
                    </div>
                    <div class="info-card">
                        <div class="icon"><i class="fas fa-envelope"></i></div>
                        <h3>Email</h3>
                        <p><a href="mailto:info@aayojana.com">info@aayojana.com</a></p>
                        <p><a href="mailto:support@aayojana.com">support@aayojana.com</a></p>
                    </div>
                    <div class="info-card">
                        <div class="icon"><i class="fas fa-clock"></i></div>
                        <h3>Working Hours</h3>
                        <p>Monday - Friday: 9:00 AM - 6:00 PM</p>
                        <p>Saturday: 10:00 AM - 2:00 PM</p>
                        <p>Sunday: Closed</p>
                    </div>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="map-section">
        <div class="container">
            <h2>Our Location</h2>
            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3888.5831481155313!2d77.62498307489111!3d12.93442871556087!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bae15be2c69cc2f%3A0xb62a0ba19dd64e55!2sKoramangala%2C%20Bengaluru%2C%20Karnataka!5e0!3m2!1sen!2sin!4v1684695786394!5m2!1sen!2sin" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>
</body>
</html>
