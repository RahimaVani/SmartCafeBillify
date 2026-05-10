package com.smartcaafebillify.controller;

import com.smartcafebillify.model.ItemPesanan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/InputMenuServlet")
public class InputMenuServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Ambil data form
        String namaMenu = request.getParameter("namaMenu");
        int harga = Integer.parseInt(request.getParameter("harga"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));

        HttpSession session = request.getSession();

        ArrayList<ItemPesanan> keranjang =
                (ArrayList<ItemPesanan>) session.getAttribute("keranjang");

        if (keranjang == null) {
            keranjang = new ArrayList<>();
        }

        // Tambah item baru
        keranjang.add(new ItemPesanan(namaMenu, harga, jumlah));

        // Simpan kembali
        session.setAttribute("keranjang", keranjang);

        // BALIK KE INPUT MENU
        response.sendRedirect("inputmenu.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}