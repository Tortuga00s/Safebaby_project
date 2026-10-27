// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/profile/data/profile_data.dart';
import 'package:safebaby/shared/widgets/safebaby_bottom_nav.dart';
import 'package:safebaby/features/history/presentation/screens/history_screen.dart';
import 'package:safebaby/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:safebaby/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:safebaby/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:safebaby/features/profile/presentation/widgets/profile_hero_card.dart';
import 'package:safebaby/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:safebaby/features/schedule/presentation/screens/schedule_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onNavigateToDashboard;
  final VoidCallback? onNavigateToSchedule;
  final VoidCallback? onNavigateToHistory;

  const ProfileScreen({
    super.key,
    this.isEmbedded = false,
    this.onNavigateToDashboard,
    this.onNavigateToSchedule,
    this.onNavigateToHistory,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 3;

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar Akun?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari aplikasi SafeBaby? Anda dapat masuk kembali kapan saja.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Batal',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Keluar',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleStandaloneNav(int index) {
    if (index == 0) {
      if (widget.onNavigateToDashboard != null) {
        widget.onNavigateToDashboard!();
      } else {
        Navigator.pop(context);
      }
    } else if (index == 1) {
      if (widget.onNavigateToSchedule != null) {
        widget.onNavigateToSchedule!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScheduleScreen()),
        );
      }
    } else if (index == 2) {
      if (widget.onNavigateToHistory != null) {
        widget.onNavigateToHistory!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
      }
    } else {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile>(
      valueListenable: ProfileData.instance.profileNotifier,
      builder: (context, profile, _) {
        final content = SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // 1. TOP BAR: JUDUL PROFIL
                Text(
                  'Profil',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 24),

                // 2. HERO CARD IDENTITAS PENGGUNA
                ProfileHeroCard(profile: profile),

                const SizedBox(height: 20),

                // 3. CARD INFORMASI DETAIL PENGGUNA
                ProfileInfoCard(profile: profile),

                const SizedBox(height: 24),

                // 4 & 5. TOMBOL EDIT PROFIL & KELUAR
                ProfileActionButtons(
                  onEditPressed: () => EditProfileSheet.show(context, profile),
                  onLogoutPressed: _confirmLogout,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );

        if (widget.isEmbedded) {
          return content;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: content,
          bottomNavigationBar: SafeBabyBottomNav(
            currentIndex: _currentTabIndex,
            onTap: _handleStandaloneNav,
          ),
        );
      },
    );
  }
}
