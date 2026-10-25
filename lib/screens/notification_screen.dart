// lib/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/schedule_data.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        ScheduleData.instance.schedulesNotifier,
        ScheduleData.instance.isReminderEnabledNotifier,
      ]),
      builder: (context, _) {
        final upcoming = ScheduleData.instance.upcomingSchedule;
        final isReminderEnabled = ScheduleData.instance.isReminderEnabled;

        // Cek apakah ada jadwal kontrol yang masuk rentang pengingat (H-3 s/d Hari H)
        final bool hasActiveReminder;
        final int daysLeft;

        if (isReminderEnabled && upcoming != null) {
          final now = DateTime.now();
          final scheduleDate = DateTime(
            upcoming.date.year,
            upcoming.date.month,
            upcoming.date.day,
          );
          final today = DateTime(now.year, now.month, now.day);
          daysLeft = scheduleDate.difference(today).inDays;

          // Aktif jika jadwal adalah hari ini (H-0), besok (H-1), lusa (H-2), atau H-3
          hasActiveReminder = daysLeft >= 0 && daysLeft <= 3;
        } else {
          hasActiveReminder = false;
          daysLeft = -1;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── 1. TOP BAR / HEADER ───
                _buildHeader(context, hasActiveReminder, isReminderEnabled),

                // ─── 2. KONTEN NOTIFIKASI (DINAMIS) ───
                Expanded(
                  child: hasActiveReminder && upcoming != null
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildReminderCard(
                                context,
                                upcoming,
                                daysLeft,
                              ),
                            ],
                          ),
                        )
                      : _buildEmptyState(isReminderEnabled),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 1. WIDGET HEADER ───
  Widget _buildHeader(
    BuildContext context,
    bool hasUnread,
    bool isReminderEnabled,
  ) {
    String subtitleText;
    if (!isReminderEnabled) {
      subtitleText = 'Pengingat otomatis dinonaktifkan';
    } else if (hasUnread) {
      subtitleText = '1 notifikasi pengingat baru';
    } else {
      subtitleText = 'Tidak ada notifikasi baru';
    }

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
          // Tombol Kembali (<)
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
          Expanded(
            child: Column(
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
                  subtitleText,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: hasUnread
                        ? AppColors.accentTeal
                        : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. KARTU NOTIFIKASI PENGINGAT (MUNCUL OTOMATIS SAAT <= H-3 / BESOK) ───
  Widget _buildReminderCard(
    BuildContext context,
    ScheduleItem schedule,
    int daysLeft,
  ) {
    final String timeTitle;
    final String timeBody;

    if (daysLeft == 0) {
      timeTitle = 'Jadwal Kontrol Hari Ini';
      timeBody =
          'Halo Ibu, hari ini Anda memiliki jadwal pemeriksaan kehamilan di ${schedule.location} pukul ${schedule.time}. Pastikan hadir tepat waktu ya.';
    } else if (daysLeft == 1) {
      timeTitle = 'Pemeriksaan Besok';
      timeBody =
          'Halo Ibu, jangan lupa besok Anda memiliki jadwal kontrol kehamilan di ${schedule.location} pukul ${schedule.time}. Siapkan buku KIA Anda.';
    } else {
      timeTitle = 'Kontrol $daysLeft Hari Lagi';
      timeBody =
          'Halo Ibu, jadwal kontrol kehamilan Anda tinggal $daysLeft hari lagi (${schedule.date.day} ${_getMonthName(schedule.date.month)}) di ${schedule.location} pukul ${schedule.time}.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentTeal.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: Ikon Lonceng + Titik Hijau Unread + Judul
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.accentTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            timeTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accentTeal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pengingat Otomatis',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Isi Pesan Notifikasi
          Text(
            timeBody,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          // Tombol "Lihat Jadwal" yang Langsung Mengarahkan ke Kalender Tanggal Tersebut
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                // Menutup notifikasi dan mengembalikan tanggal jadwal agar disorot di kalender
                Navigator.pop(context, schedule.date.day);
              },
              icon: const Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                'Lihat Jadwal di Kalender',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3. WIDGET EMPTY STATE ───
  Widget _buildEmptyState(bool isReminderEnabled) {
    final String title;
    final String message;
    final IconData iconData;
    final Color iconColor;
    final Color iconBg;

    if (!isReminderEnabled) {
      title = 'Pengingat Dinonaktifkan';
      message =
          'Anda telah menonaktifkan pengingat pemeriksaan otomatis. Anda dapat mengaktifkannya kembali kapan saja melalui menu Jadwal.';
      iconData = Icons.notifications_off_outlined;
      iconColor = const Color(0xFF94A3B8);
      iconBg = const Color(0xFFF1F5F9);
    } else {
      title = 'Belum Ada Notifikasi';
      message =
          'Pengingat jadwal pemeriksaan kehamilan Anda akan otomatis muncul di sini saat jadwal mendekati H-3 atau jika dibuat untuk hari berikutnya.';
      iconData = Icons.notifications_none_rounded;
      iconColor = AppColors.accentTeal;
      iconBg = const Color(0xFFEAF8F6);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Nama Bulan
  static String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
