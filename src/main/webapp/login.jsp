<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Billify Login</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .password-container {
            position: relative;
            width: 100%;
        }
        .password-container input {
            width: 100%;
            padding-right: 40px;
            box-sizing: border-box;
        }
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #8b5a2b; 
        }
    </style>
</head>
<body class="login-body">

    <div class="login-card">
        <div class="login-icon">
            <img src="assets/icon/coffee.svg" alt="coffee">
        </div>

        <h2>SmartCafe<br><span class="sub">Cashier System</span></h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <p style="color:red; margin-bottom:10px;"><%= error %></p>
        <%
            }
        %>

        <form action="LoginServlet" method="post">
            <label>Username</label>
            <input type="text" name="username" placeholder="Masukkan username">

            <label>Password</label>
            <div class="password-container">
                <input type="password" name="password" id="password" placeholder="Masukkan password">
                <i class="fa-solid fa-eye-slash toggle-password" id="toggleIcon" onclick="togglePassword()"></i>
            </div>

            <button type="submit" class="btn-login">Login</button>
        </form>

        <p class="demo-info">Welcome to Billify</p>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById("password");
            const toggleIcon = document.getElementById("toggleIcon");
            
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.remove("fa-eye-slash");
                toggleIcon.classList.add("fa-eye");
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove("fa-eye");
                toggleIcon.classList.add("fa-eye-slash");
            }
        }
    </script>

</body>
</html>