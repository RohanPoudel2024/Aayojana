<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Category" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    Category category = (Category) request.getAttribute("category");
    boolean isNewCategory = (category == null);
    
    // Default values for the form
    String name = isNewCategory ? "" : category.getName();
    String description = isNewCategory ? "" : (category.getDescription() != null ? category.getDescription() : "");
    boolean isActive = isNewCategory ? true : category.isActive();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isNewCategory ? "Create New Category" : "Edit Category" %> - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .content-area {
            padding: 20px;
        }
        
        .page-title {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .form-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
        }
        
        .checkbox-group input[type="checkbox"] {
            margin-right: 8px;
        }
        
        .btn-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-primary {
            background-color: #4a00e0;
            color: white;
        }
        
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
        }
        
        .btn-primary:hover {
            background-color: #3c00b3;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        
        .back-link {
            color: #666;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .back-link:hover {
            color: #4a00e0;
        }
        
        .required {
            color: #cc0000;
            margin-left: 3px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="sidebar">
        <div class="logo">AYO-JANA</div>
        <a href="${pageContext.request.contextPath}/Dashboard"><span class="icon">📊</span>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"><span class="icon">👥</span>Users</a>
        <a href="${pageContext.request.contextPath}/admin/events"><span class="icon">🎉</span>Events</a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="active"><span class="icon">🏷️</span>Categories</a>
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
                <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                <a href="${pageContext.request.contextPath}/admin/events">Events</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="active">Categories</a>
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
                <h1><%= isNewCategory ? "Create New Category" : "Edit Category" %></h1>
                <a href="${pageContext.request.contextPath}/admin/categories" class="back-link">
                    <span>←</span> Back to Categories
                </a>
            </div>
            
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/categories" method="post" id="categoryForm">
                    <input type="hidden" name="action" value="<%= isNewCategory ? "create" : "update" %>">
                    <% if (!isNewCategory) { %>
                        <input type="hidden" name="id" value="<%= category.getCategoryId() %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label for="name">Category Name<span class="required">*</span></label>
                        <input type="text" id="name" name="name" value="<%= name %>" required maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" maxlength="500"><%= description %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <div class="checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" <%= isActive ? "checked" : "" %>>
                            <label for="isActive">Active</label>
                        </div>
                    </div>
                    
                    <div class="btn-group">
                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/admin/categories'" class="btn btn-secondary">Cancel</button>
                        <button type="submit" class="btn btn-primary"><%= isNewCategory ? "Create Category" : "Save Changes" %></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('categoryForm').addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        
        if (!name) {
            e.preventDefault();
            alert('Please enter a category name.');
            return;
        }
    });
</script>
</body>
</html>