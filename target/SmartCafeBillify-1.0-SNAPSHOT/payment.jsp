<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.smartcafebillify.model.ItemPesanan" %>

<%
    // 1. Ambil Nama Kasir dari Session
    String namaKasir = (String) session.getAttribute("username");
    if (namaKasir == null) namaKasir = "Kasir";
    
    // 2. Ambil Nama Pelanggan dari Session
    String namaPelanggan = (String) session.getAttribute("customerName");
    if (namaPelanggan == null || namaPelanggan.isEmpty()) namaPelanggan = "Pelanggan Umum";

    // 3. Ambil Keranjang & Validasi
    List<ItemPesanan> keranjang = (List<ItemPesanan>) session.getAttribute("keranjang");
    
    // Proteksi: Jika keranjang kosong, balikkan ke input menu
    if (keranjang == null || keranjang.isEmpty()) {
        response.sendRedirect("inputmenu.jsp");
        return;
    }

    int subtotal = 0;
    for (ItemPesanan item : keranjang) {
        subtotal += (item.getHarga() * item.getJumlah());
    }
    
    int ppn = (int)(subtotal * 0.11); 
    int totalAkhir = subtotal + ppn; 
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Pembayaran - SmartCafe Billify</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --primary: #6b4f3f;
            --deep-coffee: #3e2723;
            --accent: #b8743b;
            --bg-body: #f3ece4;
            --white: #ffffff;
            --card-bg: #fdfaf6;
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-body);
            background-image: url('https://www.transparenttextures.com/patterns/coffee-beans.png');
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }

        .wrapper {
            width: 90%;
            max-width: 1100px;
            margin: 40px 0;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .panel {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(62, 39, 35, 0.1);
            border: 1px solid rgba(184, 116, 59, 0.1);
        }

        h2 { color: var(--deep-coffee); margin-top: 0; font-size: 20px; border-bottom: 2px solid var(--bg-body); padding-bottom: 10px; }

        .item-box {
            display: flex; justify-content: space-between;
            padding: 12px 0; border-bottom: 1px solid rgba(0,0,0,0.05);
        }
        .item-info b { color: var(--primary); }
        .item-price { font-weight: 700; color: var(--accent); }

        .total-display {
            background: linear-gradient(135deg, var(--primary), var(--deep-coffee));
            color: white;
            padding: 25px; border-radius: 20px; text-align: center; margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(62, 39, 35, 0.2);
        }
        .total-display h1 { margin: 5px 0 0 0; font-size: 36px; }

        .method-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin: 20px 0; }
        .method-card {
            background: var(--card-bg); border: 2px solid transparent;
            padding: 15px 5px; border-radius: 18px; text-align: center;
            cursor: pointer; transition: 0.3s ease;
        }
        .method-card img { width: 40px; height: 40px; object-fit: contain; margin-bottom: 8px; }
        .method-card.active { border-color: var(--accent); background: white; transform: translateY(-5px); box-shadow: 0 10px 20px rgba(184, 116, 59, 0.15); }

        input {
            width: 100%; padding: 14px; border-radius: 12px;
            border: 2px solid #eee; margin-top: 8px; font-size: 16px;
            box-sizing: border-box; transition: 0.3s;
        }

        .btn-pay {
            width: 100%; padding: 18px; background: var(--deep-coffee);
            color: white; border: none; border-radius: 15px;
            font-weight: 700; font-size: 16px; cursor: pointer; margin-top: 25px;
            transition: 0.3s;
        }
        .btn-pay:hover { background: var(--primary); transform: translateY(-2px); box-shadow: 0 10px 25px rgba(62, 39, 35, 0.2); }

        #qrisBox, #cashBox, #debitBox { display: none; margin-top: 20px; text-align: center; }

        @media print {
            body * { visibility: hidden; }
            #printableReceipt, #printableReceipt * { visibility: visible; }
            #printableReceipt {
                position: absolute;
                left: 0; top: 0;
                width: 300px;
                display: block !important;
                background: white;
                padding: 10px;
            }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="panel">
        <div style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
            <span style="font-size: 14px; color: #666;">Pelanggan: <b style="color: var(--accent);"><%= namaPelanggan %></b></span>
        </div>
        <h2><i class="fas fa-receipt"></i> Ringkasan Pesanan</h2>
        
        <div style="max-height: 300px; overflow-y: auto; padding-right: 5px;">
            <% for (ItemPesanan item : keranjang) { %>
                <div class="item-box">
                    <div class="item-info">
                        <b><%= item.getNamaMenu() %></b><br>
                        <small><%= item.getJumlah() %> x Rp <%= item.getHarga() %></small>
                    </div>
                    <div class="item-price">Rp <%= item.getHarga() * item.getJumlah() %></div>
                </div>
            <% } %>
        </div>

        <div style="margin-top: 25px; font-size: 15px;">
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;"><span>Subtotal</span><span>Rp <%= subtotal %></span></div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;"><span>PPN (11%)</span><span>Rp <%= ppn %></span></div>
            <hr style="border: 0; border-top: 1px dashed #ddd; margin: 15px 0;">
            <div style="display:flex; justify-content:space-between; font-weight:700; color:var(--deep-coffee); font-size:20px;">
                <span>Total Tagihan</span><span>Rp <%= totalAkhir %></span>
            </div>
        </div>
        <button onclick="location.href='inputmenu.jsp'" style="margin-top:20px; background:none; border:none; color:var(--muted); cursor:pointer; font-size:13px;"><i class="fas fa-arrow-left"></i> Kembali Edit Pesanan</button>
    </div>

    <div class="panel">
        <div class="total-display">
            <small>TOTAL PEMBAYARAN</small>
            <h1>Rp <%= totalAkhir %></h1>
        </div>

        <form action="PaymentServlet" method="post" id="payForm" onsubmit="return validatePayment()">
            <input type="hidden" name="total" value="<%= totalAkhir %>">
            <input type="hidden" id="methodField" name="metodePembayaran" required>

            <label style="font-weight: 600; font-size: 14px; color: var(--primary);">Pilih Metode Pembayaran:</label>
            <div class="method-grid">
                <div class="method-card" id="card-Cash" onclick="selectMethod('Cash', this)">
                    <img src="https://cdn-icons-png.flaticon.com/512/2489/2489756.png" alt="Cash">
                    <div style="font-size: 13px; font-weight: 600;">Cash</div>
                </div>
                <div class="method-card" id="card-QRIS" onclick="selectMethod('QRIS', this)">
                    <img src="https://images.seeklogo.com/logo-png/39/1/quick-response-code-indonesia-standard-qris-logo-png_seeklogo-391791.png" alt="QRIS">
                    <div style="font-size: 13px; font-weight: 600;">QRIS</div>
                </div>
                <div class="method-card" id="card-Debit" onclick="selectMethod('Debit', this)">
                    <img src="https://cdn-icons-png.flaticon.com/512/633/633611.png" alt="Debit">
                    <div style="font-size: 13px; font-weight: 600;">Debit</div>
                </div>
            </div>

            <div id="cashBox">
                <label style="font-size: 13px; font-weight: 600; display: block; text-align: left;">Uang Tunai (Rp):</label>
                <input type="number" name="cash" id="inputCash" placeholder="Contoh: 50000">
            </div>

            <div id="qrisBox">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=BILLIFY-<%= totalAkhir %>" alt="QR Code" style="border: 2px solid #eee; border-radius: 10px; padding: 5px;">
                <p style="font-size: 12px; color: #888; margin-top: 5px;">Scan untuk membayar Rp <%= totalAkhir %></p>
            </div>

            <div id="debitBox">
                <input type="text" name="noReferensi" id="inputDebit" placeholder="Masukkan Nomor Referensi EDC">
            </div>

            <button type="submit" class="btn-pay">KONFIRMASI PEMBAYARAN</button>
        </form>
    </div>
