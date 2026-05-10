package com.smartcaafebillify.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hapus semua session
        HttpSession session = request.getSession();
        session.invalidate();

        // Kembali ke login
        response.sendRedirect("login.jsp");
    }
}