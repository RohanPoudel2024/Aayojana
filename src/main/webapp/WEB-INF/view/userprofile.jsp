<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after reading them
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userProfile.css">
    <style>
        .success-message {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .error-message {
            background-color: #f2dede;
            color: #a94442;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .no-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background-color: #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            text-align: center;
        }
    </style>
</head>
<body>    <div class="container">
        <jsp:include page="common/userHeader.jsp" />
        
        <div class="main-content">
            <div class="profile-section">
                <div class="profile-avatar">
                    <% if(currentUser != null && currentUser.hasProfileImage()) { %>
                        <img src="${pageContext.request.contextPath}/image?userId=<%= currentUser.getUserId() %>" 
                            alt="Profile Picture" class="avatar">
                    <% } else { %>
                        <div class="avatar"></div>
                    <% } %>
                    
                    <div class="profile-info">
                        <h3><%= currentUser != null ? currentUser.getName() : "User" %></h3>
                        <p><%= currentUser != null ? currentUser.getEmail() : "" %></p>
                    </div>
                </div>
                
                <div class="profile-form">
                    <h2>Edit Profile</h2>
                    
                    <% if(successMessage != null && !successMessage.isEmpty()) { %>
                        <div class="success-message">
                            <%= successMessage %>
                        </div>
                    <% } %>
                    
                    <% if(errorMessage != null && !errorMessage.isEmpty()) { %>
                        <div class="error-message">
                            <%= errorMessage %>
                        </div>
                    <% } %>
                    
                    <form action="profile" method="post" enctype="multipart/form-data" id="profileForm">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= currentUser != null ? currentUser.getName() : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= currentUser != null ? currentUser.getEmail() : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" id="phone" name="phone" value="<%= currentUser != null ? currentUser.getPhone() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="profileImage">Profile Image</label>
                            <input type="file" id="profileImage" name="profileImage" accept="image/*">
                            <p><small>Maximum file size: 5MB. Allowed formats: JPEG, PNG, JPG, GIF</small></p>
                        </div>
                        
                        <button type="submit" class="save-button">Save Changes</button>
                    </form>
                </div>            </div>
        </div>
        
        <jsp:include page="common/userFooter.jsp" />
    </div>

    <script>
        // Form validation and file size check
        document.getElementById('profileForm').onsubmit = function() {
            var fileInput = document.getElementById('profileImage');
            if (fileInput.files.length > 0) {
                // Check file size (5MB max)
                if (fileInput.files[0].size > 5 * 1024 * 1024) {
                    alert('File size exceeds 5MB limit. Please choose a smaller file.');
                    return false;
                }
            }
            return true;
        };
    </script>
</body>
</html>
