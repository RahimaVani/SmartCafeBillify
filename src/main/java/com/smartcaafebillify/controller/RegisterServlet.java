package com.smartcaafebillify.controller;

import com.smartcafebillify.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        //Mengambil data dari apa yang diketik user di form JSP
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        // VALIDASI FIELD untuk pastiin tidak ada kotak yang kosong
        if (username.isEmpty() || password.isEmpty() || confirm.isEmpty()) {
            request.setAttribute("error", "Semua field wajib diisi!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        //VALIDASI PASSWORD cek apakah password dan konfirmasinya cocok
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Password dan konfirmasi tidak sama!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            // koneksi database
            Connection conn = DBConnection.getConnection();

            // cek username sudah ada atau tidak
            String checkSql = "SELECT id FROM users WHERE username = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, username);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Username sudah terdaftar!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // INSERT DATA masukkan user baru ke tabel database
            String insertSql = "INSERT INTO users (username, password) VALUES (?, ?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql);
            insertPs.setString(1, username);
            insertPs.setString(2, password);
            insertPs.executeUpdate();

           
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan server");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}