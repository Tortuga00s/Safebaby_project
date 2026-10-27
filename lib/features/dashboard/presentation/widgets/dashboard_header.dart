// lib/screens/dashboard/widgets/dashboard_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/profile/data/profile_data.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';
import 'package:safebaby/features/schedule/presentation/screens/notification_screen.dart';

class DashboardHeader extends StatelessWidget {
  final ValueChanged<int>? onNotificationOpened;

  const DashboardHeader({
    super.key,
    this.onNotificationOpened,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting Personal Dinamis
        ValueListenableBuilder<UserProfile>(
          valueListenable: ProfileData.instance.profileNotifier,
          builder: (context, profile, _) {
            final name = profile.firstName.isNotEmpty ? profile.firstName : 'Siti';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat pagi,',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Halo, $name',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            );
          },
        ),

        // Tombol Notifikasi dengan Indikator Pengingat Aktif
        AnimatedBuilder(
          animation: Listenable.merge([
            ScheduleData.instance.schedulesNotifier,
            ScheduleData.instance.isReminderEnabledNotifier,
          ]),
          builder: (context, _) {
            final upcoming = ScheduleData.instance.upcomingSchedule;
            final isReminderEnabled = ScheduleData.instance.isReminderEnabled;

            bool hasActiveReminder = false;
            if (isReminderEnabled && upcoming != null) {
              final now = DateTime.now();
              final scheduleDate = DateTime(
                upcoming.date.year,
                upcoming.date.month,
                upcoming.date.day,
              );
              final today = DateTime(now.year, now.month, now.day);
              final daysLeft = scheduleDate.difference(today).inDays;
              hasActiveReminder = daysLeft >= 0 && daysLeft <= 3;
            }

            return GestureDetector(
              onTap: () async {
                final targetDay = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
                if (targetDay != null && onNotificationOpened != null) {
                  onNotificationOpened!(targetDay);
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                    ),
                  ),
                  if (hasActiveReminder)
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

