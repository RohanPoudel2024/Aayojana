<%--
  Created by IntelliJ IDEA.
  User: Rohan
  Date: 4/18/2025
  Time: 1:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<div class="modal">
    <button class="close-button">×</button>

    <h1>Welcome.</h1>
    <p class="subtitle">Log in to your account</p>

    <form action="login" method="post">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Input" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div class="password-container">
                <input type="password" id="password" name="password" placeholder="Input" required>
                <button type="button" class="toggle-password" onclick="togglePasswordVisibility()">⊙</button>
            </div>
            <% String error = (String) request.getAttribute("error");
                if (error != null) { %>
            <p style="color:red; text-align:center;"><%= error %></p>
            <% } %>

            <div class="forgot-password">
                <a href="forgot-password.jsp">Forgot password?</a>
            </div>
        </div>

        <button type="submit" class="login-button">Sign In</button>
    </form>

    <p class="divider">Or sign in with</p>

    <div class="social-buttons">
        <button type="button" class="social-button google">
            <span>G</span>
        </button>
        <button type="button" class="social-button facebook">
            <span>f</span>
        </button>
    </div>

    <p class="signup-link">Don't have an account? <a href="signup.jsp">Sign up</a></p>
</div>

<script>
    function togglePasswordVisibility() {
        var passwordInput = document.getElementById("password");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
        } else {
            passwordInput.type = "password";
        }
    }
</script>
</body>
</html>