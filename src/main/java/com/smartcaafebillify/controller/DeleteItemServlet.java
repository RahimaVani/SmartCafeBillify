package com.smartcaafebillify.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import com.smartcafebillify.model.ItemPesanan;

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {

  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String indexStr = request.getParameter("index");
    HttpSession session = request.getSession();
    ArrayList<ItemPesanan> keranjang = (ArrayList<ItemPesanan>) session.getAttribute("keranjang");

    if (keranjang != null && indexStr != null) {
        int index = Integer.parseInt(indexStr);
        if (index >= 0 && index < keranjang.size()) {
            keranjang.remove(index);
        }
    }

    session.setAttribute("keranjang", keranjang);

    response.sendRedirect("inputmenu.jsp"); 
    }
}