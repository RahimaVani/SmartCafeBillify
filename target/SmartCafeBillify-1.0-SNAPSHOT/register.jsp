<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Billify</title>
    <link rel="stylesheet" href="style.css">

    <style>
        body {
            background: #faebd7;
            font-family: "Inter", Arial;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .register-card {
            width: 380px;
            background: #fff;
            padding: 30px;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            text-align: center;
        }

        .register-card h2 {
            font-size: 24px;
            font-weight: 700;
            color: #5a3a1e;
            margin-bottom: 20px;
        }

        label {
            display: block;
            text-align: left;
            margin-top: 12px;
            font-weight: 600;
            color: #5a3a1e;
        }

        input {
            width: 90%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #d8c3a5;
            background: #f8f5f0;
            margin-top: 5px;
        }

        .btn-register {
            margin-top: 20px;
            padding: 12px;
            width: 95%;
            background: #d28a39;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 15px;
        }

        .btn-register:hover {
            background: #b76d22;
        }

        .link-login {
            margin-top: 15px;
            color: #8b6d4a;
            font-size: 14px;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
            font-weight: bold;
        }
    </style>

</head>
<body>

<div class="register-card">

    <h2>Registrasi Akun</h2>

    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
    %>
        <p class="error"><%= error %></p>
    <% } %>

    <form action="RegisterServlet" method="post">

        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Konfirmasi Password</label>
        <input type="password" name="confirm" required>

        <button class="btn-register" type="submit">Register</button>
    </form>

    <div class="link-login">
        Sudah punya akun? <a href="login.jsp">Login</a>
    </div>

</div>

</body>
</html>