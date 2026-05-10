package com.smartcaafebillify.controller;

import com.smartcafebillify.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 1️⃣ VALIDASI INPUT
        if (username == null || password == null ||
            username.isEmpty() || password.isEmpty()) {

            request.setAttribute("error", "Username dan password wajib diisi!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // konek database
            Connection conn = DBConnection.getConnection();

            // cek user di database
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // jika login berhasil
                HttpSession session = request.getSession();
                session.setAttribute("username", username);

                response.sendRedirect("dashboard.jsp");
            } else {
                // jika login gagal
                request.setAttribute("error", "Username atau password salah!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan server");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}