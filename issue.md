# Phase 4 & 5: Navigation, Dashboard & Transaction

Tugas ini bertujuan untuk membangun navigasi utama aplikasi (*Bottom Navigation*), halaman depan (*Home Dashboard*), serta fitur pencatatan transaksi manual berdasarkan spesifikasi di dokumen `design.md`.

## 1. Branching
Buka terminal, pastikan Anda berada di _branch_ utama, dan buat _branch_ baru:
```bash
git checkout -b feature/phase-4-5-dashboard-transaction
```

## 2. Implementasi App Navigation & Routing
Pusat navigasi utama aplikasi menggunakan **Bottom Navigation Bar**:
1. Buat komponen layout utama (misal: `MainNavigationScreen`) yang berfungsi sebagai struktur pembungkus tab utama: **Home**, **History**, **Savings**, dan **Insights**. Integrasikan dengan mekanisme navigasi GoRouter (seperti menggunakan `ShellRoute` atau IndexedStack).
2. **Floating Quick Action (FAB)**: Letakkan FAB tepat di **tengah** Bottom Navigation Bar. Saat di-klik, FAB memicu munculnya pilihan (menu/bottom sheet):
   - Tambah Pemasukan
   - Tambah Pengeluaran
   - Scan OCR

## 3. Implementasi Home Dashboard
Kembangkan tampilan layar `HomeScreen` (Dashboard) dengan panduan gaya dari `design.md`:
1. **Header**: Memuat Sapaan/Greeting, Avatar, serta ilustrasi Maskot.
2. **Balance Card (Hero Widget)**:
   - Aplikasikan desain kotak dengan warna dasar gradien Coral ke Soft Yellow (`#F38181` → `#FCE38A`).
   - Tampilkan nominal saldo secara besar diiringi efek angka berjalan (*Animated counter*).
   - Lengkapi dengan teks "Sisa bulan ini" dan pesan dinamis seperti "Masih aman untuk hari ini".
   - Tempatkan Mini Momo di pojok kartu (berikan *logic* sederhana agar posenya (*happy/calm/concerned*) berubah berdasarkan rasio pengeluaran terhadap saldo atau anggaran).
3. **Quick Actions Card**:
   - Sediakan _Card_ putih minimalis di bawah _Balance Card_.
   - Taruh 3 menu cepat: **Keluar** (_shopping bag icon_), **Masuk** (_money bag icon_), dan **Scan** (_receipt scanner icon_).
4. **Widget Daftar**: Sediakan _section_ untuk pratinjau tabungan, rangkuman hari ini, dan Daftar Transaksi Terkini (*Recent Transactions*). Pastikan *Empty State* pada daftar ini memakai ilustrasi Momo yang sedang tertidur (`empty-transaction.png`).

## 4. Implementasi Add Transaction Screen
Buat fungsionalitas bagi pengguna untuk mencatat arus masuk dan keluar.
1. **Amount Input**: Jadikan input nominal angka "Rp 0" sebagai elemen terbesar (Hero) di bagian atas secara *centered* dan *clean*.
2. **Transaction Type Toggle**: Sediakan komponen *switch* / *tab bar* untuk pindah *mode* pencatatan antara "Pemasukan" dan "Pengeluaran".
3. **Category Grid**: Buat 2-4 kolom susunan ikon kategori (mengambil dari referensi _Categories table_ di _database_ Drift). Beri *styling selected* pada item yang dipilih (misal garis bingkai Coral/Tosca dan animasi sedikit membesar *scale 1.05*).
4. **Kelengkapan Data**: Berikan area _Wallet Picker_, penanggalan (_Date Picker_), dan kolom teks (_Note_).
5. **Logic (Save to DB)**: Simpan data (INSERT ke `Transactions` dan perbarui nilai di `Wallets`). Gunakan animasi _check pop_ sesaat setelah berhasil menyimpan.

## 5. Update TODO & Finalisasi
1. Buka file `TODO.md` lalu ubah status `[ ]` menjadi `[x]` pada semua butir _checklist_ di **Phase 4 — Navigation & Dashboard** dan **Phase 5 — Transaction**.
2. _Commit_ dan dorong (_push_) pekerjaan ke repositori:
```bash
git add .
git commit -m "Implement Phase 4 and 5: Navigation, Dashboard and Transaction"
git push -u origin feature/phase-4-5-dashboard-transaction
```
3. Buat Pull Request melalui terminal Anda:
```bash
ghp pr create --title "Phase 4 & 5: Dashboard and Transaction" --body "Menyelesaikan struktur App Navigation, Home Dashboard, dan Layar Tambah Transaksi."
```
