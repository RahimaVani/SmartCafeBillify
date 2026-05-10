/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.smartcafebillify.model;

public class Transaksi {

    private String idTransaksi;
    private String tanggal;
    private String namaMenu;
    private int jumlah;
    private int harga;
    private String metodePembayaran;

    public Transaksi(String idTransaksi, String tanggal, String namaMenu, int jumlah, int harga, String metodePembayaran) {
        this.idTransaksi = idTransaksi;
        this.tanggal = tanggal;
        this.namaMenu = namaMenu;
        this.jumlah = jumlah;
        this.harga = harga;
        this.metodePembayaran = metodePembayaran;
    }

    public String getIdTransaksi() { return idTransaksi; }
    public String getTanggal() { return tanggal; }
    public String getNamaMenu() { return namaMenu; }
    public int getJumlah() { return jumlah; }
    public int getHarga() { return harga; }
    public String getMetodePembayaran() { return metodePembayaran; }

    // Tambahan untuk laporan
    public int getTotal() { return harga * jumlah; }

    // FIX untuk JSP-mu
    public int getSubtotal() { return harga * jumlah; }
}