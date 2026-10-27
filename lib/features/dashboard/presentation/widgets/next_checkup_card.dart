// lib/screens/dashboard/widgets/next_checkup_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/core/utils/date_formatter.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';

class NextCheckupCard extends StatelessWidget {
  final ScheduleItem? schedule;
  final ValueChanged<int>? onScheduleSelected;
  final VoidCallback? onEmptyTapped;

  const NextCheckupCard({
    super.key,
    required this.schedule,
    this.onScheduleSelected,
    this.onEmptyTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (schedule == null) {
      return GestureDetector(
        onTap: onEmptyTapped,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Atas: Label Kontrol & Pill "Belum Ada"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KONTROL BERIKUTNYA',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Belum Ada',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Baris Tengah: Ikon & Teks Belum Ada Jadwal
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.accentTeal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Belum Ada Jadwal Kontrol',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Atur jadwal pemeriksaan Anda untuk mendapatkan pengingat tepat waktu.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.7),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Garis Pembatas Tipis
              Divider(
                color: Colors.white.withValues(alpha: 0.12),
                height: 1,
                thickness: 1,
              ),

              const SizedBox(height: 14),

              // Baris Bawah: CTA Buat Jadwal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 16,
                        color: AppColors.accentTeal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Buat Jadwal Pemeriksaan',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.accentTeal,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Jika sudah ada jadwal kontrol
    final now = DateTime.now();
    final scheduleDate = DateTime(
      schedule!.date.year,
      schedule!.date.month,
      schedule!.date.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final diff = scheduleDate.difference(today).inDays;

    String badgeText;
    if (diff == 0) {
      badgeText = 'Hari Ini';
    } else if (diff == 1) {
      badgeText = 'Besok';
    } else if (diff > 1) {
      badgeText = '$diff Hari Lagi';
    } else {
      badgeText = 'Terlewat';
    }

    return GestureDetector(
      onTap: () {
        if (onScheduleSelected != null) {
          onScheduleSelected!(schedule!.date.day);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: Label Kontrol & Pill Hari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KONTROL BERIKUTNYA',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Baris Tengah: Tanggal & Bulan Dinamis
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${schedule!.date.day}',
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateFormatter.getMonthName(schedule!.date.month),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${schedule!.date.year}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Garis Pembatas Tipis Transparan
            Divider(
              color: Colors.white.withValues(alpha: 0.12),
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 16),

            // Baris Bawah: Waktu & Lokasi Dinamis
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      schedule!.time,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          schedule!.location,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

