package com.smartcafebillify.model;

public class BayarDigital extends MetodePembayaran {
    public BayarDigital(int total) {
        super(total);
    }

    @Override
    public int hitungKembalian(int bayar) {
        return 0;
    }

    @Override
    public boolean isCukup(int bayar) {
        return true;
    }
}