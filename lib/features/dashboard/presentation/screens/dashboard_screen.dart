// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';

import 'package:safebaby/features/schedule/data/schedule_data.dart';
import 'package:safebaby/shared/widgets/safebaby_bottom_nav.dart';
import 'package:safebaby/features/dashboard/presentation/widgets/active_reminder_card.dart';
import 'package:safebaby/features/dashboard/presentation/widgets/daily_tip_card.dart';
import 'package:safebaby/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:safebaby/features/dashboard/presentation/widgets/next_checkup_card.dart';
import 'package:safebaby/features/dashboard/presentation/widgets/recent_history_card.dart';
import 'package:safebaby/features/history/presentation/screens/history_screen.dart';
import 'package:safebaby/features/profile/presentation/screens/profile_screen.dart';
import 'package:safebaby/features/schedule/presentation/screens/schedule_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({
    super.key,
    this.userName = 'Siti',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;
  int? _scheduleSelectedDay;

  void _navigateToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  void _navigateToScheduleDay(int day) {
    setState(() {
      _scheduleSelectedDay = day;
      _currentTabIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          // Tab 0: Konten Dashboard Utama
          _buildDashboardContent(),

          // Tab 1: Halaman Jadwal Kontrol
          ScheduleScreen(
            isEmbedded: true,
            initialSelectedDate: _scheduleSelectedDay,
            onNavigateToDashboard: () => _navigateToTab(0),
            onNavigateToHistory: () => _navigateToTab(2),
            onNavigateToProfile: () => _navigateToTab(3),
          ),

          // Tab 2: Riwayat Pemeriksaan
          HistoryScreen(
            isEmbedded: true,
            onNavigateToDashboard: () => _navigateToTab(0),
            onNavigateToSchedule: () => _navigateToTab(1),
            onNavigateToProfile: () => _navigateToTab(3),
          ),

          // Tab 3: Profil Pengguna
          ProfileScreen(
            isEmbedded: true,
            onNavigateToDashboard: () => _navigateToTab(0),
            onNavigateToSchedule: () => _navigateToTab(1),
            onNavigateToHistory: () => _navigateToTab(2),
          ),
        ],
      ),
      bottomNavigationBar: SafeBabyBottomNav(
        currentIndex: _currentTabIndex,
        onTap: _navigateToTab,
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // 1. TOP BAR: GREETING & NOTIFIKASI
            DashboardHeader(
              onNotificationOpened: _navigateToScheduleDay,
            ),

            const SizedBox(height: 24),

            // 2 & 3. SECTION KONTROL BERIKUTNYA & PENGINGAT (REAKTIF & DINAMIS)
            AnimatedBuilder(
              animation: Listenable.merge([
                ScheduleData.instance.schedulesNotifier,
                ScheduleData.instance.isReminderEnabledNotifier,
              ]),
              builder: (context, _) {
                final upcoming = ScheduleData.instance.upcomingSchedule;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NextCheckupCard(
                      schedule: upcoming,
                      onScheduleSelected: _navigateToScheduleDay,
                      onEmptyTapped: () => _navigateToTab(1),
                    ),
                    const SizedBox(height: 16),
                    ActiveReminderCard(
                      schedule: upcoming,
                      onNotificationOpened: _navigateToScheduleDay,
                      onNavigateToSchedule: () => _navigateToTab(1),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // 4. SECTION: RIWAYAT TERBARU
            RecentHistoryCard(
              onViewAll: () => _navigateToTab(2),
              onItemTapped: () => _navigateToTab(2),
            ),

            const SizedBox(height: 20),

            // 5. FEATURE CARD: TIP HARI INI
            const DailyTipCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
