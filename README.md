<div align="center">

  <img src="assets/images/safebaby_logo_teal.png" alt="SafeBaby Logo" width="220" />

  # SafeBaby 👶✨
  **Aplikasi Mobile Pendamping Kehamilan yang Aman & Terpercaya**

  [![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](https://flutter.dev)
  [![Status](https://img.shields.io/badge/Status-In%20Development-success?style=for-the-badge)]()

  <p align="center">
    SafeBaby dirancang untuk membantu para calon orang tua, khususnya para ibu, dalam memantau masa kehamilan dengan lebih teratur, tenang, dan terstruktur melalui manajemen jadwal kontrol serta pencatatan riwayat kesehatan kehamilan.
  </p>

</div>

---

## 📌 Daftar Isi
- [Tentang SafeBaby](#-tentang-safebaby)
- [Fitur Utama](#-fitur-utama)
- [Desain & Branding](#-desain--branding)
- [Tech Stack & Dependensi](#-tech-stack--dependensi)
- [Struktur Proyek](#-struktur-proyek)
- [Panduan Instalasi & Menjalankan](#-panduan-instalasi--menjalankan)
- [Perintah Pengembangan](#-perintah-pengembangan)
- [Tim Pengembang](#-tim-pengembang)

---

## 📖 Tentang SafeBaby

**SafeBaby** adalah aplikasi mobile berbasis Flutter yang hadir sebagai asisten digital dalam perjalanan masa kehamilan. Masa kehamilan merupakan momen berharga yang membutuhkan perhatian khusus, baik dalam kepatuhan jadwal pemeriksaan medis rutin, konsultasi USG, hingga pemantauan perkembangan janin. 

Aplikasi ini mengintegrasikan antarmuka modern yang tenang, responsif, dan mudah digunakan agar para ibu dapat mengelola seluruh kebutuhan pemeriksaan kehamilan dalam satu genggaman tanpa khawatir melewatkan jadwal penting.

---

## 🚀 Fitur Utama

- **🗓️ Manajemen Jadwal Kontrol Kehamilan**  
  Mencatat dan menjadwalkan kunjungan dokter atau bidan secara teratur dan rapi.
- **🔔 Pengingat Cerdas & Tepat Waktu**  
  Notifikasi pengingat otomatis (misal: 3 hari sebelum jadwal kontrol) agar pemeriksaan tidak terlewat.
- **📋 Riwayat Pemeriksaan Terstruktur**  
  Menyimpan dan meninjau kembali rekam riwayat pemeriksaan, catatan medis, serta hasil konsultasi sebelumnya.
- **✨ Animasi & Transisi Halus (Smooth Motion)**  
  Dilengkapi dengan *Animated Splash Screen* bertingkat (Fade, Scale, Slide) dan *Interactive Onboarding Slider* responsif.

---

## 🎨 Desain & Branding

SafeBaby mengusung tema visual yang menenangkan (*calm*), modern, dan ramah pengguna:

| Elemen | Detail / Nilai | Deskripsi |
| :--- | :--- | :--- |
| **Primary Dark** | `#0B2341` (Deep Navy) | Memberikan kesan andal, stabil, dan elegan |
| **Accent Teal** | `#23B3A2` (Mint / Teal) | Memberikan kesan higienis, segar, dan ramah |
| **Tipografi** | `Plus Jakarta Sans` | Modern, clean, dan memiliki legibilitas tinggi |
| **App Icon** | Adaptive Launcher Icon | Logo emblem SafeBaby dengan latar belakang putih/navy terstandardisasi |

---

## 🛠️ Tech Stack & Dependensi

- **Core Framework**: [Flutter](https://flutter.dev/) (SDK `^3.13.3` / Flutter `3.47+`)
- **Bahasa Pemrograman**: [Dart](https://dart.dev/)
- **State Management & UI**:
  - `Material 3` & `Cupertino Icons`
  - [`google_fonts`](https://pub.dev/packages/google_fonts) (`^9.0.0`) untuk tipografi Plus Jakarta Sans
  - Custom Bezier `CustomPainter` untuk grafis dekoratif layar
- **Development Tools**:
  - [`flutter_lints`](https://pub.dev/packages/flutter_lints) (`^6.0.0`)
  - [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) (`^0.14.4`) untuk otomatisasi app icon Android & iOS

---

## 📂 Struktur Proyek

```text
Safebaby_project/
├── android/                   # Konfigurasi native Android
├── ios/                       # Konfigurasi native iOS
├── assets/
│   └── images/                # Asset logo, emblem, dan launcher icons
│       ├── app_icon_foreground_teal.png
│       ├── app_icon_navy.png
│       ├── safebaby_emblem_teal.png
│       ├── safebaby_logo_teal.png
│       └── ...
├── lib/
│   ├── core/                  # Utilitas inti dan konfigurasi global
│   │   └── app_theme.dart     # Definisi tema, palet warna, & gaya teks
│   ├── screens/               # Halaman antarmuka aplikasi
│   │   ├── splash_screen.dart # Layar splash animasi pembuka
│   │   └── onboarding_screen.dart # Layar pengenalan fitur aplikasi
│   └── main.dart              # Entry point utama aplikasi Flutter
├── test/                      # Unit & widget testing
├── pubspec.yaml               # Manajemen dependensi dan aset
└── README.md                  # Dokumentasi proyek
```

---

## 💻 Panduan Instalasi & Menjalankan

### Prasyarat Sistem
Pastikan perangkat Anda telah terpasang:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stable terbaru)
- Android Studio / VS Code dengan ekstensi Flutter & Dart
- Emulator Android / iOS Simulator atau perangkat fisik yang terhubung

### Langkah-langkah Menjalankan

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/Tortuga00s/Safebaby_project.git
   cd Safebaby_project
   ```

2. **Pasang seluruh dependensi proyek:**
   ```bash
   flutter pub get
   ```

3. **Verifikasi perangkat target:**
   ```bash
   flutter devices
   ```

4. **Jalankan aplikasi dalam mode debug:**
   ```bash
   flutter run
   ```

5. **(Opsional) Build berkas APK untuk Android:**
   ```bash
   flutter build apk --release
   ```

---

## ⚡ Perintah Pengembangan

- **Menjalankan Linter / Analisis Kode:**
  ```bash
  flutter analyze
  ```

- **Menjalankan Pengujian (Testing):**
  ```bash
  flutter test
  ```

- **Memperbarui / Generate Launcher Icon:**
  ```bash
  dart run flutter_launcher_icons
  ```

---

## 👥 Tim Pengembang

Proyek ini dikembangkan dan dirancang oleh tim **SafeBaby**:

| Nama | Peran |
| :--- | :--- |
| **Ade Saffa Akbar** | Project Manager |
| **Farizzi Rafli Hakim** | UI/UX Designer |
| **Muhammad Geraldi Arisyi** | Frontend Developer |
| **Rafi Maulana Saputra** | Backend Developer |

---

<div align="center">
  <sub>Dibuat dengan ❤️ oleh Kelompok SafeBaby</sub>
</div>
