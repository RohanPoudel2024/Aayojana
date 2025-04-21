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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: #b8c0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .modal {
            background-color: white;
            border-radius: 8px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .close-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #666;
        }

        h1 {
            font-size: 32px;
            text-align: center;
            margin-bottom: 10px;
            color: #333;
        }

        .subtitle {
            text-align: center;
            color: #888;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 0;
            border: none;
            border-bottom: 1px solid #ddd;
            outline: none;
            font-size: 16px;
            color: #333;
        }

        input[type="email"]::placeholder,
        input[type="password"]::placeholder {
            color: #ccc;
        }

        .password-container {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 0;
            top: 12px;
            background: none;
            border: none;
            cursor: pointer;
            color: #888;
        }

        .forgot-password {
            text-align: right;
            margin-top: 8px;
        }

        .forgot-password a {
            color: #6c7bff;
            text-decoration: none;
            font-size: 14px;
        }

        .login-button {
            width: 100%;
            padding: 12px;
            background-color: #6c7bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-bottom: 20px;
            margin-top: 20px;
        }

        .login-button:hover {
            background-color: #5a69e0;
        }

        .divider {
            text-align: center;
            color: #888;
            margin-bottom: 20px;
        }

        .social-buttons {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 20px;
        }

        .social-button {
            flex: 1;
            padding: 10px;
            border: 1px solid #eee;
            background-color: white;
            border-radius: 4px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        .social-button.google {
            background-color: #faf8f5;
        }

        .social-button.facebook {
            background-color: #f5f7fa;
        }

        .signup-link {
            text-align: center;
            color: #666;
            font-size: 14px;
        }

        .signup-link a {
            color: #6c7bff;
            text-decoration: none;
        }
    </style>
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