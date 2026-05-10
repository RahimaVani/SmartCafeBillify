package com.smartcaafebillify.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/MoodServlet")
public class MoodServlet extends HttpServlet {

//konfigurasi database
    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/smartcafebillify?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        // ambil session
        HttpSession session = request.getSession();
        
        // ambil nama pelanggan dari parameter
        String customerName = request.getParameter("customerName");
        
        // logika sinkronisasi nama
        if (customerName != null && !customerName.trim().isEmpty()) {
            // Jika ada nama dari form, simpan/update ke session agar awet
            session.setAttribute("customerName", customerName);
        } else {
            // Jika form kosong (tidak mungkin jika hidden input jalan), ambil dari session
            customerName = (String) session.getAttribute("customerName");
        }

        // jika benar-benar kosong, set default
        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = "Pelanggan Umum";
        }

        String mood = request.getParameter("mood");
        String rasa = request.getParameter("rasa");

        List<Menu> rekomendasi = new ArrayList<>();

        // validasi pilihan mood dan rasa
        if (mood == null || rasa == null || mood.isEmpty() || rasa.isEmpty()) {
            request.setAttribute("error", "Mood dan rasa harus dipilih.");
            request.setAttribute("customerName", customerName); // tetap kirim nama meski error
            request.getRequestDispatcher("recommendation.jsp").forward(request, response);
            return;
        }

        //query database
        String sql = "SELECT nama_menu, harga FROM menu WHERE mood = ? AND rasa = ? LIMIT 5";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, mood);
                ps.setString(2, rasa);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String namaMenu = rs.getString("nama_menu");
                        int harga = rs.getInt("harga");
                        rekomendasi.add(new Menu(namaMenu, harga));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

      //kirim data ke jsp
        request.setAttribute("mood", mood);
        request.setAttribute("rasa", rasa);
        request.setAttribute("rekomendasi", rekomendasi);
        
        request.setAttribute("customerName", customerName);

        request.getRequestDispatcher("recommendation.jsp").forward(request, response);
    }

//class menu
    public static class Menu {
        private String nama;
        private int harga;

        public Menu(String nama, int harga) {
            this.nama = nama;
            this.harga = harga;
        }

        public String getNama() { return nama; }
        public int getHarga() { return harga; }
    }
}