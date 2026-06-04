# Phase 1: Foundation Implementation

## 1. Branching
Sebelum memulai implementasi, silakan buat branch baru terlebih dahulu:
```bash
git checkout -b feature/phase-1-foundation
```

## 2. Setup Configuration
Berikut adalah instruksi low-level untuk setup aplikasi:

### App Name & Package Name
- **App Name:** Sakuin
- **Package Name:** `com.sakuin.app` (rekomendasi)

### Platform Requirements
- **Android Min SDK:** API 30 (Android 11). Silakan update di `android/app/build.gradle` pada bagian `minSdkVersion`.
- **iOS Deployment Target:** Rekomendasi iOS 14.0 (agar mendukung fitur UI modern dan mayoritas package Flutter terkini). Silakan update di `ios/Podfile` (hapus komentar dan ubah menjadi `platform :ios, '14.0'`).

### Flutter Setup
Status: Project Flutter sudah dibuat (`[x] Create Flutter project`). Lanjutkan dengan:

1. **Configure lint & analysis options:** 
   - Update `analysis_options.yaml` dengan rule standar yang lebih ketat atau tambahkan package `flutter_lints` jika belum ada.
2. **Configure folder structure:**
   - Buat struktur folder Feature-first sesuai panduan di `system-architecture.md`:
     - `lib/core/` (constants, theme, router, utils, errors, services)
     - `lib/shared/` (widgets, animations)
     - `lib/database/` (tables)
     - `lib/features/` (onboarding, home, transaction, dll.)
3. **Setup Dependencies:**
   - Tambahkan package berikut ke `pubspec.yaml`:
     - **State Management:** `flutter_riverpod`, `riverpod_annotation`
     - **Routing:** `go_router`
     - **Database (Drift):** `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`
     - **Dev Dependencies:** `build_runner`, `drift_dev`, `riverpod_generator`
4. **Setup build_runner:** 
   - Lakukan setup awal dan verifikasi bisa berjalan dengan perintah:
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```

## 3. Core Theme Implementation
Implementasikan design system di folder `lib/core/constants/` dan `lib/core/theme/` mengacu pada `design.md`:

1. **Color system (`app_colors.dart`):**
   - **Primary:** Coral `#F38181`
   - **Secondary:** Tosca `#95E1D3`
   - **Soft Accent:** Soft Yellow `#FCE38A`
   - **Soft Background:** Soft Mint `#EAFFD0`
   - **Neutral:** Background (`#FFFDF8`), Text Primary (`#1F2937`), dll.
   - **Semantic:** Income (`#36C690`), Expense (`#F38181`), Saving (`#95E1D3`).
2. **Typography (`text_theme.dart`):**
   - Setup font `Plus Jakarta Sans` dari Google Fonts / asset lokal.
   - Implementasi Type Scale dari Display (32/Bold) sampai Tiny (11/Medium).
3. **Radius & Spacing (`app_radius.dart`, `app_spacing.dart`):**
   - **Radius:** Small (10), Medium (16), Large (24), XL (32), Pill (999).
   - **Spacing:** 4, 8, 12, 16, 20, 24, 32, 40, 48.
4. **Shadow system:**
   - Buat konstanta bayangan (soft shadow) yang sejalan dengan style Playful & Clean.
5. **Theme Configuration (`app_theme.dart`):**
   - Buat `ThemeData.light()` dan satukan semua Colors, Typography, dan Radius ke dalam tema aplikasi.
   - Buat `ThemeData.dark()` sebagai placeholder (bisa gunakan standar material dark theme dulu).

## 4. Assets
Status: PNG icons assets sudah di-import (`[x]`).

1. **Preparation:**
   - Siapkan folder `assets/images/`, `assets/icons/`, `assets/mascots/` jika belum ada.
   - Pastikan path `assets/` didaftarkan dalam file `pubspec.yaml`.
2. **Backlog Tasks:** (Tidak perlu dilakukan sekarang, hanya persiapan path)
   - Import logo
   - Import launcher icon
   - Import mascot assets
   - Import illustration assets
