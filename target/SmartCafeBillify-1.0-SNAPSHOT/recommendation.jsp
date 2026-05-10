<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.smartcaafebillify.controller.MoodServlet.Menu" %>

<%
    String displayName = (String) request.getAttribute("customerName");
    
    if (displayName == null || displayName.isEmpty()) {
        displayName = (String) session.getAttribute("customerName");
    }
    
    if (displayName == null || displayName.isEmpty()) {
        displayName = "Pelanggan Umum";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Rekomendasi Menu - SmartCafe</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-coffee: #6b4f3f;
            --accent-orange: #b8743b;
            --bg-cream: #f8efe4;
            --white: #ffffff;
            --text-dark: #3e2723;
        }

        body {
            background: var(--bg-cream);
            font-family: "Poppins", sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 600px;
            background: var(--white);
            padding: 40px;
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(107, 79, 63, 0.1);
            border: 1px solid rgba(184, 116, 59, 0.1);
        }

        h2 {
            text-align: center;
            color: var(--primary-coffee);
            font-weight: 700;
            margin-bottom: 5px;
        }

        .customer-badge {
            text-align: center;
            margin-bottom: 25px;
            font-size: 13px;
            color: var(--accent-orange);
            font-weight: 600;
            background: #fff8f0;
            padding: 8px;
            border-radius: 50px;
            display: inline-block;
            width: auto;
            margin-left: auto;
            margin-right: auto;
            display: block;
        }

        .mood-summary {
            background: #fdfaf6;
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            gap: 20px;
            border: 1px dashed var(--accent-orange);
        }

        .mood-tag {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .mood-tag i { color: var(--accent-orange); margin-right: 5px; }

        .rekom-list { margin-bottom: 30px; }

        .rekom-item {
            background: #ffffff;
            padding: 18px;
            border-radius: 16px;
            margin-bottom: 12px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 2px solid #f0f0f0;
            transition: all 0.3s ease;
        }

        .rekom-item:hover {
            border-color: var(--accent-orange);
            background: #fffdfb;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(184, 116, 59, 0.1);
        }

        .rekom-item.selected {
            border-color: var(--primary-coffee);
            background: #f7efe8;
        }

        .menu-info { display: flex; align-items: center; gap: 12px; }
        .menu-name { font-weight: 600; color: var(--primary-coffee); }
        .price-tag {
            background: var(--primary-coffee);
            color: white;
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
        }

        .cart-form {
            background: #fdfaf6;
            padding: 25px;
            border-radius: 20px;
            margin-top: 20px;
        }

        .cart-form h3 {
            font-size: 16px;
            margin-bottom: 15px;
            color: var(--primary-coffee);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 12px;
            border-radius: 12px;
            border: 1px solid #ddd;
            background: #fff;
            box-sizing: border-box;
            font-family: inherit;
        }

        input[readonly] { background: #eee; cursor: not-allowed; }

        .btn-group {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 12px;
            margin-top: 10px;
        }

        .btn {
            padding: 15px;
            border-radius: 12px;
            border: none;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-pay { background: var(--primary-coffee); color: white; }
        .btn-back { background: #e0e0e0; color: var(--text-dark); }
        .btn:hover { opacity: 0.9; transform: translateY(-2px); }
    </style>

    <script>
        function pilihMenu(element, nama, harga) {
            document.querySelectorAll('.rekom-item').forEach(item => item.classList.remove('selected'));
            element.classList.add('selected');
            
            document.getElementById("namaMenu").value = nama;
            document.getElementById("hargaMenu").value = "Rp " + harga;
            document.getElementById("hargaReal").value = harga;
        }
    </script>
</head>

<body>

<div class="container">
    <h2><i class="fas fa-star"></i> Rekomendasi Untukmu</h2>
    <div class="customer-badge">
        <i class="fas fa-user"></i> Pelanggan: <b><%= displayName %></b>
    </div>

    <div class="mood-summary">
        <span class="mood-tag"><i class="fas fa-heart"></i> Mood: <b>${mood}</b></span>
        <span class="mood-tag"><i class="fas fa-utensils"></i> Rasa: <b>${rasa}</b></span>
    </div>

    <div class="rekom-list">
        <%
            List<Menu> list = (List<Menu>) request.getAttribute("rekomendasi");
            if (list == null || list.isEmpty()) {
        %>
            <div style="text-align:center; padding: 40px; color: #999;">
                <i class="fas fa-mug-hot" style="font-size: 40px; margin-bottom: 10px;"></i>
                <p>Maaf, belum ada menu yang pas untuk mood ini 😢</p>
            </div>
        <% } else {
            for (Menu m : list) { %>
                <div class="rekom-item" onclick="pilihMenu(this, '<%= m.getNama() %>', <%= m.getHarga() %>)">
                    <div class="menu-info">
                        <i class="fas fa-coffee" style="color: var(--accent-orange);"></i>
                        <span class="menu-name"><%= m.getNama() %></span>
                    </div>
                    <span class="price-tag">Rp <%= m.getHarga() %></span>
                </div>
        <%  }
           } %>
    </div>

    <div class="cart-form">
        <h3><i class="fas fa-shopping-basket"></i> Masukkan ke Keranjang</h3>
        <form action="InputMenuServlet" method="post">
            <input type="hidden" name="customerName" value="<%= displayName %>">
            
            <input type="text" id="namaMenu" name="namaMenu" placeholder="Klik menu di atas..." readonly required>
            <input type="text" id="hargaMenu" placeholder="Harga" readonly>
            <input type="hidden" id="hargaReal" name="harga">
            
            <label style="font-size: 12px; font-weight: 600; margin-left: 5px;">Jumlah Pesanan:</label>
            <input type="number" name="jumlah" min="1" value="1" required>

            <div class="btn-group">
                <button type="button" class="btn btn-back" onclick="location.href='dashboard.jsp'">
                    Batal
                </button>
                <button type="submit" class="btn btn-pay">
                    Tambah <i class="fas fa-plus"></i>
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>