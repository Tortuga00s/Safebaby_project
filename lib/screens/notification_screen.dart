// lib/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Status apakah notifikasi sudah dibaca atau belum
  bool _isNotificationRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 1. TOP BAR / HEADER (DENGAN BACKGROUND PUTIH ELEGAN) ───
            _buildHeader(context),

            // ─── 2. KONTEN NOTIFIKASI ───
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori Header Waktu: "HARI INI"
                    Text(
                      'HARI INI',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.accentTeal,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Kartu Notifikasi: "Pengingat Kontrol"
                    _buildNotificationCard(),

                    const SizedBox(height: 28),

                    // Footer Informasi Status Baca
                    _buildFooterInfo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 1. WIDGET HEADER ───
  Widget _buildHeader(BuildContext context) {
    final unreadCount = _isNotificationRead ? 0 : 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tombol Kembali (<) dengan Rounded Grey Container
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.primaryDark,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Teks Judul dan Sub-judul
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifikasi',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unreadCount > 0
                    ? '$unreadCount notifikasi belum dibaca'
                    : 'Semua notifikasi telah dibaca',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 2. WIDGET KARTU NOTIFIKASI ───
  Widget _buildNotificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Icon Lonceng + Titik Unread + Judul + Timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak Ikon Lonceng Mint dengan Unread Indicator Dot
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primaryDark,
                      size: 24,
                    ),
                  ),
                  if (!_isNotificationRead)
                    Positioned(
                      top: 10,
                      right: 11,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.accentTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Judul & Deskripsi Pengingat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengingat Kontrol',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jadwal kontrol Anda 3 hari lagi.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Waktu Jam (09.41)
              Text(
                '09.41',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Baris Tengah: Info Tanggal & Waktu Kontrol
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primaryDark,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '20 Oktober 2026 • 09.00 WIB',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Baris Bawah: Tombol Aksi "Lihat Jadwal"
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isNotificationRead = true;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Membuka jadwal kontrol 20 Oktober 2026...',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                    backgroundColor: AppColors.primaryDark,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEAF8F6),
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Lihat Jadwal',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3. WIDGET FOOTER INFO ───
  Widget _buildFooterInfo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_rounded,
            color: Color(0xFF94A3B8),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'Semua pengingat lainnya sudah dibaca',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

