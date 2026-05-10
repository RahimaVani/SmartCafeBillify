package com.smartcaafebillify.controller;

import com.smartcafebillify.model.Transaksi;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LaporanTransaksiServlet")
public class LaporanTransaksiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Transaksi> transaksiList = 
            (List<Transaksi>) session.getAttribute("transaksiList");

        request.setAttribute("transaksiList", transaksiList);
        request.getRequestDispatcher("LaporanTransaksi.jsp")
               .forward(request, response);
    }
}
