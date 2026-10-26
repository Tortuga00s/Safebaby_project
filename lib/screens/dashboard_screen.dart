// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/schedule_data.dart';
import 'notification_screen.dart';
import '../core/history_data.dart';
import 'history_screen.dart';
import 'schedule_screen.dart';

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
            onNavigateToDashboard: () {
              setState(() {
                _currentTabIndex = 0;
              });
            },
            onNavigateToHistory: () {
              setState(() {
                _currentTabIndex = 2;
              });
            },
          ),

          // Tab 2: Riwayat Pemeriksaan
          HistoryScreen(
            isEmbedded: true,
            onNavigateToDashboard: () {
              setState(() {
                _currentTabIndex = 0;
              });
            },
            onNavigateToSchedule: () {
              setState(() {
                _currentTabIndex = 1;
              });
            },
          ),

          // Tab 3: Profil Pengguna (Placeholder)
          _buildPlaceholderTab('Profil Pengguna'),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ KONTEN TAB 0: DASHBOARD Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildDashboardContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // 1. TOP BAR: GREETING & NOTIFIKASI
            _buildHeader(),

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
                    _buildNextCheckupHeroCard(upcoming),
                    const SizedBox(height: 16),
                    _buildActiveReminderCard(upcoming),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // 4. SECTION: RIWAYAT TERBARU
            _buildRecentHistorySection(),

            const SizedBox(height: 20),

            // 5. FEATURE CARD: TIP HARI INI
            _buildDailyTipCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ 1. WIDGET HEADER (SALAM & TOMBOL NOTIFIKASI) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat pagi,',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, ${widget.userName}',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Tombol Lonceng Notifikasi dengan Badge Titik Merah Dinamis
        AnimatedBuilder(
          animation: Listenable.merge([
            ScheduleData.instance.schedulesNotifier,
            ScheduleData.instance.isReminderEnabledNotifier,
          ]),
          builder: (context, _) {
            final upcoming = ScheduleData.instance.upcomingSchedule;
            final isReminderEnabled = ScheduleData.instance.isReminderEnabled;

            bool hasActiveReminder = false;
            if (isReminderEnabled && upcoming != null) {
              final now = DateTime.now();
              final scheduleDate = DateTime(
                upcoming.date.year,
                upcoming.date.month,
                upcoming.date.day,
              );
              final today = DateTime(now.year, now.month, now.day);
              final daysLeft = scheduleDate.difference(today).inDays;
              hasActiveReminder = daysLeft >= 0 && daysLeft <= 3;
            }

            return GestureDetector(
              onTap: () async {
                final targetDay = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
                if (targetDay != null && mounted) {
                  setState(() {
                    _scheduleSelectedDay = targetDay;
                    _currentTabIndex = 1; // Pindah ke tab Jadwal
                  });
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                    ),
                  ),
                  if (hasActiveReminder)
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ 2. WIDGET HERO CARD: KONTROL BERIKUTNYA Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildNextCheckupHeroCard(ScheduleItem? schedule) {
    if (schedule == null) {
      return GestureDetector(
        onTap: () {
          // Klik hero card kosong langsung membuka tab Jadwal
          setState(() {
            _currentTabIndex = 1;
          });
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

    // Jika sudah ada jadwal
    final now = DateTime.now();
    final scheduleDate = DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
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
        setState(() {
          _scheduleSelectedDay = schedule.date.day;
          _currentTabIndex = 1;
        });
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
                  '${schedule.date.day}',
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
                      _getMonthName(schedule.date.month),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${schedule.date.year}',
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
                      schedule.time,
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
                          schedule.location,
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

  // â”€â”€â”€ 3. WIDGET STATUS CARD: PENGINGAT AKTIF â”€â”€â”€
  Widget _buildActiveReminderCard(ScheduleItem? schedule) {
    final hasSchedule = schedule != null;
    final isReminderEnabled = ScheduleData.instance.isReminderEnabled;

    final String title;
    final String subtitle;
    final IconData iconData;
    final Color iconColor;
    final Color iconBg;

    if (!isReminderEnabled) {
      title = 'Pengingat dinonaktifkan';
      subtitle = 'Ketuk untuk mengaktifkan kembali di tab Jadwal.';
      iconData = Icons.notifications_off_outlined;
      iconColor = const Color(0xFF94A3B8);
      iconBg = const Color(0xFFF1F5F9);
    } else if (hasSchedule) {
      final now = DateTime.now();
      final scheduleDate = DateTime(
        schedule.date.year,
        schedule.date.month,
        schedule.date.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final daysLeft = scheduleDate.difference(today).inDays;

      title = 'Pengingat H-3 aktif';
      if (daysLeft == 0) {
        subtitle = 'Jadwal pemeriksaan Anda hari ini pukul ${schedule.time}.';
      } else if (daysLeft == 1) {
        subtitle = 'Pemeriksaan besok! Notifikasi pengingat sudah aktif.';
      } else if (daysLeft <= 3 && daysLeft > 1) {
        subtitle =
            'Pemeriksaan $daysLeft hari lagi. Pengingat telah dikirim ke notifikasi.';
      } else {
        final h3Date = schedule.date.subtract(const Duration(days: 3));
        subtitle =
            'Kami akan mengingatkan Anda pada ${h3Date.day} ${_getMonthName(h3Date.month)}.';
      }
      iconData = Icons.notifications_outlined;
      iconColor = AppColors.accentTeal;
      iconBg = const Color(0xFFEAF8F6);
    } else {
      title = 'Pengingat belum aktif';
      subtitle =
          'Pengingat otomatis aktif setelah Anda membuat jadwal kontrol.';
      iconData = Icons.notifications_none_rounded;
      iconColor = const Color(0xFF94A3B8);
      iconBg = const Color(0xFFF1F5F9);
    }

    return GestureDetector(
      onTap: () async {
        if (!isReminderEnabled) {
          // Arahkan ke tab Jadwal agar pengguna bisa menyalakan pengingat kembali
          setState(() {
            _currentTabIndex = 1;
          });
        } else if (hasSchedule) {
          final targetDay = await Navigator.push<int>(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationScreen(),
            ),
          );
          if (targetDay != null && mounted) {
            setState(() {
              _scheduleSelectedDay = targetDay;
              _currentTabIndex = 1; // Pindah ke tab Jadwal
            });
          }
        } else {
          // Jika belum ada jadwal, alihkan pengguna ke tab Jadwal untuk membuat jadwal
          setState(() {
            _currentTabIndex = 1;
          });
        }
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
              color: Color(0x0A0F172A),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Kotak Lonceng
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
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
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

  // Format Nama Bulan Bahasa Indonesia
  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ 4. WIDGET SECTION: RIWAYAT TERBARU Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildRecentHistorySection() {
    return ValueListenableBuilder<List<CheckupHistoryItem>>(
      valueListenable: HistoryData.instance.historyNotifier,
      builder: (context, historyList, _) {
        final latest = HistoryData.instance.latestHistory;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Header: Judul Riwayat & Tombol "Lihat semua"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Terbaru',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pemeriksaan terakhir Anda',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 2; // Pindah ke tab Riwayat
                    });
                  },
                  child: Text(
                    'Lihat semua',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Kartu Riwayat Pemeriksaan (Dinamis / State Kosong)
            if (latest == null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTabIndex = 2; // Pindah ke tab Riwayat
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFF94A3B8),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Belum Ada Riwayat',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Catatan kontrol akan muncul di sini setelah Anda menyelesaikan pemeriksaan.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTabIndex = 2; // Pindah ke tab Riwayat
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon Centang Hijau/Teal
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.accentTeal,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Detail Tanggal & Bidan / Tempat
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${latest.date.day} ${_getMonthName(latest.date.month)} ${latest.date.year}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              latest.doctorOrMidwife != null &&
                                      latest.doctorOrMidwife!.isNotEmpty
                                  ? '${latest.location} • ${latest.doctorOrMidwife}'
                                  : latest.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Badge Pill "Selesai"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          latest.status,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentTeal,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Chevron Arrow Kanan
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ 5. WIDGET FEATURE CARD: TIP HARI INI Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildDailyTipCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTeal.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Ornamen Lingkaran Konsentris Lembut di Pojok Kanan Atas
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 22,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Konten Teks Tip
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TIP HARI INI',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tetap terhidrasi',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Minum air secara berkala membantu menjaga kondisi tubuh selama kehamilan.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ PLACEHOLDER UNTUK TAB RIWAYAT & PROFIL Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  Widget _buildPlaceholderTab(String title) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_empty_rounded,
              size: 48,
              color: AppColors.accentTeal,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman ini akan segera hadir pada update berikutnya.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ 6. BOTTOM NAVIGATION BAR Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
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
        setState(() {
          _currentTabIndex = index;
        });
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