</div>

<div id="printableReceipt" style="display:none; width: 300px; font-family: 'Courier New', monospace; font-size: 12px; color: #000;">
    <center>
        <h2 style="margin:0; font-size: 16px;">INI COFFEE</h2>
        <p style="margin:0;">SmartCafe Billify</p>
        <p style="margin:5px 0;"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()) %></p>
        <p>--------------------------------</p>
    </center>
    
    <table style="width:100%; border-collapse: collapse;">
        <tr><td>Kasir:</td><td align="right"><%= namaKasir %></td></tr>
        <tr><td>Pelanggan:</td><td align="right"><b><%= namaPelanggan %></b></td></tr>
        <tr><td>Metode:</td><td align="right" id="printMetode">-</td></tr>
    </table>
    
    <p>--------------------------------</p>
    
    <table style="width:100%;">
        <% for (ItemPesanan it : keranjang) { %>
            <tr><td colspan="2"><%= it.getNamaMenu() %></td></tr>
            <tr>
                <td>  <%= it.getJumlah() %> x Rp <%= it.getHarga() %></td>
                <td align="right">Rp <%= it.getHarga() * it.getJumlah() %></td>
            </tr>
        <% } %>
    </table>
    
    <p>--------------------------------</p>
    
    <table style="width:100%;">
        <tr><td>Subtotal</td><td align="right">Rp <%= subtotal %></td></tr>
        <tr><td>PPN (11%)</td><td align="right">Rp <%= ppn %></td></tr>
        <tr style="font-weight:bold;"><td>TOTAL</td><td align="right">Rp <%= totalAkhir %></td></tr>
        <tr><td>Bayar</td><td align="right" id="printBayar">Rp 0</td></tr>
        <tr><td>Kembali</td><td align="right" id="printKembali">Rp 0</td></tr>
    </table>
    
    <p>--------------------------------</p>
    <center>
        <p>Terima Kasih Kak <%= namaPelanggan %>!<br>Nikmati Kopi Anda</p>
    </center>
