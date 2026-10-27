// lib/screens/schedule/widgets/schedule_reminder_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';

class ScheduleReminderCard extends StatelessWidget {
  const ScheduleReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ScheduleData.instance.isReminderEnabledNotifier,
      builder: (context, isEnabled, _) {
        final String title;
        final String subtitle;
        final Color iconBg;
        final Color iconColor;
        final IconData iconData;

        if (isEnabled) {
          title = 'Pengingat H-3 aktif';
          iconBg = const Color(0xFFEAF8F6);
          iconColor = AppColors.accentTeal;
          iconData = Icons.notifications_none_outlined;

          final upcoming = ScheduleData.instance.upcomingSchedule;
          if (upcoming != null) {
            final now = DateTime.now();
            final sched = DateTime(
              upcoming.date.year,
              upcoming.date.month,
              upcoming.date.day,
            );
            final today = DateTime(now.year, now.month, now.day);
            final diff = sched.difference(today).inDays;
            if (diff <= 3 && diff >= 0) {
              subtitle = 'Notifikasi pengingat sudah aktif di menu notifikasi';
            } else {
              subtitle = 'Notifikasi akan dikirim otomatis';
            }
          } else {
            subtitle = 'Notifikasi akan dikirim otomatis';
          }
        } else {
          title = 'Pengingat nonaktif';
          subtitle = 'Notifikasi otomatis dinonaktifkan';
          iconBg = const Color(0xFFF1F5F9);
          iconColor = const Color(0xFF94A3B8);
          iconData = Icons.notifications_off_outlined;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080F172A),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Ikon Lonceng
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
                        color: isEnabled
                            ? AppColors.primaryDark
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
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

              // Saklar (Switch) ON / OFF
              Switch(
                value: isEnabled,
                activeThumbColor: AppColors.accentTeal,
                activeTrackColor: const Color(0xFFC8F0EB),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCBD5E1),
                onChanged: (bool newValue) {
                  if (!newValue) {
                    _showDisableReminderConfirmation(context);
                  } else {
                    ScheduleData.instance.setReminderEnabled(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pengingat otomatis berhasil diaktifkan kembali.',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        backgroundColor: AppColors.primaryDark,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDisableReminderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notification_important_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Nonaktifkan Pengingat?',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Jika dinonaktifkan, Anda tidak akan mendapatkan pengingat otomatis sebelum jadwal pemeriksaan kehamilan tiba.\n\nKami sangat menyarankan tetap menyalakannya demi memantau kesehatan Ibu dan janin secara teratur.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal (Tetap Aktif)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScheduleData.instance.setReminderEnabled(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Pengingat kontrol otomatis telah dinonaktifkan.',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: const Color(0xFFEF4444),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Ya, Nonaktifkan',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

