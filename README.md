# 📱 U-Manage

### Aplikasi Manajemen UMKM

**Ujian Akhir Semester – Pemrograman Mobile 2**
**Nama:** Salsa Billa Syazwani

---

## 📌 Deskripsi Aplikasi

**U-Manage** merupakan aplikasi manajemen Usaha Mikro, Kecil, dan Menengah (UMKM) yang dirancang untuk membantu pelaku usaha dalam mengelola **data produk, stok, transaksi, laporan, serta perhitungan Harga Pokok Produksi (HPP)** secara terstruktur dan efisien.

Aplikasi ini ditujukan bagi UMKM, khususnya pada sektor **makanan, minuman, dan retail**, dengan tujuan mendukung pencatatan aktivitas usaha agar lebih tertata, terkontrol, dan berbasis data digital.

---

## 🎯 Tujuan Aplikasi

Tujuan pengembangan aplikasi **U-Manage** adalah sebagai berikut:

* Membantu pelaku UMKM dalam memantau omset dan penjualan secara real-time
* Menyediakan pengelolaan data produk dan stok secara terpusat
* Memfasilitasi pencatatan transaksi penjualan secara akurat
* Menyajikan laporan usaha secara sistematis dan informatif
* Membantu penentuan harga jual melalui perhitungan Harga Pokok Produksi (HPP)

---

## 🧭 Navigasi Aplikasi

Aplikasi **U-Manage** memiliki lima menu utama, yaitu:

1. Dashboard
2. Transaksi
3. Order
4. Laporan
5. Akun

---

## 📊 Fitur Dashboard

Menu **Dashboard** berfungsi sebagai halaman utama yang menampilkan ringkasan kondisi usaha secara umum, meliputi:

* Omset harian dan bulanan
* Jumlah produk terjual harian dan bulanan
* Informasi produk terlaris
* Akses cepat ke fitur input produk
* Akses ke daftar produk
* Akses ke fitur perhitungan HPP

Dashboard dirancang untuk memberikan gambaran singkat mengenai performa usaha sehingga pengguna dapat mengambil keputusan bisnis dengan lebih cepat dan tepat.

---

## 📦 Fitur Produk

### ➕ Input Produk

Fitur **Input Produk** digunakan untuk menambahkan data produk baru ke dalam sistem. Pengguna diwajibkan mengisi informasi produk secara lengkap, yang meliputi:

* **Tanggal pembuatan (Manufacturing Date / MFG)**
* **Nama produk**
* **Kategori produk**
* **Satuan produk**
* **Harga produk**
* **Jumlah stok produk**
* **Tanggal kedaluwarsa (Expired Date / EXP)**

Data produk yang telah diinput akan disimpan ke dalam basis data dan secara otomatis tersedia pada fitur daftar produk serta dapat digunakan dalam proses transaksi.

---

### 📋 Daftar Produk

Fitur **Daftar Produk** menampilkan seluruh data produk yang telah tersimpan di dalam sistem. Pada menu ini, pengguna dapat:

* Melihat informasi lengkap setiap produk
* Melakukan perubahan (update) data produk
* Menghapus data produk yang sudah tidak digunakan
* Memantau jumlah stok produk secara langsung

Fitur ini bertujuan untuk memastikan pengelolaan data produk tetap akurat dan selalu diperbarui.

---

## 🛒 Fitur Transaksi dan Order

### 💳 Transaksi

Menu **Transaksi** digunakan untuk mencatat aktivitas pembelian pelanggan, dengan informasi yang dicatat meliputi:

* Produk yang dibeli
* Jumlah produk
* Total harga pembelian

---

### 🧾 Order

Menu **Order** merupakan kelanjutan dari proses transaksi. Pada fitur ini, sistem menyediakan:

* Metode pembayaran (saat ini mendukung pembayaran secara tunai/cash)
* Proses penyimpanan data transaksi ke dalam sistem
* Pengurangan stok produk secara otomatis
* Tampilan struk transaksi setelah proses berhasil

---

## 📑 Fitur Laporan

Menu **Laporan** menyediakan berbagai jenis laporan sebagai berikut:

1. **Laporan Produk**
   Menampilkan daftar produk beserta informasi harga, stok, dan status produk.

2. **Laporan Mutasi Produk**
   Menampilkan pergerakan produk masuk dan keluar selama periode tertentu.

3. **Laporan Transaksi**
   Menampilkan data transaksi berdasarkan periode yang dipilih.

4. **Laporan Detail Transaksi**
   Menampilkan rincian setiap transaksi, termasuk produk, jumlah, harga satuan, dan subtotal.

5. **Laporan Rekap Produk**
   Menampilkan rekapitulasi penjualan produk berdasarkan periode harian, bulanan, dan tahunan.

6. **Laporan HPP**
   Menampilkan hasil perhitungan Harga Pokok Produksi untuk setiap produk.

---

## 👤 Fitur Akun

Menu **Akun** digunakan untuk pengelolaan profil dan keamanan aplikasi, yang meliputi:

* Pengubahan data profil toko (nama toko dan nama pemilik)
* Pengaturan username dan password
* Proses logout dari aplikasi

---

## 🧮 Fitur Hitung HPP (Harga Pokok Produksi)

Fitur **Hitung HPP** digunakan untuk menghitung total biaya produksi dan menentukan harga jual produk secara sistematis.

### Data Produk

* Nama produk
* Jumlah produksi

### Biaya Variabel (Bahan Baku)

* Nama bahan baku
* Harga bahan baku
  (Data dapat ditambahkan lebih dari satu item)

### Biaya Tetap (Tenaga Kerja)

* Nama biaya
* Harga
* Satuan biaya (per bulan, hari, jam, atau porsi)

### Biaya Overhead

* Nama biaya
* Harga satuan
* Periode biaya (bulan, hari, jam, atau porsi)

### Biaya Tak Terduga

* Opsi aktif atau tidak aktif
* Persentase biaya tak terduga jika diaktifkan

### Pajak

* Persentase pajak yang berlaku

### Margin Laba

* Margin laba dalam bentuk persentase atau nominal rupiah

---

## 📈 Hasil Perhitungan HPP

Setelah pengguna menekan tombol **Hitung HPP**, sistem akan menampilkan hasil perhitungan berupa:

* Total Harga Pokok Produksi
* HPP per unit produk
* Harga jual per unit
* Harga jual setelah pajak
* Laba per produk

---

## ✅ Kesimpulan

Aplikasi **U-Manage** merupakan solusi manajemen UMKM yang menyediakan fitur lengkap untuk pengelolaan produk, stok, transaksi, laporan, serta perhitungan Harga Pokok Produksi (HPP). Dengan adanya aplikasi ini, pelaku UMKM diharapkan dapat mengelola usaha secara lebih profesional, sistematis, dan berbasis data.

---
