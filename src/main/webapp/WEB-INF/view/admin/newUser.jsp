<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create New User - AayoJana Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 700px;
            margin: 20px auto;
        }
        
        .form-title {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        
        .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-input:focus {
            border-color: #4a90e2;
            outline: none;
        }
        
        .form-select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            background-color: #fff;
        }
        
        .form-actions {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        
        .btn-cancel {
            background-color: #f5f5f5;
            color: #333;
        }
        
        .btn-cancel:hover {
            background-color: #e0e0e0;
        }
        
        .btn-save {
            background-color: #4a90e2;
            color: #fff;
        }
        
        .btn-save:hover {
            background-color: #3a7bc8;
        }
        
        .alert {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
            <div class="form-container">
                <h2 class="form-title">Create New User</h2>
                
                <% if (message != null) { %>
                    <div class="alert alert-success">
                        <%= message %>
                    </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                    <div class="alert alert-danger">
                        <%= errorMessage %>
                    </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/admin/users" method="post" id="createUserForm" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="createUser">
                    
                    <div class="form-group">
                        <label for="name" class="form-label">Full Name:</label>
                        <input type="text" id="name" name="name" class="form-input" required 
                               pattern="^[a-zA-Z ]{2,50}$" title="Name should contain only letters and spaces (2-50 characters)">
                        <small style="color: #777; margin-top: 5px; display: block;">Enter the full name (2-50 characters).</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address:</label>
                        <input type="email" id="email" name="email" class="form-input" required
                               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Please enter a valid email address">
                        <small style="color: #777; margin-top: 5px; display: block;">Enter a valid email address.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Phone Number:</label>
                        <input type="text" id="phone" name="phone" class="form-input"
                               pattern="^[0-9]{10}$" title="Phone number should be 10 digits">
                        <small style="color: #777; margin-top: 5px; display: block;">Enter a 10-digit phone number (digits only).</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="role" class="form-label">Role:</label>
                        <select id="role" name="role" class="form-select">
                            <option value="user" selected>User</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">Password:</label>
                        <input type="password" id="password" name="password" class="form-input" required
                               minlength="6" title="Password must be at least 6 characters long">
                        <small style="color: #777; margin-top: 5px; display: block;">Password must be at least 6 characters long.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                        <small id="passwordMatch" style="color: #dc3545; margin-top: 5px; display: none;">Passwords do not match</small>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel">Cancel</a>
                        <button type="submit" class="btn btn-save" id="submitBtn">Create User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Check if passwords match when typing
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const password = document.getElementById('password').value;
        const confirmPassword = this.value;
        const passwordMatch = document.getElementById('passwordMatch');
        const submitBtn = document.getElementById('submitBtn');
        
        if (password !== confirmPassword) {
            passwordMatch.style.display = 'block';
            submitBtn.disabled = true;
        } else {
            passwordMatch.style.display = 'none';
            submitBtn.disabled = false;
        }
    });
    
    // Also check when typing in the password field
    document.getElementById('password').addEventListener('input', function() {
        const confirmPassword = document.getElementById('confirmPassword');
        if (confirmPassword.value) {
            const event = new Event('input');
            confirmPassword.dispatchEvent(event);
        }
    });
    
    // Form validation
    function validateForm() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        if (password !== confirmPassword) {
            alert("Passwords do not match. Please try again.");
            return false;
        }
        
        if (password.length < 6) {
            alert("Password must be at least 6 characters long.");
            return false;
        }
        
        return confirm("Are you sure you want to create this user?");
    }
</script>
</body>
</html>
