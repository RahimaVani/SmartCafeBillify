<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.smartcafebillify.model.Transaksi" %>

<!DOCTYPE html>
<html>
<head>
    <title>Laporan Transaksi — Café Billify</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    
    <style>
        :root {
            --primary-coffee: #6d4c41;
            --accent-orange: #b8743b;
            --bg-body: #f3ece4;
            --white: #ffffff;
            --success: #2e7d32;
        }

        body { 
            background: var(--bg-body); 
            font-family: 'Poppins', sans-serif; 
            margin: 0; padding: 0; 
            color: #3e2723;
        }

        .container {
            width: 90%; max-width: 1200px; margin: 40px auto; background: var(--white);
            padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(107, 79, 63, 0.15);
        }

        h2 { text-align: center; color: var(--primary-coffee); font-weight: 700; font-size: 28px; margin-bottom: 30px; }
        
        /* Filter Section Styling */
        .filter-section {
            background: #fdfaf6; padding: 20px; border-radius: 15px; 
            margin-bottom: 25px; border: 1.5px solid #eee;
            display: flex; align-items: center; justify-content: center; gap: 15px;
        }

        .filter-section label { font-weight: 600; color: var(--primary-coffee); }

        select {
            padding: 10px 20px; border-radius: 10px; border: 1px solid #d7ccc8;
            font-family: inherit; outline: none; cursor: pointer;
        }

        /* Table Styling */
        .table-wrapper { overflow-x: auto; border-radius: 15px; border: 1px solid #f0f0f0; }

        table { width: 100%; border-collapse: collapse; background: white; }
        th { 
            background: var(--primary-coffee); color: white; padding: 18px 12px; 
            font-size: 14px; text-transform: uppercase; letter-spacing: 1px;
        }
        td { padding: 15px 12px; border-bottom: 1px solid #f5f5f5; text-align: center; font-size: 14px; }
        
        tr:hover td { background: #fffcf9; }

        /* Status & Badge */
        .badge-method {
            padding: 5px 12px; border-radius: 8px; font-size: 12px; font-weight: 600;
            background: #efebe9; color: var(--primary-coffee);
        }

        /* Total Box Styling */
        .total-box {
            margin-top: 30px; text-align: center; padding: 25px;
            font-size: 20px; font-weight: 600; color: #fff;
            background: linear-gradient(135deg, var(--primary-coffee), #4e342e);
            border-radius: 15px; box-shadow: 0 8px 20px rgba(109, 76, 65, 0.3);
        }
        #displayTotal { font-size: 28px; font-weight: 700; display: block; margin-top: 5px; }

        /* Buttons */
        .action-center { text-align: center; margin-top: 30px; display: flex; justify-content: center; gap: 15px; }
        
        .btn {
            padding: 14px 35px; border: none; border-radius: 12px; cursor: pointer; 
            font-weight: 700; font-family: inherit; transition: 0.3s; display: flex; align-items: center; gap: 10px;
        }

        .btn-back { background: #fff; color: var(--primary-coffee); border: 2px solid var(--primary-coffee); }
        .btn-back:hover { background: #efebe9; }

        .btn-export { background: var(--success); color: white; }
        .btn-export:hover { background: #1b5e20; transform: translateY(-3px); box-shadow: 0 5px 15px rgba(46, 125, 50, 0.3); }

        .empty-state { text-align: center; padding: 50px; color: #a1887f; }
        .empty-state i { font-size: 50px; margin-bottom: 15px; opacity: 0.5; }
    </style>

    <script>
        function saringData() {
            var input = document.getElementById("filterMetode");
            var filter = input.value.toUpperCase();
            var table = document.getElementById("tabelLaporan");
            var tr = table.getElementsByTagName("tr");
            var totalBaru = 0;

            for (var i = 1; i < tr.length; i++) {
                var tdMetode = tr[i].getElementsByTagName("td")[6]; 
                if (tdMetode) {
                    var txtValue = tdMetode.textContent || tdMetode.innerText;
                    if (filter === "ALL" || txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                        var subtotalTxt = tr[i].getElementsByTagName("td")[5].innerText;
                        totalBaru += parseInt(subtotalTxt.replace(/[^0-9]/g, ''));
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
            document.getElementById("displayTotal").innerText = "Rp " + totalBaru.toLocaleString('id-ID');
        }

        function exportToExcel() {
            var table = document.getElementById("tabelLaporan");
            var wb = XLSX.utils.table_to_book(table, {sheet: "Laporan Transaksi"});
            XLSX.writeFile(wb, "Laporan_Transaksi_SmartCafe.xlsx");
        }
    </script>
</head>
<body>

<div class="container">
    <h2><i class="fas fa-file-invoice-dollar"></i> Laporan Transaksi</h2>

    <%
        List<Transaksi> transaksiList = (List<Transaksi>) request.getAttribute("transaksiList");
        if (transaksiList == null || transaksiList.isEmpty()) {
    %>
        <div class="empty-state">
            <i class="fas fa-folder-open"></i>
            <p>Belum ada transaksi yang tercatat hari ini.</p>
        </div>
    <% } else { %>
        
        <div class="filter-section">
            <label><i class="fas fa-filter"></i> Saring Metode:</label>
            <select id="filterMetode" onchange="saringData()">
                <option value="ALL">Semua Metode</option>
                <option value="Cash">Cash</option>
                <option value="QRIS">QRIS</option>
                <option value="Debit">Debit</option>
            </select>
        </div>

        <div class="table-wrapper">
            <table id="tabelLaporan">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tanggal</th>
                        <th>Menu</th>
                        <th>Qty</th>
                        <th>Harga Dasar</th>
                        <th>Subtotal (Inc. PPN)</th>
                        <th>Metode</th>
                    </tr>
                </thead>
                <tbody>
                <% 
                    double totalPendapatanGross = 0;
                    for (Transaksi trx : transaksiList) { 
                        int hargaDasarTotal = trx.getHarga() * trx.getJumlah();
                        double ppn = hargaDasarTotal * 0.11;
                        double subtotalFinal = hargaDasarTotal + ppn;
                        totalPendapatanGross += subtotalFinal;
                %>
                    <tr>
                        <td style="font-weight: 600; color: #8d6e63;">#<%= trx.getIdTransaksi() %></td>
                        <td><%= trx.getTanggal() %></td>
                        <td style="font-weight: 600;"><%= trx.getNamaMenu() %></td>
                        <td><%= trx.getJumlah() %></td>
                        <td>Rp <%= String.format("%,d", trx.getHarga()).replace(',', '.') %></td>
                        <td style="font-weight: 700; color: var(--success);">
                            Rp <%= String.format("%,d", (int)subtotalFinal).replace(',', '.') %>
                        </td>
                        <td><span class="badge-method"><%= trx.getMetodePembayaran() %></span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="total-box">
            <span>Total Pendapatan Bersih</span>
            <span id="displayTotal">Rp <%= String.format("%,d", (int)totalPendapatanGross).replace(',', '.') %></span>
        </div>
    <% } %>

    <div class="action-center">
        <button onclick="location.href='dashboard.jsp'" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> Kembali
        </button>
        <button onclick="exportToExcel()" class="btn btn-export">
            <i class="fas fa-file-excel"></i> Export Excel
        </button>
    </div>
</div>

</body>
</html>