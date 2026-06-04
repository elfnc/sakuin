# PRD.md

# Sakuin

**Version:** 1.0 MVP

**Platform:** Flutter (Android & iOS)

**Status:** Side Project / Portfolio Product

---

# 1. Product Overview

Sakuin adalah aplikasi pencatatan keuangan harian yang dirancang agar terasa ringan, menyenangkan, dan tidak mengintimidasi.

Banyak aplikasi keuangan terasa seperti software akuntansi mini.

Sakuin dibuat untuk orang biasa yang hanya ingin tahu:

* uang masuk berapa
* uang keluar kemana
* sudah nabung berapa
* bulan ini aman atau tidak

Tanpa istilah finansial yang rumit.

---

# 2. Problem Statement

Mayoritas orang:

* malas mencatat keuangan
* lupa uang habis untuk apa
* tidak punya gambaran kondisi keuangan bulanan
* merasa aplikasi keuangan terlalu kompleks

Akibatnya:

* pengeluaran tidak terkontrol
* target tabungan tidak tercapai
* tidak sadar pola boros

---

# 3. Product Vision

Menjadi companion harian yang membantu pengguna memahami kondisi keuangan mereka tanpa membuat mereka merasa sedang mengelola spreadsheet.

---

# 4. Target Audience

## Primary

Usia:

18–35 tahun

Profesi:

* karyawan
* mahasiswa
* pekerja pabrik
* freelancer
* fresh graduate

Karakteristik:

* tidak suka budgeting ribet
* ingin mulai mengatur uang
* sering menggunakan e-wallet

---

# 5. Core Value Proposition

Bukan:

* aplikasi investasi
* aplikasi akuntansi
* aplikasi bank

Melainkan:

> cara paling sederhana untuk memahami kemana uang pergi setiap hari

---

# 6. Brand Personality

Sakuin terasa seperti:

* ramah
* ringan
* tidak menghakimi
* membantu

Tidak pernah menggunakan bahasa:

❌ "Pengeluaran Anda tidak efisien"

Lebih memilih:

✅ "Sepertinya bulan ini banyak pengeluaran untuk makan di luar."

---

# 7. MVP Features

## 7.1 Dashboard

Menampilkan:

* saldo saat ini
* uang masuk bulan ini
* uang keluar bulan ini
* total tabungan
* ringkasan kondisi keuangan

---

## 7.2 Catat Transaksi

Jenis transaksi:

### Income

Contoh:

* Gaji
* Bonus
* Freelance
* Hadiah

### Expense

Contoh:

* Makan
* Transport
* Belanja
* Hiburan
* Tagihan

### Savings

Contoh:

* Nabung monitor
* Nabung motor
* Dana darurat

---

## 7.3 OCR Receipt Scanner

Pengguna dapat:

* foto struk
* sistem membaca nominal
* sistem mengisi nominal otomatis
* pengguna review
* simpan transaksi

---

## 7.4 Transaction History

Filter:

* hari ini
* minggu ini
* bulan ini

Pencarian:

* kategori
* catatan

---

## 7.5 Savings Goal

User dapat membuat target.

Contoh:

Target:

Monitor LG

Nominal:

Rp 2.500.000

Progress:

Rp 750.000

Persentase:

30%

---

## 7.6 Monthly Insight

Menampilkan:

* kategori terbesar
* total transaksi
* total tabungan
* tren pengeluaran

Insight sederhana:

"Pengeluaran terbesar bulan ini berasal dari kategori Makan."

---

# 8. Out of Scope

Tidak masuk MVP:

* investasi
* saham
* crypto
* sinkronisasi bank
* split bill
* hutang piutang
* AI financial advisor
* multi-user account

---

# 9. User Flow

## Tambah Pengeluaran

Home

↓

Tambah

↓

Pilih Pengeluaran

↓

Isi Nominal

↓

Pilih Kategori

↓

Simpan

↓

Animasi Berhasil

---

## Scan Struk

Home

↓

Scan

↓

Kamera

↓

OCR

↓

Review

↓

Simpan

---

## Menabung

Home

↓

Target Tabungan

↓

Tambah Target

↓

Input Nominal

↓

Update Progress

↓

Animasi Progress

---

# 10. Screens

## Onboarding

3 halaman

### Slide 1

Catat uang tanpa ribet

### Slide 2

Lihat kemana uang pergi

### Slide 3

Capai target tabunganmu

---

## Home

Komponen:

* Greeting
* Balance Card
* Quick Action
* Savings Card
* Recent Transaction

---

## Add Transaction

Komponen:

* Amount Input
* Category
* Note
* Date
* Save Button

---

## OCR Scanner

Komponen:

* Camera Preview
* Scan Animation
* OCR Result
* Confirmation

---

## History

Komponen:

* Search
* Filter
* List Transaction

---

## Savings Goal

Komponen:

* Goal Card
* Progress Bar
* Contribution Button

---

## Monthly Insight

Komponen:

* Chart
* Statistics
* Insight Card

---

# 11. Mascot System

Nama:

Momo

Bentuk:

Dompet kecil lucu

Fungsi:

Memberi feedback ringan.

Contoh:

Saat nabung:

"Sedikit demi sedikit juga tetap maju."

Saat target tercapai:

"Kita berhasil!"

Saat transaksi berhasil:

"Sudah dicatat."

---

# 12. Animation System

## Success

Scale + Bounce

Durasi:

300ms

---

## Balance Update

Animated Counter

Durasi:

500ms

---

## Savings Progress

Progress Fill Animation

Durasi:

700ms

---

## OCR

Scanning Line Animation

Durasi:

Looping sampai hasil keluar

---

# 13. Technical Stack

Frontend:

Flutter

State Management:

Riverpod

Database:

Isar

OCR:

Google ML Kit

Chart:

fl_chart

Animation:

flutter_animate

Lottie

Storage:

Local First

---

# 14. Success Metrics

MVP dianggap berhasil jika:

* user dapat mencatat transaksi < 10 detik
* OCR berhasil membaca nominal mayoritas struk
* user membuka aplikasi minimal 1x per hari
* target tabungan dapat dipantau dengan mudah

---

# 15. Future Features

V2:

* Cloud Sync
* Multi Device
* Export PDF
* Export Excel
* Shared Wallet
* Recurring Transaction
* Widget Home Screen
* Dark Mode
* Budget Challenge
* Smart Spending Insight
