<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms of Service - Aayojana Event Booking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .terms-hero {
            padding: 120px 0 60px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            text-align: center;
        }
        
        .terms-hero h1 {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .terms-hero p {
            font-size: 18px;
            color: var(--gray);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .terms-content {
            padding: 60px 0;
        }
        
        .terms-container {
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
        
        .terms-section {
            margin-bottom: 40px;
        }
        
        .terms-section h2 {
            color: var(--primary);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(89, 40, 229, 0.1);
        }
        
        .terms-section h3 {
            color: var(--dark);
            margin: 25px 0 15px;
        }
        
        .terms-section p, .terms-section ul, .terms-section ol {
            margin-bottom: 15px;
            line-height: 1.8;
            color: var(--gray);
        }
        
        .terms-section ul, .terms-section ol {
            padding-left: 20px;
        }
        
        .terms-section ul li, .terms-section ol li {
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

    <section class="terms-hero">
        <div class="container">
            <h1>Terms of Service</h1>
            <p>Please read these Terms of Service carefully before using Aayojana. By accessing or using our platform, you agree to be bound by these terms.</p>
        </div>
    </section>

    <section class="terms-content">
        <div class="container">
            <div class="terms-container">
                <div class="last-updated">
                    <p>Last Updated: May 1, 2023</p>
                </div>
                
                <div class="table-of-contents">
                    <h3>Contents</h3>
                    <ul>
                        <li><a href="#agreement"><i class="fas fa-chevron-right"></i> Agreement to Terms</a></li>
                        <li><a href="#changes"><i class="fas fa-chevron-right"></i> Changes to Terms</a></li>
                        <li><a href="#account"><i class="fas fa-chevron-right"></i> Account Registration and Security</a></li>
                        <li><a href="#event-bookings"><i class="fas fa-chevron-right"></i> Event Bookings and Tickets</a></li>
                        <li><a href="#cancellations"><i class="fas fa-chevron-right"></i> Cancellations and Refunds</a></li>
                        <li><a href="#conduct"><i class="fas fa-chevron-right"></i> User Conduct</a></li>
                        <li><a href="#intellectual-property"><i class="fas fa-chevron-right"></i> Intellectual Property</a></li>
                        <li><a href="#disclaimers"><i class="fas fa-chevron-right"></i> Disclaimers</a></li>
                        <li><a href="#limitation"><i class="fas fa-chevron-right"></i> Limitation of Liability</a></li>
                        <li><a href="#indemnification"><i class="fas fa-chevron-right"></i> Indemnification</a></li>
                        <li><a href="#disputes"><i class="fas fa-chevron-right"></i> Dispute Resolution</a></li>
                        <li><a href="#termination"><i class="fas fa-chevron-right"></i> Termination</a></li>
                        <li><a href="#contact"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                    </ul>
                </div>
                
                <div id="agreement" class="terms-section">
                    <h2>1. Agreement to Terms</h2>
                    <p>These Terms of Service ("Terms") constitute a legally binding agreement between you and Aayojana ("we," "us," or "our") governing your access to and use of the Aayojana website, mobile applications, and services (collectively, the "Services").</p>
                    <p>By accessing or using our Services, you agree to be bound by these Terms. If you do not agree to these Terms, you must not access or use our Services.</p>
                </div>
                
                <div id="changes" class="terms-section">
                    <h2>2. Changes to Terms</h2>
                    <p>We reserve the right to modify these Terms at any time. If we make changes to these Terms, we will post the revised Terms on our website and update the "Last Updated" date at the top of these Terms. We will also notify you of material changes by email or through the Services.</p>
                    <p>By continuing to access or use our Services after these revisions become effective, you agree to be bound by the revised Terms. If you do not agree to the new Terms, you must stop using the Services.</p>
                </div>
                
                <div id="account" class="terms-section">
                    <h2>3. Account Registration and Security</h2>
                    <p>To use certain features of our Services, you may need to create an account and provide certain information about yourself. You represent and warrant that all information you provide is accurate, current, and complete, and you agree to update your information as necessary to maintain its accuracy.</p>
                    
                    <h3>3.1 Account Eligibility</h3>
                    <p>You must be at least 18 years old to create an account. If you are creating an account on behalf of a company or organization, you represent and warrant that you have the authority to bind that company or organization to these Terms.</p>
                    
                    <h3>3.2 Account Security</h3>
                    <p>You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to:</p>
                    <ul>
                        <li>Create a strong, unique password</li>
                        <li>Notify us immediately of any unauthorized use of your account or any other breach of security</li>
                        <li>Ensure that you log out of your account at the end of each session when accessing the Services on a shared device</li>
                    </ul>
                    <p>We will not be liable for any loss or damage arising from your failure to protect your account credentials or comply with these security obligations.</p>
                </div>
                
                <div id="event-bookings" class="terms-section">
                    <h2>4. Event Bookings and Tickets</h2>
                    
                    <h3>4.1 Booking Process</h3>
                    <p>When you book tickets for an event through our Services, you are entering into a contract with the event organizer, not with Aayojana. We act as an intermediary platform facilitating the transaction between you and the event organizer.</p>
                    <p>You acknowledge that:</p>
                    <ul>
                        <li>Tickets are subject to availability</li>
                        <li>Prices and availability may change at any time before you complete your booking</li>
                        <li>Your booking is not confirmed until you receive a confirmation email with ticket details</li>
                    </ul>
                    
                    <h3>4.2 Ticket Transfer and Resale</h3>
                    <p>Unless otherwise specified by the event organizer, tickets purchased through our Services:</p>
                    <ul>
                        <li>May not be transferred or resold for commercial purposes</li>
                        <li>May not be used for advertising, promotions, contests, or sweepstakes without the express written consent of the event organizer and Aayojana</li>
                        <li>May be subject to additional terms and conditions imposed by the event organizer</li>
                    </ul>
                    
                    <h3>4.3 Event Changes and Cancellations</h3>
                    <p>Event details, including date, time, location, and lineup, are subject to change. While we will make reasonable efforts to inform you of changes, it is ultimately your responsibility to verify the event details before attending.</p>
                    <p>If an event is canceled by the organizer, your eligibility for a refund will be determined by the event organizer's refund policy.</p>
                </div>
                
                <div id="cancellations" class="terms-section">
                    <h2>5. Cancellations and Refunds</h2>
                    
                    <h3>5.1 Attendee Cancellations</h3>
                    <p>If you wish to cancel a booking, cancellation terms will vary depending on the event organizer's policies. These policies will be communicated to you during the booking process.</p>
                    <p>In general:</p>
                    <ul>
                        <li>Some events may not allow cancellations or refunds</li>
                        <li>Others may allow cancellations with a full or partial refund within a specified timeframe</li>
                        <li>Cancellation requests must be submitted through your Aayojana account or by contacting our customer support</li>
                    </ul>
                    
                    <h3>5.2 Event Cancellations</h3>
                    <p>If an event is canceled by the organizer:</p>
                    <ul>
                        <li>Refunds will be processed according to the event organizer's refund policy</li>
                        <li>We will notify registered attendees via email and through the Services</li>
                        <li>Refunds may take up to 15 business days to process, depending on your payment method</li>
                    </ul>
                    
                    <h3>5.3 Service Fees</h3>
                    <p>In some cases, service fees charged by Aayojana may be non-refundable, even if the ticket price is refunded. This will be clearly communicated during the booking process.</p>
                </div>
                
                <div id="conduct" class="terms-section">
                    <h2>6. User Conduct</h2>
                    <p>You agree not to engage in any of the following prohibited activities:</p>
                    <ul>
                        <li>Violating any applicable laws, regulations, or third-party rights</li>
                        <li>Using the Services for any illegal purpose or to promote illegal activities</li>
                        <li>Attempting to impersonate another user, person, or entity</li>
                        <li>Posting or transmitting unauthorized commercial communications (spam)</li>
                        <li>Collecting users' content or information without their consent</li>
                        <li>Uploading viruses or other malicious code</li>
                        <li>Interfering with or disrupting the Services or servers connected to the Services</li>
                        <li>Bypassing measures we may use to prevent or restrict access to the Services</li>
                        <li>Creating multiple accounts for deceptive or fraudulent purposes</li>
                    </ul>
                    <p>We reserve the right to remove content and/or suspend or terminate accounts that violate these conduct guidelines.</p>
                </div>
                
                <div id="intellectual-property" class="terms-section">
                    <h2>7. Intellectual Property</h2>
                    
                    <h3>7.1 Aayojana's Intellectual Property</h3>
                    <p>The Services, including their content, features, and functionality, are owned by Aayojana and are protected by copyright, trademark, and other intellectual property laws.</p>
                    <p>These Terms do not grant you any right, title, or interest in the Services or our intellectual property.</p>
                    
                    <h3>7.2 User Content</h3>
                    <p>You retain ownership of any content you submit, post, or display on or through the Services ("User Content").</p>
                    <p>By posting User Content, you grant us a non-exclusive, transferable, sub-licensable, royalty-free, worldwide license to use, copy, modify, create derivative works based on, distribute, publicly display, and publicly perform your User Content in connection with operating and providing the Services.</p>
                    
                    <h3>7.3 Content Guidelines</h3>
                    <p>You represent and warrant that your User Content:</p>
                    <ul>
                        <li>Is accurate and not misleading</li>
                        <li>Does not violate any applicable law or regulation</li>
                        <li>Does not infringe any intellectual property or other rights of any third party</li>
                        <li>Does not contain any defamatory, obscene, offensive, or otherwise objectionable material</li>
                    </ul>
                    <p>We reserve the right to remove User Content that violates these guidelines or these Terms.</p>
                </div>
                
                <div id="disclaimers" class="terms-section">
                    <h2>8. Disclaimers</h2>
                    <p>THE SERVICES ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED.</p>
                    <p>TO THE FULLEST EXTENT PERMITTED BY LAW, AAYOJANA DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.</p>
                    <p>WE DO NOT WARRANT THAT:</p>
                    <ul>
                        <li>THE SERVICES WILL FUNCTION UNINTERRUPTED, SECURE, OR AVAILABLE AT ANY PARTICULAR TIME OR LOCATION</li>
                        <li>ANY ERRORS OR DEFECTS WILL BE CORRECTED</li>
                        <li>THE SERVICES ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS</li>
                        <li>THE RESULTS OF USING THE SERVICES WILL MEET YOUR REQUIREMENTS</li>
                    </ul>
                    <p>We are not responsible for the conduct of event organizers or attendees, either online or offline.</p>
                </div>
                
                <div id="limitation" class="terms-section">
                    <h2>9. Limitation of Liability</h2>
                    <p>TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL AAYOJANA, ITS AFFILIATES, OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE FOR ANY INDIRECT, PUNITIVE, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES, INCLUDING WITHOUT LIMITATION DAMAGES FOR LOSS OF PROFITS, GOODWILL, USE, DATA, OR OTHER INTANGIBLE LOSSES, THAT RESULT FROM THE USE OF, OR INABILITY TO USE, THE SERVICES.</p>
                    <p>IN NO EVENT WILL OUR TOTAL LIABILITY TO YOU FOR ALL CLAIMS, DAMAGES, LOSSES, AND CAUSES OF ACTION ARISING OUT OF OR RELATING TO THESE TERMS OR YOUR USE OF THE SERVICES EXCEED THE AMOUNT PAID BY YOU TO AAYOJANA DURING THE 12-MONTH PERIOD PRIOR TO THE CLAIM OR ONE THOUSAND RUPEES (₹1,000), WHICHEVER IS GREATER.</p>
                    <p>THESE LIMITATIONS OF LIABILITY APPLY WHETHER THE ALLEGED LIABILITY IS BASED ON CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY, OR ANY OTHER BASIS, EVEN IF AAYOJANA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>
                </div>
                
                <div id="indemnification" class="terms-section">
                    <h2>10. Indemnification</h2>
                    <p>You agree to defend, indemnify, and hold harmless Aayojana, its affiliates, officers, directors, employees, and agents from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney's fees) arising from:</p>
                    <ul>
                        <li>Your use of and access to the Services</li>
                        <li>Your violation of any term of these Terms</li>
                        <li>Your violation of any third-party right, including without limitation any copyright, property, or privacy right</li>
                        <li>Any claim that your User Content caused damage to a third party</li>
                    </ul>
                    <p>This defense and indemnification obligation will survive these Terms and your use of the Services.</p>
                </div>
                
                <div id="disputes" class="terms-section">
                    <h2>11. Dispute Resolution</h2>
                    
                    <h3>11.1 Governing Law</h3>
                    <p>These Terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law principles.</p>
                    
                    <h3>11.2 Arbitration</h3>
                    <p>Any dispute, controversy, or claim arising out of or relating to these Terms, or the breach, termination, or validity thereof, shall be settled by arbitration in accordance with the Arbitration and Conciliation Act, 1996, of India.</p>
                    <p>The arbitration shall be conducted in Bengaluru, India, in the English language, by a sole arbitrator appointed by mutual agreement of the parties.</p>
                    
                    <h3>11.3 Waiver of Class Actions</h3>
                    <p>All claims and disputes within the scope of this arbitration agreement must be arbitrated on an individual basis and not on a class basis. Claims of more than one customer or user cannot be arbitrated jointly or consolidated with those of any other customer or user.</p>
                </div>
                
                <div id="termination" class="terms-section">
                    <h2>12. Termination</h2>
                    <p>We may terminate or suspend your account and bar access to the Services immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.</p>
                    <p>Upon termination, your right to use the Services will immediately cease. If you wish to terminate your account, you may simply discontinue using the Services or contact us to request account deletion.</p>
                    <p>All provisions of these Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.</p>
                </div>
                
                <div id="contact" class="terms-section contact-section">
                    <h2>13. Contact Us</h2>
                    <p>If you have any questions about these Terms, please contact us at:</p>
                    <p><strong>Email:</strong> <a href="mailto:legal@aayojana.com">legal@aayojana.com</a></p>
                    <p><strong>Address:</strong> 123 Tech Park, Koramangala, Bengaluru, Karnataka 560034, India</p>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>
</body>
</html>
