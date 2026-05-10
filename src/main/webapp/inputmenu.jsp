<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.smartcafebillify.model.ItemPesanan" %>

<%
    String customerNameParam = request.getParameter("customerName"); // mengambil nama pelanggan dari parameter URL
    if (customerNameParam != null && !customerNameParam.isEmpty()) {
        session.setAttribute("customerName", customerNameParam);
    }
    String displayName = (String) session.getAttribute("customerName");
    if (displayName == null) displayName = "Pelanggan Umum";

    String action = request.getParameter("action");
    String next = request.getParameter("next");
    if ("clear".equals(action)) {
        session.removeAttribute("keranjang");
        if ("dashboard".equals(next)) {
            session.removeAttribute("customerName");
            response.sendRedirect("dashboard.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title>Input Menu — Café Billify</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{ --bg: #f7f6f3; --card: #ffffff; --accent: #6f4e37; --muted: #9b8b7a; --soft: #efe8dc; --radius: 12px; --shadow: 0 8px 22px rgba(20,20,20,0.08); }
        *{box-sizing:border-box}
        body{ margin:0; background:var(--bg); font-family:"Poppins",sans-serif; color:#2f2a26; }
        
        /* FIX PENEMPATAN: Perlebar container utama */
        .wrap { max-width: 1400px; margin: 28px auto; padding: 0 20px; }
        
        .top { display:flex; align-items:center; justify-content:space-between; margin-bottom:18px; }
        .brand { display:flex; align-items:center; gap:14px; }
        .logo { width:56px; height:56px; border-radius:12px; background:linear-gradient(135deg,#fdebd3,#f0d9b8); display:flex; align-items:center; justify-content:center; box-shadow:var(--shadow); font-size: 24px;}
        .brand h1{margin:0;font-size:20px;color:var(--accent)}
        .cust-badge { background: var(--accent); color: white; padding: 6px 15px; border-radius: 8px; font-size: 13px; font-weight: 600; }

        /* FIX LAYOUT: Gunakan Flexbox untuk mengunci posisi samping */
        .layout { 
            display: flex; 
            gap: 22px; 
            align-items: flex-start; 
        }

        /* Panel menu mengambil sisa ruang */
        .panel { 
            flex: 1; 
            background:var(--card); 
            border-radius:var(--radius); 
            padding:18px; 
            box-shadow:var(--shadow); 
            min-width: 0; /* Mencegah panel meledak keluar */
        }

        /* Sidebar dikunci lebarnya agar tidak turun */
        .sidebar { 
            width: 380px; 
            flex-shrink: 0; /* Mencegah sidebar menyusut/turun */
            display:flex; 
            flex-direction:column; 
            gap:16px; 
            position: sticky; /* Agar keranjang ikut scrolling */
            top: 20px;
        }

        .category-row { display:flex; gap:10px; flex-wrap:wrap; margin-bottom:14px; }
        .cat-btn { padding:8px 12px; border-radius:999px; font-weight:600; border:1px solid transparent; cursor:pointer; color:var(--muted); background:transparent; }
        .cat-btn.active { background:var(--soft); color:var(--accent); }
        .search input{ width:100%; padding:10px 12px; border-radius:10px; border:1px solid #e6dfd5; margin-bottom:16px; }

        /* Grid menu otomatis menyesuaikan kolom */
        .menu-grid { 
            display:grid; 
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); 
            gap:12px; 
        }

        .item-card { background:white; border-radius:10px; padding:12px; display:flex; flex-direction:column; gap:8px; border:1px solid rgba(0,0,0,0.03); cursor:pointer; transition: .2s; }
        .item-card:hover { transform:translateY(-5px); box-shadow: var(--shadow); }
        .item-top { display:flex; align-items:center; gap:10px; }
        .item-thumb { width:50px; height:50px; border-radius:8px; background:#f3e3cf; display:flex; align-items:center; justify-content:center; font-size:20px; }
        .item-title { font-weight:600; font-size:14px; }
        .item-sub { font-size:12px; color:var(--muted); }
        .item-foot { display:flex; justify-content:space-between; align-items:center; margin-top:5px; }
        .price { font-weight:700; color:var(--accent); font-size:13px; }
        .btn-group { display: flex; gap: 4px; }
        .add-mini { background:var(--soft); border:none; padding:5px 8px; border-radius:6px; cursor:pointer; font-size:11px; font-weight:600; color:var(--accent); }
        .select-mini { background: #fff; border: 1px solid #ddd; padding:5px 8px; border-radius:6px; cursor:pointer; font-size:11px; font-weight:600; color: #555; }
        
        .form-box { background:white; padding:16px; border-radius:12px; box-shadow:var(--shadow); }
        .form-box label { font-size:12px; color:var(--muted); font-weight:600; display:block; margin-bottom:4px; }
        .form-box input { width:100%; padding:8px; margin-bottom:10px; border-radius:6px; border:1px solid #ddd; }
        .btn-primary { background:var(--accent); color:white; border:none; padding:12px; border-radius:10px; font-weight:700; cursor:pointer; width:100%; }
        .cart-list { background:white; padding:16px; border-radius:12px; box-shadow:var(--shadow); }
        .cart-row { display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px dashed #eee; align-items: center; }
        .btn-remove { background:#fff0f0; color:#d9534f; border:1px solid #f5c6cb; padding:2px 8px; border-radius:5px; cursor:pointer; font-size:11px; font-weight:bold; }
        .cart-summary { display:flex; justify-content:space-between; margin-top:15px; font-weight:700; color:var(--accent); border-top: 2px solid var(--soft); padding-top:10px; }
        
        @media (max-width:1100px){ .layout{flex-direction:column} .sidebar{width:100%} }
    </style>
    <script>
        function pilihMenu(nama, harga) {
            document.getElementById('namaMenu').value = nama;
            document.getElementById('harga').value = harga;
            document.getElementById('jumlah').value = 1; 
            document.getElementById('jumlah').focus();
        }
        function quickAdd(nama, harga) {
            pilihMenu(nama, harga);
            document.getElementById('orderForm').submit();
        }
        function filterCategory(cat) {
            document.querySelectorAll('.cat-btn').forEach(b=>b.classList.remove('active'));
            document.querySelectorAll('.cat-btn[data-cat="'+cat+'"]').forEach(b=>b.classList.add('active'));
            document.querySelectorAll('.item-card').forEach(card=>{
                card.style.display = (cat==='all' || card.dataset.cat===cat) ? 'flex' : 'none';
            });
        }
        function doSearch(q){
            q = q.toLowerCase();
            document.querySelectorAll('.item-card').forEach(card=>{
                const text = (card.dataset.name + ' ' + (card.dataset.tags || '')).toLowerCase();
                card.style.display = text.includes(q) ? 'flex' : 'none';
            });
        }
    </script>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div class="brand"><div class="logo">☕</div><div><h1>Billify — Café Menu</h1></div></div>
        <div class="cust-badge"><i class="fas fa-user"></i> &nbsp;Pelanggan: <%= displayName %></div>
    </div>

    <div class="layout">
        <div class="panel">
            <div class="category-row">
                <button class="cat-btn active" data-cat="all" onclick="filterCategory('all')">All</button>
                <button class="cat-btn" data-cat="coffee" onclick="filterCategory('coffee')">Kopi</button>
                <button class="cat-btn" data-cat="noncoffee" onclick="filterCategory('noncoffee')">Non-Kopi</button>
                <button class="cat-btn" data-cat="mocktail" onclick="filterCategory('mocktail')">Mocktail</button>
                <button class="cat-btn" data-cat="dessert" onclick="filterCategory('dessert')">Dessert</button>
                <button class="cat-btn" data-cat="meal" onclick="filterCategory('meal')">Makanan</button>
            </div>
            <div class="search"><input type="text" placeholder="Cari menu..." oninput="doSearch(this.value)"></div>

            <div class="menu-grid">
                <div class="item-card" data-cat="coffee" data-name="Espresso Tonic" data-tags="kopi segar">
                    <div class="item-top"><div class="item-thumb">☕</div><div><div class="item-title">Espresso Tonic</div><div class="item-sub">Espresso with tonic water</div></div></div>
                    <div class="item-foot"><div class="price">Rp 33.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Espresso Tonic',33000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Espresso Tonic',33000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="coffee" data-name="Iced Caramel Macchiato" data-tags="kopi manis">
                    <div class="item-top"><div class="item-thumb">☕</div><div><div class="item-title">Iced Caramel Macchiato</div><div class="item-sub">Espresso, milk & caramel</div></div></div>
                    <div class="item-foot"><div class="price">Rp 34.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Iced Caramel Macchiato',34000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Iced Caramel Macchiato',34000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="coffee" data-name="Cappuccino" data-tags="kopi hot">
                    <div class="item-top"><div class="item-thumb">☕</div><div><div class="item-title">Cappuccino</div><div class="item-sub">Classic foam coffee</div></div></div>
                    <div class="item-foot"><div class="price">Rp 25.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Cappuccino',25000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Cappuccino',25000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="coffee" data-name="Vanilla Cold Brew" data-tags="kopi dingin">
                    <div class="item-top"><div class="item-thumb">🧊</div><div><div class="item-title">Vanilla Cold Brew</div><div class="item-sub">Slow-steeped coffee</div></div></div>
                    <div class="item-foot"><div class="price">Rp 32.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Vanilla Cold Brew',32000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Vanilla Cold Brew',32000)">Select</button></div></div>
                </div>

                <div class="item-card" data-cat="noncoffee" data-name="Matcha Latte" data-tags="matcha green tea">
                    <div class="item-top"><div class="item-thumb">🍵</div><div><div class="item-title">Matcha Latte</div><div class="item-sub">Pure green tea milk</div></div></div>
                    <div class="item-foot"><div class="price">Rp 30.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Matcha Latte',30000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Matcha Latte',30000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="noncoffee" data-name="Red Velvet Latte" data-tags="manis creamy">
                    <div class="item-top"><div class="item-thumb">🍰</div><div><div class="item-title">Red Velvet Latte</div><div class="item-sub">Creamy red velvet milk</div></div></div>
                    <div class="item-foot"><div class="price">Rp 35.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Red Velvet Latte',35000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Red Velvet Latte',35000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="noncoffee" data-name="Taro Milk" data-tags="taro manis">
                    <div class="item-top"><div class="item-thumb">🟣</div><div><div class="item-title">Taro Milk</div><div class="item-sub">Sweet purple yam</div></div></div>
                    <div class="item-foot"><div class="price">Rp 35.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Taro Milk',35000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Taro Milk',35000)">Select</button></div></div>
                </div>

                <div class="item-card" data-cat="mocktail" data-name="Lychee Fizz" data-tags="soda segar">
                    <div class="item-top"><div class="item-thumb">🍹</div><div><div class="item-title">Lychee Fizz</div><div class="item-sub">Sparkling lychee</div></div></div>
                    <div class="item-foot"><div class="price">Rp 28.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Lychee Fizz',28000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Lychee Fizz',28000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="mocktail" data-name="Coffee Mojito" data-tags="kopi soda">
                    <div class="item-top"><div class="item-thumb">🌿</div><div><div class="item-title">Coffee Mojito</div><div class="item-sub">Espresso, lime & mint</div></div></div>
                    <div class="item-foot"><div class="price">Rp 37.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Coffee Mojito',37000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Coffee Mojito',37000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="mocktail" data-name="Sunset Orange" data-tags="soda jeruk">
                    <div class="item-top"><div class="item-thumb">🌅</div><div><div class="item-title">Sunset Orange</div><div class="item-sub">Fresh orange & soda</div></div></div>
                    <div class="item-foot"><div class="price">Rp 32.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Sunset Orange',32000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Sunset Orange',32000)">Select</button></div></div>
                </div>

                <div class="item-card" data-cat="dessert" data-name="Cheese Cake" data-tags="kue keju">
                    <div class="item-top"><div class="item-thumb">🍰</div><div><div class="item-title">Cheese Cake</div><div class="item-sub">Creamy & sweet</div></div></div>
                    <div class="item-foot"><div class="price">Rp 35.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Cheese Cake',35000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Cheese Cake',35000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="dessert" data-name="Tiramisu" data-tags="kue kopi">
                    <div class="item-top"><div class="item-thumb">🍮</div><div><div class="item-title">Tiramisu</div><div class="item-sub">Italian coffee cake</div></div></div>
                    <div class="item-foot"><div class="price">Rp 38.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Tiramisu',38000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Tiramisu',38000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="dessert" data-name="Chocolate Lava" data-tags="kue cokelat">
                    <div class="item-top"><div class="item-thumb">🧁</div><div><div class="item-title">Chocolate Lava</div><div class="item-sub">Melted dark chocolate</div></div></div>
                    <div class="item-foot"><div class="price">Rp 32.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Chocolate Lava',32000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Chocolate Lava',32000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="dessert" data-name="Butter Croissant" data-tags="roti pastry">
                    <div class="item-top"><div class="item-thumb">🥐</div><div><div class="item-title">Butter Croissant</div><div class="item-sub">Flaky & buttery</div></div></div>
                    <div class="item-foot"><div class="price">Rp 22.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Butter Croissant',22000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Butter Croissant',22000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="dessert" data-name="Macarons" data-tags="kue prancis">
                    <div class="item-top"><div class="item-thumb">🍭</div><div><div class="item-title">Macarons</div><div class="item-sub">Sweet almond cookies</div></div></div>
                    <div class="item-foot"><div class="price">Rp 25.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Macarons',25000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Macarons',25000)">Select</button></div></div>
                </div>

                <div class="item-card" data-cat="meal" data-name="Chicken Rice Bowl" data-tags="nasi ayam">
                    <div class="item-top"><div class="item-thumb">🍛</div><div><div class="item-title">Chicken Rice Bowl</div><div class="item-sub">Crispy chicken & rice</div></div></div>
                    <div class="item-foot"><div class="price">Rp 28.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Chicken Rice Bowl',28000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Chicken Rice Bowl',28000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="meal" data-name="Beef Teriyaki" data-tags="nasi sapi">
                    <div class="item-top"><div class="item-thumb">🍱</div><div><div class="item-title">Beef Teriyaki</div><div class="item-sub">Savory beef rice</div></div></div>
                    <div class="item-foot"><div class="price">Rp 45.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Beef Teriyaki',45000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Beef Teriyaki',45000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="meal" data-name="Spaghetti Carbonara" data-tags="mie pasta">
                    <div class="item-top"><div class="item-thumb">🍝</div><div><div class="item-title">Spaghetti Carbonara</div><div class="item-sub">Creamy white sauce</div></div></div>
                    <div class="item-foot"><div class="price">Rp 35.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Spaghetti Carbonara',35000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Spaghetti Carbonara',35000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="meal" data-name="Club Sandwich" data-tags="roti lapis">
                    <div class="item-top"><div class="item-thumb">🥪</div><div><div class="item-title">Club Sandwich</div><div class="item-sub">Toast with egg & ham</div></div></div>
                    <div class="item-foot"><div class="price">Rp 32.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('Club Sandwich',32000)">+ Add</button><button class="select-mini" onclick="pilihMenu('Club Sandwich',32000)">Select</button></div></div>
                </div>
                <div class="item-card" data-cat="meal" data-name="French Fries" data-tags="kentang goreng">
                    <div class="item-top"><div class="item-thumb">🍟</div><div><div class="item-title">French Fries</div><div class="item-sub">Crispy potato fries</div></div></div>
                    <div class="item-foot"><div class="price">Rp 20.000</div><div class="btn-group"><button class="add-mini" onclick="quickAdd('French Fries',20000)">+ Add</button><button class="select-mini" onclick="pilihMenu('French Fries',20000)">Select</button></div></div>
                </div>
            </div>
        </div>

        <div class="sidebar">
            <div class="form-box">
                <form id="orderForm" action="InputMenuServlet" method="post">
                    <label>Nama Menu</label><input id="namaMenu" name="namaMenu" type="text" readonly required>
                    <label>Harga (Rp)</label><input id="harga" name="harga" type="text" readonly required>
                    <label>Jumlah</label><input id="jumlah" name="jumlah" type="number" min="1" value="1" required>
                    <button type="submit" class="btn-primary">Tambah ke Keranjang</button>
                </form>
            </div>
            <div class="cart-list">
                <div style="font-weight:700; margin-bottom:10px;">Keranjang</div>
                <% 
                    List<ItemPesanan> keranjangList = (List<ItemPesanan>) session.getAttribute("keranjang");
                    if (keranjangList == null || keranjangList.isEmpty()) { 
                %>
                    <div style="font-size:13px; color:var(--muted)">Belum ada pesanan.</div>
                <% 
                    } else { 
                        int total=0; 
                        for (int i = 0; i < keranjangList.size(); i++) { 
                            ItemPesanan it = keranjangList.get(i);
                            total += it.getHarga() * it.getJumlah(); %>
                        <div class="cart-row">
                            <div style="flex:1">
                                <div style="font-weight:600; font-size:13px;"><%= it.getNamaMenu() %></div>
                                <div style="font-size:11px; color:var(--muted)"><%= it.getJumlah() %>x Rp <%= it.getHarga() %></div>
                            </div>
                            <div style="text-align:right">
                                <div style="font-weight:700; font-size:13px;">Rp <%= it.getHarga()*it.getJumlah() %></div>
                                <form action="DeleteItemServlet" method="post" style="margin-top:4px;">
                                    <input type="hidden" name="index" value="<%= i %>">
                                    <button type="submit" class="btn-remove">Hapus</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                    <div class="cart-summary"><span>Total</span><span>Rp <%= total %></span></div>
                    <button onclick="location.href='payment.jsp'" class="btn-primary" style="margin-top:15px;">Lanjut Pembayaran</button>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>