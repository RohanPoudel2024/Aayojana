<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ include file="adminUtils.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
<%
    // Get currentUser from session if not already available in the including page
    User headerUser = (User) session.getAttribute("currentUser");
    
    // Check for admin access
    if (headerUser == null || !"admin".equals(headerUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!-- Ensure Font Awesome is loaded -->
<script>
    // Check if Font Awesome is already loaded
    if (!document.querySelector('link[href*="font-awesome"]')) {
        // If not, load it
        var fontAwesome = document.createElement('link');
        fontAwesome.rel = 'stylesheet';
        fontAwesome.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css';
        document.head.appendChild(fontAwesome);
    }
</script>

<div class="header">    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/Dashboard" class="<%= isCurrentPath(request, "/Dashboard") ? "active" : "" %>">
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/events" class="<%= isCurrentPath(request, "/admin/events") ? "active" : "" %>">
            Events
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="<%= isCurrentPath(request, "/admin/bookings") ? "active" : "" %>">
            Bookings
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="<%= isCurrentPath(request, "/admin/categories") ? "active" : "" %>">
            Categories
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="<%= isCurrentPath(request, "/admin/users") ? "active" : "" %>">
            Users
        </a>
    </div>
    <div class="user-actions">
        <% if (headerUser != null) { %>
            <a href="${pageContext.request.contextPath}/profile" class="user-profile">
                <span class="username"><%= headerUser.getName() %></span>
                <span class="icon"><i class="fas fa-user"></i></span>
            </a>
            <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        <% } %>
    </div>
</div>
