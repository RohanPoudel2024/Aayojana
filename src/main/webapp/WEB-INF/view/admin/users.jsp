<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<User> userList = (List<User>) request.getAttribute("userList");
    
    // Get messages from session
    String message = (String) session.getAttribute("message");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after retrieving
    if (message != null) {
        session.removeAttribute("message");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
      // Pagination variables
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String roleFilter = (String) request.getAttribute("roleFilter");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">    <title>User Management - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">    <style>
        .user-role {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8em;
            font-weight: 500;
        }
        
        .role-admin {
            background-color: #ffc107;
            color: #212529;
        }
        
        .role-user {
            background-color: #28a745;
            color: white;
        }
        
        .btn-action {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.85em;
            margin-right: 5px;
        }
        
        .btn-edit {
            background-color: #17a2b8;
            color: white;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        
        /* Filters styles */
        .filters-container {
            margin-bottom: 20px;
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .filters-form {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-group {
            display: flex;
            flex: 1;
            min-width: 200px;
        }
        
        .search-input {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-right: none;
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
            font-size: 0.875rem;
        }
        
        .search-button {
            padding: 8px 12px;
            background-color: #4a90e2;
            color: white;
            border: none;
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
            cursor: pointer;
        }
        
        .filter-group {
            min-width: 150px;
        }
        
        .filter-select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 0.875rem;
            background-color: white;
        }
        
        .clear-filters {
            padding: 8px 12px;
            background-color: #f3f4f6;
            color: #64748b;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .info-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            color: #64748b;
            font-size: 0.875rem;
        }
    </style>
</head>
<div class="container">
    <!-- Include Admin Sidebar -->
    <jsp:include page="../common/adminSidebar.jsp" />
    
    <div class="main-content">
        <!-- Include Admin Header -->
        <jsp:include page="../common/adminHeader.jsp" />
          <div class="content-area">            <div class="page-title">
                <h1>User Management</h1>
                <a href="${pageContext.request.contextPath}/admin/users?action=new" class="btn-add">
                    <span style="margin-right: 5px;">+</span> Add New User
                </a>
            </div>
            
            <div class="filters-container">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="filters-form">
                    <div class="search-group">
                        <input type="text" name="query" placeholder="Search by name or email" 
                               value="<%= searchQuery != null ? searchQuery : "" %>" class="search-input">
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    
                    <div class="filter-group">
                        <select name="role" class="filter-select" onchange="this.form.submit()">
                            <option value="all" <%= (roleFilter == null || "all".equals(roleFilter)) ? "selected" : "" %>>All Roles</option>
                            <option value="admin" <%= "admin".equals(roleFilter) ? "selected" : "" %>>Admin</option>
                            <option value="user" <%= "user".equals(roleFilter) ? "selected" : "" %>>User</option>
                        </select>
                    </div>
                    
                    <% if ((searchQuery != null && !searchQuery.isEmpty()) || (roleFilter != null && !roleFilter.isEmpty() && !"all".equals(roleFilter))) { %>
                        <a href="${pageContext.request.contextPath}/admin/users" class="clear-filters">
                            <i class="fas fa-times"></i> Clear Filters
                        </a>
                    <% } %>
                </form>
            </div>
            
            <div class="info-bar">
                <span>Total Users: <%= request.getAttribute("totalUsers") %></span>
                <% if (request.getAttribute("filteredCount") != null && (Integer)request.getAttribute("totalUsers") != (Integer)request.getAttribute("filteredCount")) { %>
                    <span>Filtered Results: <%= request.getAttribute("filteredCount") %></span>
                <% } %>
            </div>
            
            <% if (message != null) { %>
                <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px 15px; border-radius: 4px; margin-bottom: 20px;">
                    <%= message %>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px 15px; border-radius: 4px; margin-bottom: 20px;">
                    <%= errorMessage %>
                </div>
            <% } %>
            
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
                        <% } %>                    <% } else { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px;">No users found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <div class="pagination-info">
                        Showing page <%= currentPage %> of <%= totalPages %>
                    </div>                    <div class="pagination-controls">
                        <% if (currentPage > 1) { %>
                            <a href="${pageContext.request.contextPath}/admin/users?page=1<%= searchQuery != null && !searchQuery.isEmpty() ? "&query=" + searchQuery : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&role=" + roleFilter : "" %>" class="page-link first-page">First</a>
                            <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage - 1 %><%= searchQuery != null && !searchQuery.isEmpty() ? "&query=" + searchQuery : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&role=" + roleFilter : "" %>" class="page-link prev-page">Previous</a>
                        <% } %>
                        
                        <% 
                            int startPage = Math.max(1, currentPage - 2);
                            int endPage = Math.min(totalPages, startPage + 4);
                            
                            // Adjust start page if we're near the end
                            if (endPage - startPage < 4 && startPage > 1) {
                                startPage = Math.max(1, endPage - 4);
                            }
                            
                            for (int i = startPage; i <= endPage; i++) {
                        %>
                            <a href="${pageContext.request.contextPath}/admin/users?page=<%= i %><%= searchQuery != null && !searchQuery.isEmpty() ? "&query=" + searchQuery : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&role=" + roleFilter : "" %>" class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                        <% } %>
                        
                        <% if (currentPage < totalPages) { %>
                            <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage + 1 %><%= searchQuery != null && !searchQuery.isEmpty() ? "&query=" + searchQuery : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&role=" + roleFilter : "" %>" class="page-link next-page">Next</a>
                            <a href="${pageContext.request.contextPath}/admin/users?page=<%= totalPages %><%= searchQuery != null && !searchQuery.isEmpty() ? "&query=" + searchQuery : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&role=" + roleFilter : "" %>" class="page-link last-page">Last</a>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>
<style>
    .pagination {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
        padding: 10px 0;
        border-top: 1px solid #e2e8f0;
    }
    
    .pagination-info {
        color: #64748b;
        font-size: 0.875rem;
    }
    
    .pagination-controls {
        display: flex;
        gap: 5px;
    }
    
    .page-link {
        padding: 6px 12px;
        border: 1px solid #e2e8f0;
        border-radius: 4px;
        color: #4a90e2;
        text-decoration: none;
        font-size: 0.875rem;
        transition: all 0.3s;
    }
    
    .page-link:hover {
        background-color: #f8fafc;
    }
    
    .page-link.active {
        background-color: #4a90e2;
        color: white;
        border-color: #4a90e2;
    }
    
    .prev-page, .next-page, .first-page, .last-page {
        background-color: #f8fafc;
    }
</style>
</body>
</html>