// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/core/utils/date_formatter.dart';
import 'package:safebaby/features/history/data/history_data.dart';
import 'package:safebaby/shared/widgets/record_checkup_sheet.dart';
import 'package:safebaby/shared/widgets/safebaby_bottom_nav.dart';
import 'package:safebaby/features/history/presentation/widgets/history_card.dart';
import 'package:safebaby/features/history/presentation/widgets/history_detail_sheet.dart';
import 'package:safebaby/features/history/presentation/widgets/history_empty_state.dart';
import 'package:safebaby/features/history/presentation/widgets/history_header.dart';
import 'package:safebaby/features/history/presentation/widgets/history_search_bar.dart';
import 'package:safebaby/features/profile/presentation/screens/profile_screen.dart';
import 'package:safebaby/features/schedule/presentation/screens/schedule_screen.dart';

class HistoryScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onNavigateToDashboard;
  final VoidCallback? onNavigateToSchedule;
  final VoidCallback? onNavigateToProfile;

  const HistoryScreen({
    super.key,
    this.isEmbedded = false,
    this.onNavigateToDashboard,
    this.onNavigateToSchedule,
    this.onNavigateToProfile,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentTabIndex = 2;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openRecordCheckupSheet({CheckupHistoryItem? initialItem}) async {
    final recorded = await RecordCheckupSheet.show(
      context,
      initialItem: initialItem,
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
                  initialItem != null
                      ? 'Catatan medis berhasil diperbarui!'
                      : 'Hasil pemeriksaan berhasil disimpan ke Riwayat!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
    } else if (index == 1) {
      if (widget.onNavigateToSchedule != null) {
        widget.onNavigateToSchedule!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScheduleScreen()),
        );
      }
    } else if (index == 3) {
      if (widget.onNavigateToProfile != null) {
        widget.onNavigateToProfile!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
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
    return ValueListenableBuilder<List<CheckupHistoryItem>>(
      valueListenable: HistoryData.instance.historyNotifier,
      builder: (context, allHistory, _) {
        final filteredHistory = allHistory.where((item) {
          if (_searchQuery.isEmpty) return true;
          final dateString =
              AppDateFormatter.formatSimpleDate(item.date).toLowerCase();
          final locationString = item.location.toLowerCase();
          final doctorString = (item.doctorOrMidwife ?? '').toLowerCase();

          return dateString.contains(_searchQuery) ||
              locationString.contains(_searchQuery) ||
              doctorString.contains(_searchQuery);
        }).toList();

        final Map<int, List<CheckupHistoryItem>> groupedByYear = {};
        for (final item in filteredHistory) {
          final year = item.date.year;
          groupedByYear.putIfAbsent(year, () => []).add(item);
        }

        final sortedYears = groupedByYear.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        final content = SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // 1. TOP BAR: JUDUL & SUB-JUDUL + TOMBOL TAMBAH
                HistoryHeader(
                  onAddPressed: () => _openRecordCheckupSheet(),
                ),

                const SizedBox(height: 20),

                // 2. SEARCH BAR (CARI TANGGAL ATAU LOKASI)
                HistorySearchBar(
                  controller: _searchController,
                  onClear: () => setState(() => _searchQuery = ''),
                ),

                const SizedBox(height: 24),

                // 3. DAFTAR RIWAYAT DIKELOMPOKKAN BERDASARKAN TAHUN
                if (filteredHistory.isEmpty)
                  HistoryEmptyState(
                    isSearching: _searchQuery.isNotEmpty,
                    onAddRecord: () => _openRecordCheckupSheet(),
                  )
                else ...[
                  ...sortedYears.map((year) {
                    final itemsInYear = groupedByYear[year]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label Tahun (Toska)
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, bottom: 12.0),
                          child: Text(
                            '$year',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        // Kartu-kartu riwayat dalam tahun tersebut
                        ...itemsInYear.map((item) {
                          return HistoryCard(
                            item: item,
                            onTap: () {
                              HistoryDetailSheet.show(
                                context,
                                item: item,
                                onEdit: (editItem) {
                                  _openRecordCheckupSheet(initialItem: editItem);
                                },
                              );
                            },
                          );
                        }),

                        const SizedBox(height: 12),
                      ],
                    );
                  }),

                  const SizedBox(height: 8),

                  // 4. FOOTER SUMMARY (JUMLAH PEMERIKSAAN)
                  _buildFooterSummary(filteredHistory.length),
                ],

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

  Widget _buildFooterSummary(int totalCount) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            '$totalCount pemeriksaan',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'tersimpan dengan aman',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
