<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/signup.css">
</head>
<body>
<div class="modal">
    <button class="close-button">×</button>

    <h1>Welcome.</h1>
    <p class="subtitle">Create an account</p>

    <form action="signup" method="post">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Input" required>
        </div>

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
        </div>

        <div class="checkbox-container">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms" class="terms">I agree with <a href="#">Terms & Conditions</a></label>
        </div>

        <button type="submit" class="signup-button">Sign Up</button>
    </form>
    <% String error = (String) request.getAttribute("errorMessage");
        if (error != null) { %>
    <p style="color:red; text-align:center;"><%= error %></p>
    <% } %>

    <p class="divider">Or sign up with</p>

    <div class="social-buttons">
        <button type="button" class="social-button google">
            <span>G</span>
        </button>
        <button type="button" class="social-button facebook">
            <span>f</span>
        </button>
    </div>

    <p class="login-link">Already have an account? <a href="login.jsp">Sign in</a></p>
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