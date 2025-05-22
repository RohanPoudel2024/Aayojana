<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - Aayojana Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .policy-hero {
            padding: 120px 0 60px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            text-align: center;
        }
        
        .policy-hero h1 {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .policy-hero p {
            font-size: 18px;
            color: var(--gray);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .policy-content {
            padding: 60px 0;
        }
        
        .policy-container {
            max-width: 900px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 40px;
        }
        
        .last-updated {
            text-align: right;
            color: var(--gray);
            font-size: 14px;
            margin-bottom: 30px;
        }
        
        .policy-section {
            margin-bottom: 40px;
        }
        
        .policy-section h2 {
            color: var(--primary);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(89, 40, 229, 0.1);
        }
        
        .policy-section h3 {
            color: var(--dark);
            margin: 25px 0 15px;
        }
        
        .policy-section p, .policy-section ul {
            margin-bottom: 15px;
            line-height: 1.8;
            color: var(--gray);
        }
        
        .policy-section ul {
            padding-left: 20px;
        }
        
        .policy-section ul li {
            margin-bottom: 10px;
        }
        
        .contact-section {
            margin-top: 50px;
            padding: 25px;
            background-color: rgba(89, 40, 229, 0.05);
            border-radius: 10px;
        }
        
        .contact-section h3 {
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .table-of-contents {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .table-of-contents h3 {
            margin-bottom: 15px;
            color: var(--primary);
        }
        
        .table-of-contents ul {
            list-style-type: none;
            padding-left: 0;
        }
        
        .table-of-contents li {
            margin-bottom: 8px;
        }
        
        .table-of-contents a {
            color: var(--dark);
            text-decoration: none;
            transition: color 0.3s;
            display: flex;
            align-items: center;
        }
        
        .table-of-contents a:hover {
            color: var(--primary);
        }
        
        .table-of-contents a i {
            margin-right: 8px;
            color: var(--primary);
            font-size: 12px;
        }
    </style>
</head>
<body>
    <%@ include file="common/userHeader.jsp" %>

    <section class="policy-hero">
        <div class="container">
            <h1>Privacy Policy</h1>
            <p>We are committed to protecting your privacy and personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our platform.</p>
        </div>
    </section>

    <section class="policy-content">
        <div class="container">
            <div class="policy-container">
                <div class="last-updated">
                    <p>Last Updated: May 1, 2023</p>
                </div>
                
                <div class="table-of-contents">
                    <h3>Contents</h3>
                    <ul>
                        <li><a href="#introduction"><i class="fas fa-chevron-right"></i> Introduction</a></li>
                        <li><a href="#information-collection"><i class="fas fa-chevron-right"></i> Information We Collect</a></li>
                        <li><a href="#information-use"><i class="fas fa-chevron-right"></i> How We Use Your Information</a></li>
                        <li><a href="#information-sharing"><i class="fas fa-chevron-right"></i> Information Sharing and Disclosure</a></li>
                        <li><a href="#cookies"><i class="fas fa-chevron-right"></i> Cookies and Tracking Technologies</a></li>
                        <li><a href="#data-security"><i class="fas fa-chevron-right"></i> Data Security</a></li>
                        <li><a href="#user-rights"><i class="fas fa-chevron-right"></i> Your Rights and Choices</a></li>
                        <li><a href="#children"><i class="fas fa-chevron-right"></i> Children's Privacy</a></li>
                        <li><a href="#changes"><i class="fas fa-chevron-right"></i> Changes to This Privacy Policy</a></li>
                        <li><a href="#contact"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                    </ul>
                </div>
                
                <div id="introduction" class="policy-section">
                    <h2>1. Introduction</h2>
                    <p>Aayojana ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share information about you when you use our website, mobile applications, and services (collectively, the "Services").</p>
                    <p>By using our Services, you agree to the collection, use, and sharing of your information as described in this Privacy Policy. If you do not agree with our policies and practices, do not use our Services.</p>
                </div>
                
                <div id="information-collection" class="policy-section">
                    <h2>2. Information We Collect</h2>
                    <p>We collect several types of information from and about users of our Services, including:</p>
                    
                    <h3>2.1 Information You Provide to Us</h3>
                    <ul>
                        <li><strong>Account Information:</strong> When you register for an account, we collect your name, email address, password, and phone number.</li>
                        <li><strong>Profile Information:</strong> You may provide additional information for your profile such as a profile picture, bio, and location.</li>
                        <li><strong>Transaction Information:</strong> When you make a purchase, we collect payment information, billing details, and transaction history.</li>
                        <li><strong>Communications:</strong> If you contact us directly, we may receive additional information about you such as your name, email address, phone number, and the contents of the message.</li>
                    </ul>
                    
                    <h3>2.2 Information We Collect Automatically</h3>
                    <ul>
                        <li><strong>Usage Data:</strong> We collect information about your interactions with our Services, such as pages visited, time spent, and links clicked.</li>
                        <li><strong>Device Information:</strong> We collect information about the device you use to access our Services, including IP address, browser type, operating system, and device identifiers.</li>
                        <li><strong>Location Information:</strong> We may collect your precise or approximate location information, with your consent, to provide location-based services.</li>
                    </ul>
                    
                    <h3>2.3 Information from Third Parties</h3>
                    <p>We may receive information about you from third parties, such as:</p>
                    <ul>
                        <li>Social media platforms when you connect your account to our Services</li>
                        <li>Partners who help us verify your identity or prevent fraud</li>
                        <li>Event organizers who provide attendee lists</li>
                    </ul>
                </div>
                
                <div id="information-use" class="policy-section">
                    <h2>3. How We Use Your Information</h2>
                    <p>We use the information we collect for various purposes, including:</p>
                    <ul>
                        <li>To provide, maintain, and improve our Services</li>
                        <li>To process transactions and send related information</li>
                        <li>To create and maintain your account</li>
                        <li>To communicate with you about our Services, updates, and promotional offers</li>
                        <li>To personalize your experience and deliver content relevant to your interests</li>
                        <li>To respond to your comments, questions, and requests</li>
                        <li>To monitor and analyze trends, usage, and activities in connection with our Services</li>
                        <li>To detect, investigate, and prevent fraudulent transactions and other illegal activities</li>
                        <li>To comply with legal obligations</li>
                    </ul>
                </div>
                
                <div id="information-sharing" class="policy-section">
                    <h2>4. Information Sharing and Disclosure</h2>
                    <p>We may share your information in the following circumstances:</p>
                    
                    <h3>4.1 With Your Consent</h3>
                    <p>We may share your information when you give us your consent to do so, including if you choose to share information through our Services.</p>
                    
                    <h3>4.2 With Event Organizers</h3>
                    <p>If you register for an event, we share your information with the event organizer so they can manage your registration and attendance.</p>
                    
                    <h3>4.3 With Service Providers</h3>
                    <p>We may share your information with third-party vendors and service providers who perform services on our behalf, such as payment processing, data analysis, email delivery, and customer service.</p>
                    
                    <h3>4.4 For Legal Reasons</h3>
                    <p>We may share your information if we believe disclosure is necessary to:</p>
                    <ul>
                        <li>Comply with applicable laws, regulations, legal processes, or governmental requests</li>
                        <li>Enforce our Terms of Service, including investigating potential violations</li>
                        <li>Detect, prevent, or address fraud, security, or technical issues</li>
                        <li>Protect against harm to the rights, property, or safety of Aayojana, our users, or the public</li>
                    </ul>
                    
                    <h3>4.5 Business Transfers</h3>
                    <p>If Aayojana is involved in a merger, acquisition, or sale of all or a portion of its assets, your information may be transferred as part of that transaction.</p>
                </div>
                
                <div id="cookies" class="policy-section">
                    <h2>5. Cookies and Tracking Technologies</h2>
                    <p>We use cookies and similar tracking technologies to track activity on our Services and hold certain information. Cookies are files with a small amount of data that may include an anonymous unique identifier.</p>
                    <p>We use cookies for the following purposes:</p>
                    <ul>
                        <li>To keep you logged in to our Services</li>
                        <li>To remember your preferences and settings</li>
                        <li>To understand how you use our Services</li>
                        <li>To analyze trends and gather demographic information</li>
                        <li>To help us develop and improve our Services</li>
                        <li>To deliver targeted advertisements</li>
                    </ul>
                    <p>You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Services.</p>
                </div>
                
                <div id="data-security" class="policy-section">
                    <h2>6. Data Security</h2>
                    <p>We take reasonable measures to help protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction. However, no method of electronic transmission or storage is 100% secure, and we cannot guarantee absolute security.</p>
                    <p>You are responsible for maintaining the confidentiality of your account credentials and for any activities that occur under your account. We encourage you to use a strong, unique password for your Aayojana account and to not reuse passwords across different services.</p>
                </div>
                
                <div id="user-rights" class="policy-section">
                    <h2>7. Your Rights and Choices</h2>
                    <p>Depending on your location, you may have certain rights regarding your personal information, including:</p>
                    <ul>
                        <li>Accessing, correcting, or deleting your personal information</li>
                        <li>Withdrawing your consent at any time, where we rely on consent to process your information</li>
                        <li>Requesting that we restrict the processing of your personal information</li>
                        <li>Requesting portability of your personal information</li>
                        <li>Opting out of marketing communications</li>
                    </ul>
                    <p>To exercise these rights, please contact us using the information provided in the "Contact Us" section below.</p>
                </div>
                
                <div id="children" class="policy-section">
                    <h2>8. Children's Privacy</h2>
                    <p>Our Services are not directed to children under the age of 13, and we do not knowingly collect personal information from children under 13. If you become aware that a child has provided us with personal information without parental consent, please contact us, and we will take steps to remove such information and terminate the child's account.</p>
                </div>
                
                <div id="changes" class="policy-section">
                    <h2>9. Changes to This Privacy Policy</h2>
                    <p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date at the top. You are advised to review this Privacy Policy periodically for any changes.</p>
                    <p>Your continued use of the Services after we post changes to the Privacy Policy means that you accept and agree to the changes.</p>
                </div>
                
                <div id="contact" class="policy-section contact-section">
                    <h2>10. Contact Us</h2>
                    <p>If you have any questions about this Privacy Policy or our privacy practices, please contact us at:</p>
                    <p><strong>Email:</strong> <a href="mailto:privacy@aayojana.com">privacy@aayojana.com</a></p>
                    <p><strong>Address:</strong> 123 Tech Park, Koramangala, Bengaluru, Karnataka 560034, India</p>
                    <p>We will respond to your request within a reasonable timeframe.</p>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>
</body>
</html>
