# design.md

# Sakuin Design System

**Product:** Sakuin
**Platform:** Flutter
**Style Direction:** Playful calm finance companion
**Goal:** Membuat aplikasi keuangan yang ringan, menyenangkan, visual, dan tidak terasa seperti spreadsheet.

---

# 1. Design Philosophy

Sakuin bukan aplikasi keuangan yang kaku.

Sakuin harus terasa seperti:

* dompet digital kecil yang ramah
* catatan uang harian yang ringan
* teman yang membantu user lebih sadar uangnya
* bukan aplikasi bank
* bukan aplikasi akuntansi

Prinsip utama:

> uang adalah hal serius, tapi mencatat uang tidak harus terasa berat.

---

# 2. Visual Personality

## Keywords

* Warm
* Friendly
* Soft
* Playful
* Clean
* Daily-use
* Light financial awareness

## Avoid

* terlalu corporate
* terlalu bank app
* terlalu banyak grafik
* terlalu banyak angka besar
* warna merah menyala berlebihan
* layout spreadsheet
* icon outline generic semua

---

# 3. Color Palette

## Base Palette

Palette utama menggunakan inspirasi:

```txt
Coral     #F38181
Yellow    #FCE38A
Mint      #EAFFD0
Tosca     #95E1D3
```

Palette ini cocok karena terasa:

* hangat
* approachable
* tidak mengintimidasi
* playful
* cocok untuk daily tracker

Namun palette ini wajib ditambah neutral system agar UI tetap matang.

---

# 4. Final Color System

## Primary

```txt
Primary / Coral
#F38181
```

Usage:

* CTA utama
* highlight nominal penting
* button aktif
* mascot accent
* empty state illustration accent

Jangan terlalu sering dipakai untuk background penuh karena bisa terasa terlalu manis.

---

## Secondary

```txt
Secondary / Tosca
#95E1D3
```

Usage:

* card tabungan
* success visual
* progress area
* calm highlight
* icon background

---

## Soft Accent

```txt
Soft Yellow
#FCE38A
```

Usage:

* badge
* warning ringan
* card insight
* decorative blob
* coin illustration

---

## Soft Background

```txt
Soft Mint
#EAFFD0
```

Usage:

* background illustration
* onboarding slide
* savings success state
* calm empty state

Gunakan secara tipis, jangan terlalu banyak karena bisa membuat UI terlalu pucat.

---

# 5. Neutral Colors

```txt
Background      #FFFDF8
Surface         #FFFFFF
Surface Soft    #F8FAFC
Border          #E5E7EB
Text Primary    #1F2937
Text Secondary  #64748B
Text Muted      #94A3B8
```

Background utama tidak putih polos, tapi warm off-white agar lebih nyaman dilihat.

---

# 6. Semantic Colors

```txt
Income          #36C690
Expense         #F38181
Saving          #95E1D3
Warning         #F59E0B
Danger          #EF4444
Info            #60A5FA
```

Rules:

* Income jangan hijau terlalu neon.
* Expense pakai coral, bukan merah agresif.
* Saving pakai tosca agar terasa adem.
* Danger hanya untuk delete/error, bukan semua pengeluaran.

---

# 7. Gradient System

Gunakan gradient lembut, bukan gradient norak.

## Balance Card

```txt
#F38181 → #FCE38A
```

## Savings Card

```txt
#95E1D3 → #EAFFD0
```

## OCR Scanner

```txt
#95E1D3 → #FFFFFF
```

## Empty State

```txt
#EAFFD0 → #FFFDF8
```

---

# 8. Typography

## Recommended Font

Gunakan:

```txt
Plus Jakarta Sans
```

Alasan:

* modern
* friendly
* readable
* cocok untuk angka dan UI mobile
* tidak terlalu formal

## Alternative

```txt
Nunito Sans
```

Lebih playful, tapi sedikit kurang premium.

## Type Scale

```txt
Display      32 / Bold
Heading 1    28 / Bold
Heading 2    24 / SemiBold
Heading 3    20 / SemiBold
Body Large   16 / Medium
Body         14 / Regular
Caption      12 / Regular
Tiny         11 / Medium
```

## Number Style

Nominal uang harus besar, jelas, dan tidak terlalu dekoratif.

Contoh:

```txt
Rp 1.250.000
```

Rules:

* jangan pakai font terlalu playful untuk angka
* nominal utama harus mudah dibaca dalam 1 detik
* hindari terlalu banyak angka di satu layar

---

# 9. Shape & Radius

