<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = "An unexpected error occurred.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - AayoJana</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .error-container {
            text-align: center;
            padding: 40px 20px;
            margin: 20px auto;
            max-width: 600px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 15px;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 30px;
            padding: 0 20px;
        }
        
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4a00e0;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        
        .back-button:hover {
            background-color: #3700b3;
        }
    </style>
</head>
<body>
<div class="container">
    <% if (currentUser != null && "admin".equals(currentUser.getRole())) { %>
        <!-- Include Admin Sidebar for admins -->
        <jsp:include page="common/adminSidebar.jsp" />
        
        <div class="main-content">
            <!-- Include Admin Header -->
            <jsp:include page="common/adminHeader.jsp" />
            
            <div class="error-container">
                <div class="error-icon"><i class="fas fa-exclamation-circle"></i></div>
                <h1 class="error-title">Something went wrong</h1>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
                <a href="${pageContext.request.contextPath}/Dashboard" class="back-button">Return to Dashboard</a>
            </div>
        </div>
    <% } else { %>
        <!-- Include User Header for regular users -->
        <jsp:include page="common/userHeader.jsp" />
        
        <div class="main-content">
            <div class="error-container">
                <div class="error-icon"><i class="fas fa-exclamation-circle"></i></div>
                <h1 class="error-title">Something went wrong</h1>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
                <a href="${pageContext.request.contextPath}/EventsServlet" class="back-button">Return to Events</a>
            </div>
        </div>
        
        <!-- Include User Footer -->
        <jsp:include page="common/userFooter.jsp" />
    <% } %>
</div>
</body>
</html>
