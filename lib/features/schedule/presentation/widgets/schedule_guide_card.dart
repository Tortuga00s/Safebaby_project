// lib/screens/schedule/widgets/schedule_guide_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';

class ScheduleGuideCard extends StatelessWidget {
  final int? selectedDate;
  final VoidCallback onAddPressed;
  final ValueChanged<ScheduleItem> onEditPressed;
  final ValueChanged<ScheduleItem> onDeletePressed;
  final ValueChanged<ScheduleItem> onRecordResultPressed;

  const ScheduleGuideCard({
    super.key,
    required this.selectedDate,
    required this.onAddPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onRecordResultPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil jadwal tersimpan untuk tanggal yang sedang dipilih
    final schedule = selectedDate != null
        ? ScheduleData.instance.getScheduleForDay(2026, 10, selectedDate!)
        : null;

    final isScheduled = schedule != null;

    final cardContent = Container(
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
            color: Color(0x080F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Kalender Mint
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.accentTeal,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Teks Panduan / Jadwal
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isScheduled) {
                  onEditPressed(schedule);
                } else {
                  onAddPressed();
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isScheduled
                        ? '${schedule.date.day} Oktober 2026 • ${schedule.time}'
                        : 'Pilih tanggal terlebih dahulu',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isScheduled
                        ? '${schedule.location} (${schedule.status})'
                        : 'Setelah tanggal dipilih, tekan tombol + di kanan atas.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isScheduled) ...[
            const SizedBox(width: 8),

            // Tombol Ubah (Pensil)
            GestureDetector(
              onTap: () => onEditPressed(schedule),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.accentTeal,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Tombol Hapus (Sampah Merah)
            GestureDetector(
              onTap: () => onDeletePressed(schedule),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
              ),
            ),
          ] else
            GestureDetector(
              onTap: onAddPressed,
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ),
        ],
      ),
    );

    if (!isScheduled) {
      return cardContent;
    }

    // Jika ada jadwal, tampilkan tombol "Selesai & Catat Hasil Pemeriksaan"
    return Column(
      children: [
        cardContent,
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () => onRecordResultPressed(schedule),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
            ),
            label: Text(
              'Selesai & Catat Hasil Pemeriksaan',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentTeal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