Sakuin harus punya bentuk lembut.

```txt
Small Radius    10
Medium Radius   16
Large Radius    24
XL Radius       32
Pill Radius     999
```

Rules:

* card utama pakai radius 24
* button pakai radius 18–24
* bottom sheet pakai top radius 28
* icon container pakai radius 16

---

# 10. Spacing System

```txt
4
8
12
16
20
24
32
40
48
```

Screen padding:

```txt
Horizontal: 20
Top: 16–24
Bottom: 24
```

Card padding:

```txt
Small Card: 16
Large Card: 20–24
```

---

# 11. Illustration Direction

Ilustrasi adalah bagian penting dari Sakuin.

Jangan hanya pakai copywriting. Tiap screen besar harus punya elemen visual kecil agar app terasa hidup.

## Style

* flat illustration
* soft 3D optional
* rounded shapes
* pastel shading
* sedikit grain/noise boleh
* karakter ekspresif
* tidak terlalu detail

## Illustration Keywords

Cari/generate dengan style:

```txt
cute wallet mascot
pastel finance illustration
friendly money tracker
soft 3d wallet character
cute piggy bank savings
receipt scanner illustration
money diary illustration
rounded pastel mobile app illustration
```

---

# 12. Mascot System

## Mascot Name

```txt
Momo
```

## Form

Momo adalah maskot dompet kecil.

Visual:

* bentuk dompet rounded
* warna coral/tosca
* punya mata kecil
* ekspresi sederhana
* bisa memegang koin
* bisa membawa struk
* bisa tidur saat empty state

## Personality

Momo harus terasa:

* ramah
* santai
* tidak menghakimi
* sedikit lucu
* tidak kekanak-kanakan berlebihan

## Mascot States

### Happy

Dipakai saat:

* transaksi berhasil
* tabungan bertambah
* target tercapai

### Thinking

Dipakai saat:

* insight bulanan
* OCR membaca struk
* loading data

### Calm

Dipakai saat:

* dashboard normal
* empty state

### Concerned

Dipakai saat:

* pengeluaran tinggi
* budget hampir habis

Jangan buat mascot marah. Finance app tidak boleh membuat user merasa disalahkan.

---

# 13. Icon Direction

Jangan pakai icon outline hitam semua.

Gunakan:

* duotone SVG
* filled rounded icon
* soft color background
* kategori icon yang ekspresif

## Icon Container

```txt
Size: 44x44
Radius: 16
Background: soft pastel
Icon size: 22–24
```

## Category Icon Keywords

### Income

```txt
salary wallet
money bag
cash income
bonus coin
freelance laptop money
```

### Expense

```txt
food bowl
shopping bag
bus ticket
electric bill
movie ticket
health medicine
coffee cup
```

### Savings

```txt
piggy bank
coin jar
target savings
safe box
money plant
```

### OCR

```txt
receipt scan
document scanner
camera receipt
ocr document
```

---

# 14. Motion Design

Motion harus terasa ringan, bukan lebay.

## Timing

```txt
Fast        150ms
Normal      250ms
Soft        400ms
Celebration 700ms
```

## Curve

Flutter recommended:

```txt
Curves.easeOutCubic
Curves.easeInOut
Curves.elasticOut
```

Gunakan elastic hanya untuk mascot atau success, bukan semua elemen.

---

# 15. Animation Rules

## Page Transition

* slide up untuk form
* fade + scale untuk modal
* horizontal slide untuk onboarding

## Card Entrance

* fade in
* slide up 12px
* duration 250–350ms

## Button Tap

* scale to 0.96
* kembali ke 1.0

## Balance Update

* animated counter
* color pulse halus

## Savings Progress

* progress bar fill
* mascot bounce kecil

## OCR Scanner

* scan line bergerak dari atas ke bawah
* glow tosca tipis
* loading text pendek

## Success Save

* check icon pop
* mascot happy
* toast kecil

---

# 16. Screen Design

---

# 16.1 Onboarding Screen

## Goal

Mengenalkan app dengan visual ringan.

## Layout

* top illustration
* headline besar
* body text pendek
* dot indicator
* CTA bottom

## Slide 1

Illustration:

Momo memegang dompet dan koin.

Headline:

```txt
Catat uang tanpa ribet
```

Body:

```txt
Masuk, keluar, dan tabungan bisa dicatat dalam beberapa detik.
```

Background:

```txt
#FFFDF8
```

Accent blob:

```txt
#EAFFD0
```

## Slide 2

Illustration:

