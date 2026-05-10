<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Validasi Session User
    String nama = (String) session.getAttribute("username");
    if (nama == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - SmartCafe Billify</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
            min-height: 100vh;
        }

        /* NAVBAR */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 8%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(62, 39, 35, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-brown);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-greeting {
            background: var(--bg-cream);
            padding: 6px 18px;
            border-radius: 50px;
            font-size: 14px;
            border: 1px solid rgba(184, 116, 59, 0.2);
            color: var(--primary-brown);
        }

        .logout-btn {
            background: #fff;
            color: #d32f2f;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 12px;
            font-size: 18px;
            margin-left: 15px;
            transition: 0.3s;
            border: 1px solid #ffcdd2;
        }

        .logout-btn:hover {
            background: #d32f2f;
            color: white;
            box-shadow: 0 5px 15px rgba(211, 47, 47, 0.2);
        }

        /* HERO SECTION */
        .hero {
            text-align: center;
            padding: 60px 20px 20px;
        }
        .hero h1 { font-size: 36px; margin-bottom: 5px; color: var(--deep-coffee); }
        .hero p { color: var(--primary-brown); opacity: 0.8; }

        /* MENU GRID */
        .menu-grid {
            max-width: 1100px;
            margin: 40px auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            padding: 0 5% 80px;
        }

        .menu-card {
            cursor: pointer;
            padding: 50px 35px;
            border-radius: 30px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            color: white;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 10px 30px rgba(62, 39, 35, 0.2);
            border: none;
        }

        .menu-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 45px rgba(62, 39, 35, 0.3);
        }

        .card-mood   { background: linear-gradient(135deg, #8d6e63 0%, #3e2723 100%); }
        .card-order  { background: linear-gradient(135deg, #b8743b 0%, #6b4f3f 100%); }
        .card-report { background: linear-gradient(135deg, #6b4f3f 0%, #2b1d1a 100%); text-decoration: none;}

        .icon-box {
            width: 85px; height: 85px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(5px);
            border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
            margin-bottom: 25px;
            font-size: 38px;
            transition: 0.4s;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .menu-card:hover .icon-box {
            background: white;
            color: var(--primary-brown);
            transform: scale(1.1) rotate(10deg);
        }

        .menu-card h3 { font-size: 24px; margin: 0 0 12px 0; font-weight: 700; }
        .menu-card p { font-size: 15px; opacity: 0.9; line-height: 1.6; margin: 0; font-weight: 300; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="brand">
            <i class="fas fa-mug-hot"></i> Billify.
        </div>
        
        <div style="display: flex; align-items: center;">
            <span class="user-greeting">
                <i class="fas fa-user-circle"></i> Kasir: <b><%= nama %></b>
            </span>
            <a href="LogoutServlet" class="logout-btn" title="Logout">
                <i class="fas fa-power-off"></i>
            </a>
        </div>
    </div>

    <div class="hero">
        <h1>Selamat Bekerja, <%= nama %>!</h1>
    </div>

    <div class="menu-grid">
        <div onclick="mulaiTransaksi('mood.jsp')" class="menu-card card-mood">
            <div class="icon-box">
                <i class="fas fa-wand-magic-sparkles"></i>
            </div>
            <h3>Mood Rekomendasi</h3>
            <p>Rekomendasi menu cerdas berdasarkan perasaan pelanggan.</p>
        </div>

        <div onclick="mulaiTransaksi('inputmenu.jsp')" class="menu-card card-order">
            <div class="icon-box">
                <i class="fas fa-mug-saucer"></i>
            </div>
            <h3>Daftar Menu</h3>
            <p>Input transaksi pesanan dan manajemen menu harian.</p>
        </div>

        <a href="LaporanTransaksiServlet" class="menu-card card-report">
            <div class="icon-box">
                <i class="fas fa-file-invoice-dollar"></i>
            </div>
            <h3>Laporan Transaksi</h3>
            <p>Pantau semua riwayat transaksi dan total pendapatan harian.</p>
        </a>
    </div>

    <script>
        function mulaiTransaksi(tujuan) {
            Swal.fire({
                title: 'Nama Pelanggan',
                text: "Siapa nama pelanggan anda?",
                input: 'text',
                inputPlaceholder: 'Masukkan disini',
                showCancelButton: true,
                confirmButtonColor: '#6b4f3f',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Lanjut',
                cancelButtonText: 'Batal',
                inputValidator: (value) => {
                    if (!value) {
                        return 'Nama pelanggan wajib diisi!'
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    // Encode nama pelanggan agar aman digunakan di URL
                    const customerName = encodeURIComponent(result.value);
                    // Arahkan ke halaman tujuan dengan membawa parameter nama pelanggan
                    window.location.href = tujuan + "?customerName=" + customerName;
                }
            })
        }
    </script>

</body>
</html>