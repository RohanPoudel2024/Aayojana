<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String currentPage = request.getRequestURI();
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userHeader.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
}
.search-box {
    position: relative;
    margin-right: 20px;
}
.search-box input {
    padding: 8px 30px 8px 12px;
    border: 1px solid #ddd;
    border-radius: 20px;
    font-size: 14px;
    width: 200px;
}
.search-box button {
    position: absolute;
    right: 5px;
    top: 50%;
    transform: translateY(-50%);
    background: transparent;
    border: none;
    color: #5928e5;
    cursor: pointer;
}
@media (max-width: 768px) {
    .search-box {
        order: 3;
        width: 100%;
        margin: 10px 0;
    }
    .search-box input {
        width: 100%;
    }
}
</style>

<div class="header">
    <div class="logo">AYO-JANA</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/EventsServlet" class="<%= currentPage.contains("eventList.jsp") && !request.getParameterMap().containsKey("view") ? "active" : "" %>">Explore</a>
        <a href="${pageContext.request.contextPath}/EventsServlet?view=upcoming" class="<%= request.getParameter("view") != null && request.getParameter("view").equals("upcoming") ? "active" : "" %>">Upcoming Events</a>
        <a href="${pageContext.request.contextPath}/booking?action=list" class="<%= currentPage.contains("/bookings/") ? "active" : "" %>">My Bookings</a>
        <a href="${pageContext.request.contextPath}/search" class="<%= currentPage.contains("searchPage.jsp") ? "active" : "" %>"><i class="fas fa-search"></i> Search</a>
    </div>
    
    <div class="search-box">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" placeholder="Search events...">
            <button type="submit"><i class="fas fa-search"></i></button>
        </form>
    </div>
    
    <div class="user">
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
