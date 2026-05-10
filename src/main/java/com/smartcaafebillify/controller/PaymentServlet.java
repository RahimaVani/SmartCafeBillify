package com.smartcaafebillify.controller;

import com.smartcafebillify.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil data dari form
        int total = Integer.parseInt(request.getParameter("total"));
        String metodeStr = request.getParameter("metodePembayaran");
        String cashInput = request.getParameter("cash");
        int bayarUser = (cashInput == null || cashInput.isEmpty()) ? 0 : Integer.parseInt(cashInput);

        // 2. PENERAPAN POLYMORPHISM
        // Kita gunakan variabel tipe Abstract (MetodePembayaran)
        MetodePembayaran mp;

        if ("Cash".equals(metodeStr)) {
            mp = new BayarCash(total); // Wujudnya jadi Cash
        } else {
            // Wujudnya jadi Digital (berlaku untuk QRIS dan Debit)
            mp = new BayarDigital(total); 
        }

        // 3. Validasi menggunakan Method dari Polymorphism
        if (!mp.isCukup(bayarUser)) {
            request.setAttribute("status", "error");
            request.setAttribute("message", "Uang tunai tidak mencukupi!");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            return;
        }

        // 4. Hitung kembalian menggunakan Method dari Polymorphism
        int kembalian = mp.hitungKembalian(bayarUser);

        // 5. Proses Simpan Transaksi (Session Logic)
        HttpSession session = request.getSession();
        List<ItemPesanan> keranjang = (List<ItemPesanan>) session.getAttribute("keranjang");
        List<Transaksi> transaksiList = (List<Transaksi>) session.getAttribute("transaksiList");
        
        if (transaksiList == null) {
            transaksiList = new ArrayList<>();
        }

        String idTrx = "TRX" + System.currentTimeMillis();
        String tanggal = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        if (keranjang != null) {
            for (ItemPesanan item : keranjang) {
                transaksiList.add(new Transaksi(
                    idTrx, 
                    tanggal, 
                    item.getNamaMenu(), 
                    item.getJumlah(), 
                    item.getHarga(), 
                    metodeStr
                ));
            }
        }

        // 6. Finalisasi
        session.setAttribute("transaksiList", transaksiList);
        
        //session.removeAttribute("keranjang"); 

        // Kirim data tambahan ke JSP agar struk bisa mencatat item terakhir
        request.setAttribute("status", "success");
        request.setAttribute("kembalian", kembalian);
        
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }
}