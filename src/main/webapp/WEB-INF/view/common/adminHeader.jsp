<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // Get currentUser from session if not already available in the including page
    User headerUser = (User) session.getAttribute("currentUser");
%>
<div class="header">
    <div class="logo">AYO-JANA</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/Dashboard" class="${requestScope['javax.servlet.forward.servlet_path'].equals('/Dashboard') ? 'active' : ''}">
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/events" class="${requestScope['javax.servlet.forward.servlet_path'].equals('/admin/events') ? 'active' : ''}">
            Events
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="${requestScope['javax.servlet.forward.servlet_path'].equals('/admin/bookings') ? 'active' : ''}">
            Bookings
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="${requestScope['javax.servlet.forward.servlet_path'].equals('/admin/categories') ? 'active' : ''}">
            Categories
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="${requestScope['javax.servlet.forward.servlet_path'].equals('/admin/users') ? 'active' : ''}">
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
