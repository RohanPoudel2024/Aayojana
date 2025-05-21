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
<head>    <meta charset="UTF-8">
    <title><%= isNewCategory ? "Create New Category" : "Edit Category" %> - AayoJana</title>
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css"> -->
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