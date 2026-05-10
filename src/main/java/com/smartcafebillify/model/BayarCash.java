package com.smartcafebillify.model;

public class BayarCash extends MetodePembayaran {
    public BayarCash(int total) {
        super(total);
    }

    @Override
    public int hitungKembalian(int bayar) {
        return bayar - total;
    }

    @Override
    public boolean isCukup(int bayar) {
        return bayar >= total;
    }
}