Momo melihat receipt panjang.

Headline:

```txt
Scan struk, tinggal review
```

Body:

```txt
Foto struk belanja, Sakuin bantu baca nominalnya.
```

Accent:

```txt
#95E1D3
```

## Slide 3

Illustration:

Momo duduk di atas celengan.

Headline:

```txt
Nabung jadi kelihatan
```

Body:

```txt
Pantau progress target kecil sampai besar.
```

Accent:

```txt
#FCE38A
```

---

# 16.2 Home Dashboard

## Goal

User langsung tahu kondisi uangnya.

## Layout

```txt
Greeting
Balance Card
Quick Actions
Savings Preview
Today Summary
Recent Transactions
```

## Illustration

Momo kecil di pojok Balance Card.

State:

* happy jika saldo aman
* calm jika netral
* concerned jika expense tinggi

## Balance Card

Gradient:

```txt
#F38181 → #FCE38A
```

Content:

```txt
Sisa bulan ini
Rp 1.250.000
```

Small text:

```txt
Masih aman untuk hari ini
```

## Quick Actions

3 button:

```txt
Keluar
Masuk
Scan
```

Icon:

* Keluar: shopping bag / receipt
* Masuk: money bag
* Scan: receipt scanner

## UX Rule

Home jangan dipenuhi grafik. Fokus ke 3 hal:

* saldo
* catat cepat
* ringkasan

---

# 16.3 Add Transaction Screen

## Goal

Input transaksi selesai kurang dari 10 detik.

## Layout

```txt
Amount Input
Transaction Type Toggle
Category Grid
Wallet Picker
Note
Date
Save Button
```

## Visual

Amount input harus jadi hero utama.

```txt
Rp 0
```

besar, centered, clean.

## Category Grid

2–4 kolom.

Setiap item:

* icon container
* label pendek
* selected state dengan border coral/tosca

## Animation

* selected category scale 1.05
* save success check pop
* keyboard smooth transition

## Illustration

Mini Momo di bagian atas atau empty area.

State:

Momo membawa pensil kecil.

---

# 16.4 OCR Scanner Screen

## Goal

OCR terasa seperti fitur magic, tapi tetap user-controlled.

## Layout

```txt
Camera Preview
Scan Frame
Instruction Text
Bottom Action
```

## Visual

Scan frame:

* rounded rectangle
* border tosca
* animated scan line
* corner marker

## Copy

```txt
Arahkan struk ke dalam kotak
```

```txt
Pastikan nominal terlihat jelas
```

## Illustration

Saat belum buka kamera:

Momo memegang struk dan kaca pembesar.

Saat loading:

Momo thinking + scan line.

## OCR Result Bottom Sheet

Content:

```txt
Nominal terdeteksi
Rp 42.000

Tanggal
Merchant
Kategori
```

CTA:

```txt
Simpan Transaksi
```

Secondary:

```txt
Edit dulu
```

---

# 16.5 Transaction History Screen

## Goal

User bisa melihat uangnya pergi kemana.

## Layout

```txt
Search Bar
Filter Chips
Transaction List
```

## Filter Chips

```txt
Hari ini
Minggu ini
Bulan ini
Masuk
Keluar
Tabungan
```

## Transaction Item

Structure:

```txt
[Icon] Makan
       Bakso depan pabrik
       Hari ini, 12:30

       -Rp 18.000
```

Expense amount pakai coral.

Income pakai green.

Savings pakai tosca.

## Empty State

Illustration:

Momo tidur di atas dompet kosong.

Text:

```txt
Belum ada transaksi
```

Subtext:

```txt
Mulai catat satu transaksi kecil dulu.
```

---

# 16.6 Savings Goal Screen

## Goal

Tabungan terasa visual dan memotivasi tanpa toxic productivity.

## Layout

```txt
Header
Goal Cards
Add Goal Button
Completed Goals
```

## Goal Card

Content:

```txt
Beli Monitor
Rp 750.000 / Rp 2.500.000
30%
```

Visual:

* progress bar rounded
* mascot/illustration kecil
* coin stack
* target date optional

## Color

Savings card:

```txt
#95E1D3 → #EAFFD0
```

## Animation

* progress bar fill saat update
* coin bounce saat tambah tabungan
* confetti kecil saat target selesai

## Illustration

Momo membawa koin ke celengan.

---

# 16.7 Monthly Insight Screen

## Goal

Memberi insight sederhana, bukan laporan akuntansi.

## Layout

