// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';
import 'package:safebaby/shared/widgets/record_checkup_sheet.dart';
import 'package:safebaby/shared/widgets/safebaby_bottom_nav.dart';
import 'package:safebaby/features/schedule/presentation/screens/add_schedule_screen.dart';
import 'package:safebaby/features/history/presentation/screens/history_screen.dart';
import 'package:safebaby/features/profile/presentation/screens/profile_screen.dart';
import 'package:safebaby/features/schedule/presentation/widgets/calendar_grid.dart';
import 'package:safebaby/features/schedule/presentation/widgets/calendar_header.dart';
import 'package:safebaby/features/schedule/presentation/widgets/schedule_guide_card.dart';
import 'package:safebaby/features/schedule/presentation/widgets/schedule_header.dart';
import 'package:safebaby/features/schedule/presentation/widgets/schedule_reminder_card.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? onNavigateToDashboard;
  final VoidCallback? onNavigateToHistory;
  final VoidCallback? onNavigateToProfile;
  final bool isEmbedded;
  final int? initialSelectedDate;

  const ScheduleScreen({
    super.key,
    this.onNavigateToDashboard,
    this.onNavigateToHistory,
    this.onNavigateToProfile,
    this.isEmbedded = false,
    this.initialSelectedDate,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int? _selectedDate;
  int _currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
  }

  @override
  void didUpdateWidget(covariant ScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedDate != null &&
        widget.initialSelectedDate != oldWidget.initialSelectedDate) {
      _selectedDate = widget.initialSelectedDate;
    }
  }

  Future<void> _navigateToAddSchedule() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddScheduleScreen(
          initialDay: _selectedDate ?? 21,
          initialMonth: 10,
          initialYear: 2026,
        ),
      ),
    );
    if (result != null && result is ScheduleItem && mounted) {
      setState(() {
        _selectedDate = result.date.day;
      });
    }
  }

  Future<void> _navigateToEditSchedule(ScheduleItem schedule) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddScheduleScreen(
          existingSchedule: schedule,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        if (result is ScheduleItem) {
          _selectedDate = result.date.day;
        }
      });
    }
  }

  void _confirmDeleteSchedule(BuildContext context, ScheduleItem schedule) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Hapus Jadwal?',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal kontrol pada tanggal ${schedule.date.day} Oktober 2026? Titik di kalender akan dibersihkan.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScheduleData.instance.deleteSchedule(schedule.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Jadwal kontrol ${schedule.date.day} Oktober 2026 berhasil dihapus.',
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
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Hapus',
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

  Future<void> _openRecordCheckupResult(ScheduleItem schedule) async {
    final recorded = await RecordCheckupSheet.show(
      context,
      fromSchedule: schedule,
    );

    if (recorded == true && mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accentTeal,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pemeriksaan selesai! Data telah tersimpan di Riwayat.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Lihat Riwayat',
            textColor: AppColors.accentTeal,
            onPressed: () {
              if (widget.onNavigateToHistory != null) {
                widget.onNavigateToHistory!();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  void _handleStandaloneNav(int index) {
    if (index == 0) {
      if (widget.onNavigateToDashboard != null) {
        widget.onNavigateToDashboard!();
      } else {
        Navigator.pop(context);
      }
    } else if (index == 2) {
      if (widget.onNavigateToHistory != null) {
        widget.onNavigateToHistory!();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HistoryScreen(),
          ),
        );
      }
    } else if (index == 3) {
      if (widget.onNavigateToProfile != null) {
        widget.onNavigateToProfile!();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
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
    return ValueListenableBuilder<List<ScheduleItem>>(
      valueListenable: ScheduleData.instance.schedulesNotifier,
      builder: (context, schedules, _) {
        final content = SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // 1. TOP BAR: JUDUL & TOMBOL TAMBAH (+)
                ScheduleHeader(
                  onAddPressed: _navigateToAddSchedule,
                ),

                const SizedBox(height: 28),

                // 2. BULAN & PANDUAN GANTI BULAN
                const CalendarHeader(),

                const SizedBox(height: 20),

                // 3. KALENDER BULANAN INTERAKTIF (OKTOBER 2026)
                CalendarGrid(
                  selectedDate: _selectedDate,
                  onDateSelected: (day) {
                    setState(() {
                      _selectedDate = day;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // 4. CARD PANDUAN / DETAIL TANGGAL DIPILIH
                ScheduleGuideCard(
                  selectedDate: _selectedDate,
                  onAddPressed: _navigateToAddSchedule,
                  onEditPressed: _navigateToEditSchedule,
                  onDeletePressed: (sched) => _confirmDeleteSchedule(context, sched),
                  onRecordResultPressed: _openRecordCheckupResult,
                ),

                const SizedBox(height: 16),

                // 5. CARD STATUS PENGINGAT H-3 AKTIF
                const ScheduleReminderCard(),

                const SizedBox(height: 20),
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
