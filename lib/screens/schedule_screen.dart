// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/schedule_data.dart';
import 'add_schedule_screen.dart';
import '../widgets/record_checkup_sheet.dart';
import 'history_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? onNavigateToDashboard;
  final VoidCallback? onNavigateToHistory;
  final bool isEmbedded;
  final int? initialSelectedDate;

  const ScheduleScreen({
    super.key,
    this.onNavigateToDashboard,
    this.onNavigateToHistory,
    this.isEmbedded = false,
    this.initialSelectedDate,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Tanggal yang sedang dipilih (null jika belum memilih tanggal)
  int? _selectedDate;

  // Tab navigasi bawah jika screen dibuka secara standalone
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

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan data jadwal secara reaktif
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

                // ─── 1. TOP BAR: JUDUL & TOMBOL TAMBAH (+) ───
                _buildHeader(),

                const SizedBox(height: 28),

                // ─── 2. BULAN & PANDUAN GANTI BULAN ───
                _buildMonthHeader(),

                const SizedBox(height: 20),

                // ─── 3. KALENDER BULANAN INTERAKTIF (OKTOBER 2026) ───
                _buildCalendarGrid(),

                const SizedBox(height: 28),

                // ─── 4. CARD PANDUAN / DETAIL TANGGAL DIPILIH ───
                _buildSelectionGuideCard(),

                const SizedBox(height: 16),

                // ─── 5. CARD STATUS PENGINGAT H-3 AKTIF ───
                _buildReminderStatusCard(),

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
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  // ─── 1. WIDGET HEADER ───
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Kontrol',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola rencana pemeriksaan Anda.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),

        // Tombol Tambah (+) Abu-Abu Bulat
        GestureDetector(
          onTap: _navigateToAddSchedule,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  // ─── 2. WIDGET HEADER BULAN & PANDUAN ───
  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '10 / 2026',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            letterSpacing: -0.5,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 3.5,
              decoration: BoxDecoration(
                color: AppColors.accentTeal,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Geser untuk ganti bulan',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── 3. WIDGET GRID KALENDER OKTOBER 2026 ───
  Widget _buildCalendarGrid() {
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
            final isSelected = cell.isCurrentMonth && _selectedDate == cell.day;

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
                  ? () {
                      setState(() {
                        _selectedDate = cell.day;
                      });
                    }
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

                    // Titik Indikator Toska Dinamis (Muncul untuk semua tanggal berjadwal)
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

  // ─── 4. WIDGET CARD PANDUAN / DETAIL TANGGAL DENGAN EDIT & DELETE ───
  Widget _buildSelectionGuideCard() {
    // Ambil jadwal tersimpan untuk tanggal yang sedang dipilih
    final schedule = _selectedDate != null
        ? ScheduleData.instance.getScheduleForDay(2026, 10, _selectedDate!)
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
                  _navigateToEditSchedule(schedule);
                } else {
                  _navigateToAddSchedule();
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
              onTap: () => _navigateToEditSchedule(schedule),
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
              onTap: () => _confirmDeleteSchedule(context, schedule),
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
              onTap: _navigateToAddSchedule,
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
            onPressed: () => _openRecordCheckupResult(schedule),
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

  // Fungsi membuka bottom sheet untuk menandai selesai dan mencatat hasil kontrol
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

  // Fungsi navigasi ke formulir Tambah Jadwal
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

  // Fungsi navigasi ke formulir Ubah/Edit Jadwal
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

  // Dialog Konfirmasi Hapus Jadwal dari Layar Kalender
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

  // ─── 5. WIDGET STATUS CARD: PENGINGAT H-3 AKTIF (DENGAN SAKLAR ON/OFF) ───
  Widget _buildReminderStatusCard() {
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
                    // Munculkan dialog konfirmasi sebelum mematikan
                    _showDisableReminderConfirmation(context);
                  } else {
                    // Aktifkan langsung kembali
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

  // Dialog Konfirmasi Keamanan saat Hendak Mematikan Pengingat
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

  // ─── 6. BOTTOM NAVIGATION BAR (STANDALONE MODE) ───
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Dashboard',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month_rounded,
                label: 'Jadwal',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.history_rounded,
                activeIcon: Icons.history_rounded,
                label: 'Riwayat',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;
    final color = isSelected ? AppColors.primaryDark : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () {
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
        } else {
          setState(() {
            _currentTabIndex = index;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
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
