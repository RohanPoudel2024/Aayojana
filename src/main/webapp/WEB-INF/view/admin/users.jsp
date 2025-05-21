<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<User> userList = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">    <title>User Management - AayoJana</title>
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
        
        <div class="content-area">
            <div class="page-title">
                <h1>User Management</h1>
                <a href="${pageContext.request.contextPath}/admin/users?action=new" class="btn-add">
                    <span style="margin-right: 5px;">+</span> Add New User
                </a>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (userList != null && !userList.isEmpty()) { %>
                        <% for (User user : userList) { %>
                            <tr>
                                <td><%= user.getUserId() %></td>
                                <td><%= user.getName() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                <td>
                                    <span class="user-role <%= "admin".equals(user.getRole()) ? "role-admin" : "role-user" %>">
                                        <%= user.getRole() %>
                                    </span>
                                </td>
                                <td class="user-actions">
                                    <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= user.getUserId() %>" class="btn-action btn-edit">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= user.getUserId() %>" 
                                       onclick="return confirm('Are you sure you want to delete this user?')" 
                                       class="btn-action btn-delete">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px;">No users found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>