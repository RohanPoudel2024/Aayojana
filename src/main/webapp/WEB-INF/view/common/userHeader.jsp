<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String currentPage = request.getRequestURI();
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userHeader.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<div class="header">    <div class="logo">AYO-JANA</div>    <div class="nav-links">        <a href="${pageContext.request.contextPath}/EventsServlet" class="<%= currentPage.contains("eventList.jsp") && !request.getParameterMap().containsKey("view") ? "active" : "" %>">Explore</a>
        <a href="${pageContext.request.contextPath}/EventsServlet?view=upcoming" class="<%= request.getParameter("view") != null && request.getParameter("view").equals("upcoming") ? "active" : "" %>">Upcoming Events</a>
        <a href="${pageContext.request.contextPath}/booking?action=list" class="<%= currentPage.contains("/bookings/") ? "active" : "" %>">My Bookings</a>
        <a href="${pageContext.request.contextPath}/SearchEvents" class="<%= currentPage.contains("searchPage.jsp") ? "active" : "" %>"><i class="fas fa-search"></i> Search</a>
    </div><div class="user">
        <% if (currentUser != null) { %>
        <a href="${pageContext.request.contextPath}/profile" class="user-profile">
            <span class="username"><%= currentUser.getName() %></span>
            <span class="icon"><i class="fas fa-user"></i></span>
        </a>  <!-- Added missing closing tag -->
        
        <form action="${pageContext.request.contextPath}/logout" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
        
        <% } else { %>
        <a href="${pageContext.request.contextPath}/login" class="login-btn">Login</a>
        <a href="${pageContext.request.contextPath}/signup" class="signup-btn">Sign Up</a>
        <% } %>
    </div>
</div>
