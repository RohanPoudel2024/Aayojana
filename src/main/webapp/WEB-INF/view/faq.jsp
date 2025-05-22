<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - Aayojana Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .faq-hero {
            padding: 120px 0 60px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            text-align: center;
        }
        
        .faq-hero h1 {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .faq-hero p {
            font-size: 18px;
            color: var(--gray);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .faq-content {
            padding: 60px 0;
        }
        
        .faq-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
        }
        
        .faq-main {
            flex: 2;
            min-width: 300px;
        }
        
        .faq-sidebar {
            flex: 1;
            min-width: 250px;
        }
        
        .faq-categories {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        
        .faq-categories h3 {
            margin-bottom: 20px;
            color: var(--primary);
        }
        
        .category-list {
            list-style: none;
        }
        
        .category-list li {
            margin-bottom: 15px;
        }
        
        .category-list a {
            display: flex;
            align-items: center;
            color: var(--dark);
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .category-list a:hover {
            color: var(--primary);
        }
        
        .category-list a i {
            margin-right: 10px;
            color: var(--primary);
        }
        
        .faq-contact {
            background-color: rgba(89, 40, 229, 0.1);
            border-radius: 10px;
            padding: 30px;
            text-align: center;
        }
        
        .faq-contact h3 {
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .faq-contact p {
            color: var(--gray);
            margin-bottom: 20px;
        }
        
        .faq-contact .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .faq-section {
            margin-bottom: 40px;
        }
        
        .faq-section h2 {
            color: var(--primary);
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(89, 40, 229, 0.1);
        }
        
        .faq-accordion {
            margin-bottom: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .faq-question {
            background-color: white;
            padding: 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.3s;
        }
        
        .faq-question:hover {
            background-color: rgba(89, 40, 229, 0.05);
        }
        
        .faq-question h3 {
            font-size: 18px;
            color: var(--dark);
            margin: 0;
        }
        
        .faq-question .icon {
            font-size: 20px;
            color: var(--primary);
            transition: transform 0.3s;
        }
        
        .faq-answer {
            background-color: white;
            padding: 0;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s, padding 0.3s;
        }
        
        .faq-answer-content {
            padding: 0 20px;
            color: var(--gray);
            line-height: 1.8;
        }
        
        .faq-accordion.active .faq-question {
            background-color: rgba(89, 40, 229, 0.1);
        }
        
        .faq-accordion.active .icon {
            transform: rotate(180deg);
        }
        
        .faq-accordion.active .faq-answer {
            max-height: 1000px;
            padding: 20px;
        }
        
        .faq-search {
            margin-bottom: 40px;
            position: relative;
        }
        
        .faq-search input {
            width: 100%;
            padding: 15px 20px 15px 50px;
            border-radius: 10px;
            border: 1px solid #ddd;
            font-size: 16px;
            transition: border-color 0.3s, box-shadow 0.3s;
            font-family: 'Poppins', sans-serif;
        }
        
        .faq-search input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(89, 40, 229, 0.1);
        }
        
        .faq-search i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
            font-size: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="common/userHeader.jsp" %>

    <section class="faq-hero">
        <div class="container">
            <h1>Frequently Asked Questions</h1>
            <p>Find answers to the most common questions about using Aayojana for event booking and management.</p>
        </div>
    </section>

    <section class="faq-content">
        <div class="container">
            <div class="faq-search">
                <i class="fas fa-search"></i>
                <input type="text" id="faqSearch" placeholder="Search for questions..." onkeyup="searchFAQs()">
            </div>
            
            <div class="faq-layout">
                <div class="faq-main">
                    <div class="faq-section" id="general">
                        <h2>General Questions</h2>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>What is Aayojana?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Aayojana is a comprehensive event booking and management platform designed to help organizers create and manage events of all sizes, while making it easy for attendees to discover and book tickets for events they're interested in.</p>
                                    <p>Our platform provides tools for venue selection, ticket sales, attendee management, marketing, and more, all in one place.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How do I create an account?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Creating an account on Aayojana is simple:</p>
                                    <ol>
                                        <li>Click on the "Sign Up" button in the top-right corner of the homepage</li>
                                        <li>Enter your name, email address, and create a password</li>
                                        <li>Click "Create Account"</li>
                                        <li>Verify your email address by clicking the link in the confirmation email</li>
                                    </ol>
                                    <p>Once your account is created, you can immediately start browsing and booking events, or set up your profile to organize your own events.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>Is Aayojana available internationally?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Currently, Aayojana primarily serves the Indian market, with plans to expand to other countries in the future. Our payment processing, time zones, and support services are optimized for Indian users.</p>
                                    <p>However, international users can still create accounts and browse events. If you're an international organizer interested in using Aayojana for your events in India, please contact our support team for assistance.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="faq-section" id="attendees">
                        <h2>For Attendees</h2>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How do I find events that interest me?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Aayojana offers several ways to discover events:</p>
                                    <ul>
                                        <li>Browse the featured events on our homepage</li>
                                        <li>Use the search bar to look for specific events, organizers, or venues</li>
                                        <li>Filter events by category, date, location, or price</li>
                                        <li>Check out the "Upcoming Events" section for the latest additions</li>
                                        <li>Follow organizers or categories you're interested in to get personalized recommendations</li>
                                    </ul>
                                    <p>You can also enable notifications to be alerted when new events matching your interests are added.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How do I book tickets for an event?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Booking tickets on Aayojana is a straightforward process:</p>
                                    <ol>
                                        <li>Find an event you're interested in and click on it to view details</li>
                                        <li>Click the "Book Now" button</li>
                                        <li>Select the number of tickets you want to purchase</li>
                                        <li>Review your booking details</li>
                                        <li>Complete the payment using one of our supported payment methods</li>
                                        <li>Once payment is confirmed, you'll receive your e-tickets via email and they'll also be available in your account</li>
                                    </ol>
                                    <p>Note that you need to be logged in to book tickets. If you haven't created an account yet, you'll be prompted to do so during the booking process.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>Can I cancel or get a refund for my tickets?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Refund policies are set by event organizers, not by Aayojana directly. Each event has its own refund policy, which you can find on the event details page before making a booking.</p>
                                    <p>To request a cancellation or refund:</p>
                                    <ol>
                                        <li>Go to your "My Bookings" page</li>
                                        <li>Find the booking you want to cancel</li>
                                        <li>Click on the "Cancel Booking" or "Request Refund" button (if available)</li>
                                        <li>Follow the instructions to complete your request</li>
                                    </ol>
                                    <p>Please note that some events may not allow cancellations or refunds, while others might have a deadline after which cancellations are not accepted. Processing times for refunds typically take 5-7 business days, depending on your payment method.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="faq-section" id="organizers">
                        <h2>For Organizers</h2>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How do I create an event on Aayojana?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>To create an event on Aayojana:</p>
                                    <ol>
                                        <li>Log in to your organizer account</li>
                                        <li>Go to your dashboard and click "Create Event"</li>
                                        <li>Fill in the event details including title, description, venue, date and time, and ticket information</li>
                                        <li>Upload event images and set up your custom event page</li>
                                        <li>Configure your ticket types, prices, and availability</li>
                                        <li>Set up payment options and refund policies</li>
                                        <li>Review all details and publish your event</li>
                                    </ol>
                                    <p>Once your event is published, it will be visible to users browsing Aayojana, and you can start selling tickets right away.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>What fees does Aayojana charge organizers?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Aayojana uses a simple fee structure for event organizers:</p>
                                    <ul>
                                        <li>Basic plan: 3.5% + ₹20 per paid ticket (free events are completely free)</li>
                                        <li>Pro plan: 2.5% + ₹15 per paid ticket (₹1,999/month subscription)</li>
                                        <li>Enterprise plan: Custom pricing for large-scale events and organizations</li>
                                    </ul>
                                    <p>Payment processing fees (typically 2-3% depending on the payment method) are charged separately.</p>
                                    <p>You can choose to absorb these fees yourself or pass them on to attendees during the ticket setup process. All fees are clearly displayed before you publish your event.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How and when do I get paid for ticket sales?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>For standard events, Aayojana offers two payout options:</p>
                                    <ol>
                                        <li><strong>Regular payouts:</strong> Funds are transferred to your bank account on a weekly basis for all tickets sold up to that point</li>
                                        <li><strong>Event completion payout:</strong> Funds are transferred within 5-7 business days after your event concludes</li>
                                    </ol>
                                    <p>For large events or established organizers, we also offer custom payout schedules including advance partial payouts.</p>
                                    <p>All payouts are made directly to the bank account you've specified in your organizer profile. You can track all your sales and upcoming payouts in your financial dashboard.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="faq-section" id="payments">
                        <h2>Payments & Security</h2>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>What payment methods are supported?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Aayojana supports a wide range of payment methods, including:</p>
                                    <ul>
                                        <li>Credit and debit cards (Visa, Mastercard, RuPay, American Express)</li>
                                        <li>Net banking</li>
                                        <li>UPI (Google Pay, PhonePe, Paytm, etc.)</li>
                                        <li>Mobile wallets (Paytm, Amazon Pay, etc.)</li>
                                        <li>Pay Later options (select events only)</li>
                                    </ul>
                                    <p>All payments are processed securely through our trusted payment gateways, ensuring your financial information is protected.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>Is my personal information secure?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Yes, Aayojana takes data security very seriously. We implement multiple layers of protection to ensure your information remains safe:</p>
                                    <ul>
                                        <li>All sensitive data is encrypted both in transit and at rest</li>
                                        <li>We use HTTPS for all communications between your browser and our servers</li>
                                        <li>Payment information is processed through PCI-DSS compliant payment gateways</li>
                                        <li>We regularly conduct security audits and penetration testing</li>
                                        <li>Our privacy policy clearly outlines how we collect, use, and protect your data</li>
                                    </ul>
                                    <p>We only collect information that's necessary to provide our services, and we never sell your personal data to third parties.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="faq-section" id="technical">
                        <h2>Technical Support</h2>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>What should I do if I encounter an issue with the website?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>If you're experiencing technical issues with Aayojana, try these steps:</p>
                                    <ol>
                                        <li>Refresh the page or restart your browser</li>
                                        <li>Clear your browser cache and cookies</li>
                                        <li>Try using a different browser or device</li>
                                        <li>Check our status page at status.aayojana.com to see if there are any known issues</li>
                                    </ol>
                                    <p>If the problem persists, please contact our support team through:</p>
                                    <ul>
                                        <li>Live chat support (available on the website during business hours)</li>
                                        <li>Email: support@aayojana.com</li>
                                        <li>Phone: +91 80 2652 9000 (10 AM - 6 PM IST, Monday to Friday)</li>
                                    </ul>
                                    <p>When reporting an issue, please include details like the device and browser you're using, the specific page where you encountered the problem, and any error messages you saw. Screenshots are also very helpful.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="faq-accordion">
                            <div class="faq-question" onclick="toggleFAQ(this)">
                                <h3>How can I contact customer support?</h3>
                                <span class="icon"><i class="fas fa-chevron-down"></i></span>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">
                                    <p>Our customer support team is available through multiple channels:</p>
                                    <ul>
                                        <li><strong>Email:</strong> support@aayojana.com (response within 24 hours)</li>
                                        <li><strong>Live Chat:</strong> Available on our website from 9 AM to 8 PM IST every day</li>
                                        <li><strong>Phone:</strong> +91 80 2652 9000 (10 AM - 6 PM IST, Monday to Friday)</li>
                                        <li><strong>Help Center:</strong> Browse our comprehensive knowledge base at help.aayojana.com</li>
                                    </ul>
                                    <p>For urgent issues related to ongoing events, organizers have access to a priority support line shared during the event setup process.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="faq-sidebar">
                    <div class="faq-categories">
                        <h3>Categories</h3>
                        <ul class="category-list">
                            <li><a href="#general"><i class="fas fa-circle-info"></i> General Questions</a></li>
                            <li><a href="#attendees"><i class="fas fa-ticket-alt"></i> For Attendees</a></li>
                            <li><a href="#organizers"><i class="fas fa-user-tie"></i> For Organizers</a></li>
                            <li><a href="#payments"><i class="fas fa-credit-card"></i> Payments & Security</a></li>
                            <li><a href="#technical"><i class="fas fa-headset"></i> Technical Support</a></li>
                        </ul>
                    </div>
                    
                    <div class="faq-contact">
                        <h3>Still Have Questions?</h3>
                        <p>Our support team is ready to help you with any concerns or questions you may have.</p>
                        <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Contact Us
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>

    <script>
        function toggleFAQ(element) {
            const accordion = element.parentElement;
            accordion.classList.toggle('active');
        }
        
        function searchFAQs() {
            const searchText = document.getElementById('faqSearch').value.toLowerCase();
            const questions = document.querySelectorAll('.faq-question h3');
            
            questions.forEach(question => {
                const accordion = question.closest('.faq-accordion');
                const questionText = question.textContent.toLowerCase();
                const answerText = accordion.querySelector('.faq-answer-content').textContent.toLowerCase();
                
                if (questionText.includes(searchText) || answerText.includes(searchText)) {
                    accordion.style.display = 'block';
                } else {
                    accordion.style.display = 'none';
                }
            });
        }
        
        // Add smooth scrolling for category links
        document.querySelectorAll('.category-list a').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                window.scrollTo({
                    top: targetElement.offsetTop - 100,
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>
