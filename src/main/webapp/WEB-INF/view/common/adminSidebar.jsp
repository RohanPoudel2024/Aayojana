<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ include file="adminUtils.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">

<%
    // Get currentUser from session already available from header include
    // No need to check admin access here as adminHeader.jsp already does this check
    User sidebarUser = (User) session.getAttribute("currentUser");
%>
<div class="sidebar">
    <div class="logo">AYO-JANA</div>    <a href="${pageContext.request.contextPath}/Dashboard" class="<%= isCurrentPath(request, "/Dashboard") ? "active" : "" %>">
        <span class="icon"><i class="fas fa-chart-bar"></i></span>Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/users" class="<%= isCurrentPath(request, "/admin/users") ? "active" : "" %>">
        <span class="icon"><i class="fas fa-users"></i></span>Users
    </a>
    <a href="${pageContext.request.contextPath}/admin/events" class="<%= isCurrentPath(request, "/admin/events") ? "active" : "" %>">
        <span class="icon"><i class="fas fa-calendar-alt"></i></span>Events
    </a>
    <a href="${pageContext.request.contextPath}/admin/bookings" class="<%= isCurrentPath(request, "/admin/bookings") ? "active" : "" %>">
        <span class="icon"><i class="fas fa-ticket-alt"></i></span>Bookings
    </a>
    <a href="${pageContext.request.contextPath}/admin/categories" class="<%= isCurrentPath(request, "/admin/categories") ? "active" : "" %>">
        <span class="icon"><i class="fas fa-tags"></i></span>Categories
    </a>
    <a href="#"><span class="icon"><i class="fas fa-cog"></i></span>Settings</a>    <div class="user-account">
        <a href="${pageContext.request.contextPath}/profile"><span class="icon"><i class="fas fa-user-circle"></i></span>User Account</a>
        <form action="${pageContext.request.contextPath}/logout" method="post">
            <button type="submit" style="background: none; border: none; color: #666; text-align: left; width: 100%; padding: 12px 0; cursor: pointer; display: flex; align-items: center;">
                <span class="icon" style="margin-right: 10px;"><i class="fas fa-sign-out-alt"></i></span>Logout
            </button>
        </form>
    </div>
</div>