</div>

<script>
    function selectMethod(method, card) {
        document.getElementById("methodField").value = method;
        document.querySelectorAll(".method-card").forEach(el => el.classList.remove("active"));
        card.classList.add("active");
        
        document.getElementById("cashBox").style.display = 'none';
        document.getElementById("qrisBox").style.display = 'none';
        document.getElementById("debitBox").style.display = 'none';
        
        if (method === 'Cash') document.getElementById("cashBox").style.display = 'block';
        else if (method === 'QRIS') document.getElementById("qrisBox").style.display = 'block';
        else if (method === 'Debit') document.getElementById("debitBox").style.display = 'block';
    }

    function validatePayment() {
        const method = document.getElementById("methodField").value;
        if (!method) {
            Swal.fire('Pilih Metode!', 'Silakan pilih metode pembayaran dahulu.', 'warning');
            return false;
        }
        if (method === 'Cash') {
            const cashVal = parseInt(document.getElementById("inputCash").value) || 0;
            const total = <%= totalAkhir %>;
            if (cashVal < total) {
                Swal.fire('Uang Kurang!', 'Uang tunai tidak cukup untuk membayar tagihan.', 'error');
                return false;
            }
        }
        return true;
    }

    function printReceipt(metode, bayar, kembali) {
        document.getElementById('printMetode').innerText = metode;
        document.getElementById('printBayar').innerText = "Rp " + bayar;
        document.getElementById('printKembali').innerText = "Rp " + kembali;
        window.print();
    }

    <% 
        String status = (String) request.getAttribute("status");
        String msg = (String) request.getAttribute("message");
        Object kembalian = request.getAttribute("kembalian");
        if (kembalian == null) kembalian = "0";

        // Logic struk setelah POST sukses
        String lastMethod = request.getParameter("metodePembayaran");
        String lastCash = request.getParameter("cash");
        String bayarDiStruk = ("Cash".equals(lastMethod)) ? lastCash : String.valueOf(totalAkhir);
    %>

    <% if ("success".equals(status)) { %>
        Swal.fire({
            icon: 'success',
            title: 'Transaksi Berhasil!',
            html: 'Metode: <b><%= lastMethod %></b><br>Total: <b>Rp <%= totalAkhir %></b><br>Kembali: <b>Rp <%= kembalian %></b>',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-print"></i> Cetak Struk',
            cancelButtonText: 'Selesai',
            confirmButtonColor: '#3e2723'
        }).then((result) => {
            if (result.isConfirmed) {
                printReceipt('<%= lastMethod %>', '<%= bayarDiStruk %>', '<%= kembalian %>');
                setTimeout(() => { window.location.href = 'inputmenu.jsp?action=clear&next=dashboard'; }, 2000);
            } else {
                window.location.href = 'inputmenu.jsp?action=clear&next=dashboard';
            }
        });
    <% } else if ("error".equals(status)) { %>
        Swal.fire({ icon: 'error', title: 'Gagal', text: '<%= msg %>' });
    <% } %>
</script>
</body>
</html>