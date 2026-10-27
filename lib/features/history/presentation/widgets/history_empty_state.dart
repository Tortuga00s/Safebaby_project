// lib/screens/history/widgets/history_empty_state.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';

class HistoryEmptyState extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onAddRecord;

  const HistoryEmptyState({
    super.key,
    required this.isSearching,
    required this.onAddRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                isSearching ? Icons.search_off_rounded : Icons.assignment_outlined,
                color: const Color(0xFF94A3B8),
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'Riwayat Tidak Ditemukan'
                  : 'Belum Ada Riwayat Pemeriksaan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isSearching
                  ? 'Tidak ada catatan pemeriksaan yang cocok dengan kata kunci pencarian Anda.'
                  : 'Setelah melakukan kontrol kehamilan, Anda dapat mencatat hasil pemeriksaan di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            if (!isSearching) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAddRecord,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(
                  'Catat Pemeriksaan',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

