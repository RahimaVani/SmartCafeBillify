package com.smartcafebillify.model;

public abstract class MetodePembayaran {
    protected int total;

    public MetodePembayaran(int total) {
        this.total = total;
    }

    public abstract int hitungKembalian(int bayar);
    public abstract boolean isCukup(int bayar);
}