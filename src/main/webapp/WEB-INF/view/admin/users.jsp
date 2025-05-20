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
    <meta charset="UTF-8">
    <title>User Management - AayoJana</title>    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        
        .btn-add:hover {
            background-color: #3c00b3;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 5px;
            overflow: hidden;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        th {
            background-color: #f8f8f8;
            font-weight: 600;
            color: #333;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .user-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-action {
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-edit {
            background-color: #f0f8ff;
            color: #0066cc;
        }
        
        .btn-delete {
            background-color: #fff0f0;
            color: #cc0000;
        }
        
        .user-role {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .role-admin {
            background-color: #e6f7ff;
            color: #0066cc;
        }
        
        .role-user {
            background-color: #f0f0f0;
            color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard"><span class="icon">📊</span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active"><span class="icon">👥</span>Users</a>
        <a href="#"><span class="icon">🎉</span>Events</a>
        <a href="#"><span class="icon">📋</span>Reports</a>
        <a href="#"><span class="icon">⚙️</span>Settings</a>
        <div class="user-account">
            <a href="${pageContext.request.contextPath}/profile"><span class="icon">👤</span>User Account</a>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" style="background: none; border: none; color: #666; text-align: left; width: 100%; padding: 12px 0; cursor: pointer; display: flex; align-items: center;">
                    <span class="icon" style="margin-right: 10px;">🚪</span>Logout
                </button>
            </form>
        </div>
    </div>
    
    <div class="main-content">
        <div class="header">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/Dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
                <a href="#">Reports</a>
            </div>
            <div class="user">
                <% if (currentUser != null) { %>
                <span><%= currentUser.getName() %></span>
                <span class="icon">👤</span>
                <% } %>
            </div>
        </div>
        
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