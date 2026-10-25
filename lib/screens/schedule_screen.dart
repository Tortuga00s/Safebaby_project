// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import 'notification_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? onNavigateToDashboard;
  final bool isEmbedded;

  const ScheduleScreen({
    super.key,
    this.onNavigateToDashboard,
    this.isEmbedded = false,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Tanggal yang sedang dipilih (default: null atau tanggal 20 jika dipilih)
  int? _selectedDate = 20;

  // Tanggal yang memiliki jadwal kontrol aktif (misal: 20 Oktober 2026)
  final int _scheduledDate = 20;

  // Tab navigasi bawah jika screen dibuka secara standalone
  int _currentTabIndex = 1;

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            _showAddScheduleBottomSheet();
          },
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
      _CalendarCell(day: 20, isCurrentMonth: true, hasEventDot: true),
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
                          fontWeight: isSelected || cell.hasEventDot
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Titik Indikator Toska (Untuk tanggal dengan jadwal kontrol, misal: 20)
                    if (cell.hasEventDot)
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

  // ─── 4. WIDGET CARD PANDUAN / DETAIL TANGGAL ───
  Widget _buildSelectionGuideCard() {
    final isControlDay = _selectedDate == _scheduledDate;

    return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isControlDay
                      ? '20 Oktober 2026 • 09.00 WIB'
                      : 'Pilih tanggal terlebih dahulu',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isControlDay
                      ? 'Jadwal Kontrol Rutin di Klinik ABC'
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
        ],
      ),
    );
  }

  // ─── 5. WIDGET STATUS CARD: PENGINGAT H-3 AKTIF ───
  Widget _buildReminderStatusCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationScreen(),
          ),
        );
      },
      child: Container(
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
            // Ikon Lonceng Mint
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.accentTeal,
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
                    'Pengingat H-3 aktif',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Notifikasi akan dikirim otomatis',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Chevron Arrow Kanan
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ],
        ),
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

  // Bottom Sheet untuk Menambah Jadwal Kontrol Baru
  void _showAddScheduleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Tambah Jadwal Kontrol',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tanggal dipilih: ${_selectedDate ?? 20} Oktober 2026',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentTeal,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Jadwal kontrol ${_selectedDate ?? 20} Oktober 2026 disimpan!',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Simpan Jadwal',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarCell {
  final int day;
  final bool isCurrentMonth;
  final bool isWeekend;
  final bool hasEventDot;

  _CalendarCell({
    required this.day,
    this.isCurrentMonth = true,
    this.isWeekend = false,
    this.hasEventDot = false,
  });
}

