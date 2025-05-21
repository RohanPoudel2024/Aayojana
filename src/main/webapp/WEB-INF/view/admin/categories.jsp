<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after displaying them
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Management - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .content-area {
            padding: 20px;
        }
        
        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .btn-add {
            background-color: #4a00e0;
            color: white;
            padding: 10px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-add:hover {
            background-color: #3c00b3;
        }
        
        .message {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
        
        .category-actions {
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
        
        .btn-toggle {
            background-color: #f0f0f0;
            color: #555;
        }
        
        .status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #e6f7ff;
            color: #0066cc;
        }
        
        .status-inactive {
            background-color: #f0f0f0;
            color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
        
        <div class="content-area">
            <div class="page-title">
                <h1>Category Management</h1>
                <a href="${pageContext.request.contextPath}/admin/categories?action=new" class="btn-add">
                    <span style="margin-right: 5px;">+</span> Add New Category
                </a>
            </div>
            
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="message success-message">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="message error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Created Date</th>
                        <th>Updated Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (categories != null && !categories.isEmpty()) { %>
                        <% for (Category category : categories) { %>
                            <tr>
                                <td><%= category.getCategoryId() %></td>
                                <td><%= category.getName() %></td>
                                <td><%= category.getDescription() != null ? category.getDescription() : "-" %></td>
                                <td><%= category.getCreatedAt() != null ? category.getCreatedAt().format(formatter) : "-" %></td>
                                <td><%= category.getUpdatedAt() != null ? category.getUpdatedAt().format(formatter) : "-" %></td>
                                <td>
                                    <span class="status <%= category.isActive() ? "status-active" : "status-inactive" %>">
                                        <%= category.isActive() ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td class="category-actions">
                                    <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=<%= category.getCategoryId() %>" 
                                       class="btn-action btn-edit">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/categories?action=toggle&id=<%= category.getCategoryId() %>" 
                                       class="btn-action btn-toggle"><%= category.isActive() ? "Deactivate" : "Activate" %></a>
                                    <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=<%= category.getCategoryId() %>" 
                                       onclick="return confirm('Are you sure you want to delete this category?')" 
                                       class="btn-action btn-delete">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px;">No categories found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>