// lib/screens/dashboard/widgets/active_reminder_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/core/utils/date_formatter.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';
import 'package:safebaby/features/schedule/presentation/screens/notification_screen.dart';

class ActiveReminderCard extends StatelessWidget {
  final ScheduleItem? schedule;
  final ValueChanged<int>? onNotificationOpened;
  final VoidCallback? onNavigateToSchedule;

  const ActiveReminderCard({
    super.key,
    required this.schedule,
    this.onNotificationOpened,
    this.onNavigateToSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final hasSchedule = schedule != null;
    final isReminderEnabled = ScheduleData.instance.isReminderEnabled;

    final String title;
    final String subtitle;
    final IconData iconData;
    final Color iconColor;
    final Color iconBg;

    if (!isReminderEnabled) {
      title = 'Pengingat dinonaktifkan';
      subtitle = 'Ketuk untuk mengaktifkan kembali di tab Jadwal.';
      iconData = Icons.notifications_off_outlined;
      iconColor = const Color(0xFF94A3B8);
      iconBg = const Color(0xFFF1F5F9);
    } else if (hasSchedule) {
      final now = DateTime.now();
      final scheduleDate = DateTime(
        schedule!.date.year,
        schedule!.date.month,
        schedule!.date.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final daysLeft = scheduleDate.difference(today).inDays;

      title = 'Pengingat H-3 aktif';
      if (daysLeft == 0) {
        subtitle = 'Jadwal pemeriksaan Anda hari ini pukul ${schedule!.time}.';
      } else if (daysLeft == 1) {
        subtitle = 'Pemeriksaan besok! Notifikasi pengingat sudah aktif.';
      } else if (daysLeft <= 3 && daysLeft > 1) {
        subtitle =
            'Pemeriksaan $daysLeft hari lagi. Pengingat telah dikirim ke notifikasi.';
      } else {
        final h3Date = schedule!.date.subtract(const Duration(days: 3));
        subtitle =
            'Kami akan mengingatkan Anda pada ${h3Date.day} ${AppDateFormatter.getMonthName(h3Date.month)}.';
      }
      iconData = Icons.notifications_outlined;
      iconColor = AppColors.accentTeal;
      iconBg = const Color(0xFFEAF8F6);
    } else {
      title = 'Pengingat belum aktif';
      subtitle =
          'Pengingat otomatis aktif setelah Anda membuat jadwal kontrol.';
      iconData = Icons.notifications_none_rounded;
      iconColor = const Color(0xFF94A3B8);
      iconBg = const Color(0xFFF1F5F9);
    }

    return GestureDetector(
      onTap: () async {
        if (!isReminderEnabled) {
          if (onNavigateToSchedule != null) onNavigateToSchedule!();
        } else if (hasSchedule) {
          final targetDay = await Navigator.push<int>(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationScreen(),
            ),
          );
          if (targetDay != null && onNotificationOpened != null) {
            onNotificationOpened!(targetDay);
          }
        } else {
          if (onNavigateToSchedule != null) onNavigateToSchedule!();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Kotak Lonceng
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Teks Pengingat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Chevron Arrow Kanan
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

