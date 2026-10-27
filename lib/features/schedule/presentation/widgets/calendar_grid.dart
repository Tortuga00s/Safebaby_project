// lib/screens/schedule/widgets/calendar_grid.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/schedule/data/schedule_data.dart';

class CalendarGrid extends StatelessWidget {
  final int? selectedDate;
  final ValueChanged<int> onDateSelected;

  const CalendarGrid({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    const daysOfWeek = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

    // Struktur Hari Oktober 2026 (Kamis adalah tanggal 1)
    // Hari dari September (bulan sebelumnya): 27, 28, 29, 30
    final calendarCells = [
      // Baris 1
      _CalendarCell(day: 27, isCurrentMonth: false, isWeekend: true),
      _CalendarCell(day: 28, isCurrentMonth: false),
      _CalendarCell(day: 29, isCurrentMonth: false),
      _CalendarCell(day: 30, isCurrentMonth: false),
      _CalendarCell(day: 1, isCurrentMonth: true),
      _CalendarCell(day: 2, isCurrentMonth: true),
      _CalendarCell(day: 3, isCurrentMonth: true, isWeekend: true),

      // Baris 2
      _CalendarCell(day: 4, isCurrentMonth: true, isWeekend: true),
      _CalendarCell(day: 5, isCurrentMonth: true),
      _CalendarCell(day: 6, isCurrentMonth: true),
      _CalendarCell(day: 7, isCurrentMonth: true),
      _CalendarCell(day: 8, isCurrentMonth: true),
      _CalendarCell(day: 9, isCurrentMonth: true),
      _CalendarCell(day: 10, isCurrentMonth: true, isWeekend: true),

      // Baris 3
      _CalendarCell(day: 11, isCurrentMonth: true, isWeekend: true),
      _CalendarCell(day: 12, isCurrentMonth: true),
      _CalendarCell(day: 13, isCurrentMonth: true),
      _CalendarCell(day: 14, isCurrentMonth: true),
      _CalendarCell(day: 15, isCurrentMonth: true),
      _CalendarCell(day: 16, isCurrentMonth: true),
      _CalendarCell(day: 17, isCurrentMonth: true, isWeekend: true),

      // Baris 4
      _CalendarCell(day: 18, isCurrentMonth: true, isWeekend: true),
      _CalendarCell(day: 19, isCurrentMonth: true),
      _CalendarCell(day: 20, isCurrentMonth: true),
      _CalendarCell(day: 21, isCurrentMonth: true),
      _CalendarCell(day: 22, isCurrentMonth: true),
      _CalendarCell(day: 23, isCurrentMonth: true),
      _CalendarCell(day: 24, isCurrentMonth: true, isWeekend: true),

      // Baris 5
      _CalendarCell(day: 25, isCurrentMonth: true, isWeekend: true),
      _CalendarCell(day: 26, isCurrentMonth: true),
      _CalendarCell(day: 27, isCurrentMonth: true),
      _CalendarCell(day: 28, isCurrentMonth: true),
      _CalendarCell(day: 29, isCurrentMonth: true),
      _CalendarCell(day: 30, isCurrentMonth: true),
      _CalendarCell(day: 31, isCurrentMonth: true, isWeekend: true),
    ];

    return Column(
      children: [
        // Header Nama Hari: MIN, SEN, SEL, RAB, KAM, JUM, SAB
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek.map((day) {
            return SizedBox(
              width: 38,
              child: Center(
                child: Text(
                  day,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Grid Tanggal 5 Baris
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: calendarCells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 4,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final cell = calendarCells[index];
            final isSelected = cell.isCurrentMonth && selectedDate == cell.day;

            // Cek apakah tanggal ini memiliki jadwal tersimpan di ScheduleData
            final hasSchedule = cell.isCurrentMonth &&
                ScheduleData.instance.hasScheduleOnDay(2026, 10, cell.day);

            Color textColor;
            if (!cell.isCurrentMonth) {
              textColor = cell.isWeekend
                  ? const Color(0xFFA7D7D0) // Toska pudar untuk akhir pekan bulan lalu
                  : const Color(0xFFCBD5E1); // Abu-abu pudar
            } else if (cell.isWeekend) {
              textColor = AppColors.accentTeal; // Toska untuk akhir pekan
            } else {
              textColor = AppColors.primaryDark; // Navy gelap untuk hari kerja
            }

            return GestureDetector(
              onTap: cell.isCurrentMonth
                  ? () => onDateSelected(cell.day)
                  : null,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF8F6)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.accentTeal,
                                width: 1.5,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${cell.day}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected || hasSchedule
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Titik Indikator Toska Dinamis
                    if (hasSchedule)
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.accentTeal,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CalendarCell {
  final int day;
  final bool isCurrentMonth;
  final bool isWeekend;

  _CalendarCell({
    required this.day,
    this.isCurrentMonth = true,
    this.isWeekend = false,
  });
}

