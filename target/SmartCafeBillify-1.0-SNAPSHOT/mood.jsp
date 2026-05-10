<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ambil nama pelanggan dari URL
    String customerName = request.getParameter("customerName");
    if (customerName == null || customerName.isEmpty()) {
        customerName = "Pelanggan Umum";
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Mood Recommendation - SmartCafe Billify</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --deep-coffee: #3e2723;
            --primary-brown: #6b4f3f;
            --accent-caramel: #b8743b;
            --bg-cream: #fdfaf6;
            --white: #ffffff;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-cream);
            background-image: url('https://www.transparenttextures.com/patterns/coffee-beans.png');
            color: var(--deep-coffee);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            width: 100%;
            max-width: 550px;
            padding: 45px;
            border-radius: 35px;
            box-shadow: 0 20px 50px rgba(62, 39, 35, 0.15);
            border: 1px solid rgba(184, 116, 59, 0.2);
            position: relative;
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        .container::before {
            content: "\f0f4";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            top: -15px;
            right: -10px;
            font-size: 80px;
            color: rgba(107, 79, 63, 0.05);
            transform: rotate(15deg);
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 26px;
            font-weight: 700;
            color: var(--deep-coffee);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        h2 i { color: var(--accent-caramel); }

        .section-title {
            margin: 25px 0 15px 5px;
            font-weight: 600;
            font-size: 16px;
            color: var(--primary-brown);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .options-grid input[type="radio"] {
            display: none;
        }

        .option-card {
            background: var(--white);
            padding: 15px 20px;
            border-radius: 18px;
            border: 2px solid #eee;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            font-weight: 500;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
        }

        .option-card:hover {
            transform: translateY(-3px);
            border-color: var(--accent-caramel);
            box-shadow: 0 8px 15px rgba(107, 79, 63, 0.1);
        }

        .options-grid input[type="radio"]:checked + .option-card {
            border-color: var(--accent-caramel);
            background: #fff8f4;
            color: var(--accent-caramel);
            transform: scale(1.02);
        }

        .icon-box {
            font-size: 20px;
        }

        .btn-submit {
            width: 100%;
            padding: 18px;
            margin-top: 40px;
            background: linear-gradient(135deg, var(--primary-brown), var(--deep-coffee));
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 10px 20px rgba(62, 39, 35, 0.2);
        }

        .btn-submit:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 30px rgba(62, 39, 35, 0.3);
        }

        .link-container {
            margin-top: 30px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.05);
            padding-top: 20px;
        }

        .link-container a {
            color: var(--accent-caramel);
            font-size: 14px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .link-container a:hover {
            color: var(--deep-coffee);
            text-decoration: underline;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="container">
    <h2><i class="fas fa-magic"></i> Mood Recommendation</h2>
    
    <p style="text-align: center; font-size: 13px; color: var(--accent-caramel); margin-top: -20px; margin-bottom: 20px;">
        <i class="fas fa-user"></i> Melayani: <b><%= customerName %></b>
    </p>

    <form action="MoodServlet" method="post">
        <input type="hidden" name="customerName" value="<%= customerName %>">

        <div class="section-title">
            <i class="fas fa-heart" style="color: #d32f2f;"></i> Bagaimana mood Anda hari ini?
        </div>
        <div class="options-grid">
            <label>
                <input type="radio" name="mood" value="lelah" required>
                <div class="option-card">
                    <span>Lelah</span>
                    <span class="icon-box">😫</span>
                </div>
            </label>
            <label>
                <input type="radio" name="mood" value="senang">
                <div class="option-card">
                    <span>Senang</span>
                    <span class="icon-box">😊</span>
                </div>
            </label>
            <label>
                <input type="radio" name="mood" value="sedih">
                <div class="option-card">
                    <span>Sedih</span>
                    <span class="icon-box">😢</span>
                </div>
            </label>
            <label>
                <input type="radio" name="mood" value="galau">
                <div class="option-card">
                    <span>Galau</span>
                    <span class="icon-box">☁️</span>
                </div>
            </label>
        </div>

        <div class="section-title">
            <i class="fas fa-utensils" style="color: var(--accent-caramel);"></i> Preferensi rasa favorit:
        </div>
        <div class="options-grid">
            <label>
                <input type="radio" name="rasa" value="manis" required>
                <div class="option-card">
                    <span>Manis</span>
                    <span class="icon-box">🍭</span>
                </div>
            </label>
            <label>
                <input type="radio" name="rasa" value="segar">
                <div class="option-card">
                    <span>Segar</span>
                    <span class="icon-box">🍃</span>
                </div>
            </label>
            <label>
                <input type="radio" name="rasa" value="pahit">
                <div class="option-card">
                    <span>Pahit</span>
                    <span class="icon-box">☕</span>
                </div>
            </label>
            <label>
                <input type="radio" name="rasa" value="asam">
                <div class="option-card">
                    <span>Asam</span>
                    <span class="icon-box">🍋</span>
                </div>
            </label>
        </div>

        <button type="submit" class="btn-submit">
            Cari Menu Spesial <i class="fas fa-arrow-right"></i>
        </button>
    </form>

    <div class="link-container">
        <a href="dashboard.jsp"><i class="fas fa-chevron-left"></i> Kembali ke Dashboard</a>
        <span style="margin: 0 10px; opacity: 0.2;">|</span>
        <a href="inputmenu.jsp?customerName=<%= java.net.URLEncoder.encode(customerName, "UTF-8") %>">
            <i class="fas fa-times-circle"></i> Lewati
        </a>
    </div>
</div>

</body>
</html>