```txt
Month Selector
Summary Cards
Category Chart
Insight Card
```

## Summary Cards

```txt
Masuk
Keluar
Nabung
```

## Chart

Gunakan:

* donut chart untuk kategori expense
* bar chart sederhana untuk mingguan

Jangan tampilkan terlalu banyak warna.

## Insight Card

Background:

```txt
#FCE38A
```

Text:

```txt
Pengeluaran terbesar bulan ini ada di kategori Makan.
```

Mascot:

Momo thinking.

## Rule

Insight harus netral.

Jangan:

```txt
Kamu boros.
```

Gunakan:

```txt
Bulan ini kategori Makan paling sering muncul.
```

---

# 16.8 Settings Screen

## Goal

Sederhana dan tidak membingungkan.

## Sections

```txt
Profile
Wallet
Category
Theme
Security
Export Data
About App
```

## Illustration

Momo kecil membawa gear.

## Visual

Gunakan grouped list card.

---

# 17. Component System

## Primary Button

```txt
Height: 54
Radius: 18
Background: #F38181
Text: white
Font: 16 SemiBold
```

## Secondary Button

```txt
Height: 54
Radius: 18
Background: #EAFFD0
Text: #1F2937
```

## Icon Button

```txt
Size: 48
Radius: 16
Background: #F8FAFC
Icon: 22
```

## Card

```txt
Radius: 24
Padding: 20
Background: #FFFFFF
Shadow: soft
Border: optional #E5E7EB
```

## Bottom Sheet

```txt
Top Radius: 28
Padding: 24
Background: #FFFFFF
```

## Input Field

```txt
Height: 54
Radius: 16
Background: #F8FAFC
Border: transparent
Focused Border: #95E1D3
```

---

# 18. Data Visualization

Charts harus ringan.

## Donut Chart

Use for:

* category spending

## Bar Chart

Use for:

* weekly expense trend

## Progress Bar

Use for:

* savings goal

## Avoid

* line chart terlalu kompleks
* tabel panjang
* chart dengan banyak warna
* angka terlalu banyak

---

# 19. Flutter Package Recommendation

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_riverpod:
  go_router:
  drift:
  sqlite3_flutter_libs:
  path_provider:
  intl:
  fl_chart:
  google_mlkit_text_recognition:
  image_picker:
  flutter_animate:
  lottie:
```

Optional:

```yaml
  rive:
  local_auth:
```

---

# 20. Asset Direction

## Folder Structure

```txt
assets/
  illustrations/
    onboarding_wallet.svg
    onboarding_receipt.svg
    onboarding_savings.svg
    empty_transaction.svg
    savings_goal.svg
    ocr_scan.svg

  mascot/
    momo_happy.svg
    momo_calm.svg
    momo_thinking.svg
    momo_concerned.svg
    momo_success.svg

  icons/
    category/
      food.svg
      transport.svg
      shopping.svg
      salary.svg
      saving.svg
      bill.svg
      health.svg
```

---

# 21. Visual Consistency Rules

* Semua ilustrasi harus punya rounded shape.
* Semua icon kategori harus duotone.
* Jangan campur terlalu banyak style.
* Jangan pakai foto.
* Jangan pakai icon outline hitam polos.
* Jangan gunakan gradient di semua card.
* Maksimal 1 elemen dekoratif besar per screen.
* Mascot tidak boleh mengganggu fungsi utama.
* Button utama harus selalu mudah ditemukan.

---

# 22. Accessibility

Minimum contrast harus tetap aman.

Rules:

* teks utama jangan pakai coral di atas kuning
* nominal utama pakai text dark
* button coral harus text putih
* background pastel harus dikombinasikan dengan text gelap
* ukuran font body minimal 14
* clickable area minimal 44x44

---

# 23. Dark Mode Direction

Dark mode bukan prioritas MVP.

Jika dibuat:

```txt
Background      #111827
Surface         #1F2937
Text Primary    #F9FAFB
Text Secondary  #CBD5E1
Primary         #F38181
Secondary       #95E1D3
```

Pastel tetap dipakai sebagai accent, bukan background besar.

---

# 24. Final Direction

Sakuin harus terlihat seperti:

> aplikasi keuangan personal yang ramah, visual, dan enak dipakai setiap hari.

Bukan:

> dashboard admin keuangan mini.

Prioritas desain:

1. cepat input transaksi
2. dashboard mudah dipahami
3. tabungan terasa visual
4. OCR terasa membantu
5. mascot membuat app hidup
6. warna soft tapi tetap readable
