<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-column">
                <h3>AayoJana</h3>
                <p>The ultimate event management platform for organizers and attendees.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="footer-column">
                <h3>Company</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
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
                    <li><a href="#">Community</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                </ul>
            </div>
            <div class="footer-column">                <h3>Legal</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/terms-of-service">Terms of Service</a></li>
                    <li><a href="${pageContext.request.contextPath}/privacy-policy">Privacy Policy</a></li>
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
