// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/history_data.dart';
import '../widgets/record_checkup_sheet.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CheckupHistoryItem>>(
      valueListenable: HistoryData.instance.historyNotifier,
      builder: (context, allHistory, _) {
        // Filter daftar riwayat berdasarkan kata kunci pencarian
        final filteredHistory = allHistory.where((item) {
          if (_searchQuery.isEmpty) return true;
          final dateString =
              '${item.date.day} ${_getMonthName(item.date.month)} ${item.date.year}'
                  .toLowerCase();
          final locationString = item.location.toLowerCase();
          final doctorString =
              (item.doctorOrMidwife ?? '').toLowerCase();

          return dateString.contains(_searchQuery) ||
              locationString.contains(_searchQuery) ||
              doctorString.contains(_searchQuery);
        }).toList();

        // Kelompokkan riwayat berdasarkan tahun secara terurut menurun
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

                // ─── 1. TOP BAR: JUDUL & SUB-JUDUL ───
                _buildHeader(),

                const SizedBox(height: 20),

                // ─── 2. SEARCH BAR (CARI TANGGAL ATAU LOKASI) ───
                _buildSearchBar(),

                const SizedBox(height: 24),

                // ─── 3. DAFTAR RIWAYAT DIKELOMPOKKAN BERDASARKAN TAHUN ───
                if (filteredHistory.isEmpty)
                  _buildEmptyState()
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
                          return _buildHistoryCard(item);
                        }),

                        const SizedBox(height: 12),
                      ],
                    );
                  }),

                  const SizedBox(height: 8),

                  // ─── 4. FOOTER SUMMARY (JUMLAH PEMERIKSAAN) ───
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Pemeriksaan',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Catatan kontrol Anda tersimpan di sini.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Tambah Riwayat Manual (+)
        GestureDetector(
          onTap: () => _openRecordCheckupSheet(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.accentTeal,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  // Fungsi membuka formulir pencatatan hasil pemeriksaan
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

  // ─── 2. WIDGET SEARCH BAR ───
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.primaryDark,
        ),
        decoration: InputDecoration(
          hintText: 'Cari tanggal atau lokasi',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF94A3B8),
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
      ),
    );
  }

  // ─── 3. WIDGET KARTU RIWAYAT PEMERIKSAAN ───
  Widget _buildHistoryCard(CheckupHistoryItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showDetailBottomSheet(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                // Ikon Centang Hijau dalam Kotak Mint
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

                // Teks Tanggal & Lokasi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.date.day} ${_getMonthName(item.date.month)} ${item.date.year}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.location,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge Status "Selesai"
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
                    item.status,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Chevron Arrow Kanan
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── 4. WIDGET FOOTER SUMMARY (JUMLAH PEMERIKSAAN TERSIMPAN) ───
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

  // ─── 5. WIDGET EMPTY STATE SAAT PENCARIAN KOSONG ATAU BELUM ADA DATA ───
  Widget _buildEmptyState() {
    final isSearching = _searchQuery.isNotEmpty;

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
                onPressed: () => _openRecordCheckupSheet(),
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

  // ─── 6. DETAIL BOTTOM SHEET KETIKA KARTU DIKLIK ───
  void _showDetailBottomSheet(CheckupHistoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar di Atas
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

                // Judul & Badge Selesai + Tombol Ubah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Pemeriksaan',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            _openRecordCheckupSheet(initialItem: item);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 13,
                                  color: AppColors.accentTeal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Ubah',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                            item.status,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Catatan medis hasil kontrol kehamilan Anda.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 20),

                // Tanggal & Tempat
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.calendar_today_rounded,
                        label: 'Tanggal',
                        value:
                            '${item.date.day} ${_getMonthName(item.date.month)} ${item.date.year}',
                      ),
                      const Divider(height: 18, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'Tempat / Klinik',
                        value: item.location,
                      ),
                      if (item.doctorOrMidwife != null) ...[
                        const Divider(height: 18, color: Color(0xFFE2E8F0)),
                        _buildDetailRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Tenaga Medis',
                          value: item.doctorOrMidwife!,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Parameter Kesehatan (Grid)
                if (item.gestationalAge != null ||
                    item.bloodPressure != null ||
                    item.weight != null ||
                    item.fetalHeartRate != null) ...[
                  Row(
                    children: [
                      if (item.gestationalAge != null)
                        Expanded(
                          child: _buildHealthParamCard(
                            label: 'Usia Janin',
                            value: item.gestationalAge!,
                          ),
                        ),
                      if (item.gestationalAge != null &&
                          item.bloodPressure != null)
                        const SizedBox(width: 10),
                      if (item.bloodPressure != null)
                        Expanded(
                          child: _buildHealthParamCard(
                            label: 'Tensi Darah',
                            value: item.bloodPressure!,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (item.weight != null)
                        Expanded(
                          child: _buildHealthParamCard(
                            label: 'Berat Badan',
                            value: item.weight!,
                          ),
                        ),
                      if (item.weight != null &&
                          item.fetalHeartRate != null)
                        const SizedBox(width: 10),
                      if (item.fetalHeartRate != null)
                        Expanded(
                          child: _buildHealthParamCard(
                            label: 'Detak Jantung (DJJ)',
                            value: item.fetalHeartRate!,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Catatan Dokter / Bidan
                if (item.notes != null) ...[
                  Text(
                    'Catatan Medis',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      item.notes!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Baris Tombol Aksi (Ubah Catatan & Tutup)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _openRecordCheckupSheet(initialItem: item);
                          },
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          label: Text(
                            'Ubah Catatan',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryDark,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Tutup',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accentTeal),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthParamCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  // ─── 7. BOTTOM NAVIGATION BAR (UNTUK STANDALONE MODE) ───
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
    final isActive = _currentTabIndex == index;
    final color = isActive ? AppColors.primaryDark : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () {
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
              MaterialPageRoute(
                builder: (_) => const ScheduleScreen(),
              ),
            );
          }
        } else if (index == 3) {
          if (widget.onNavigateToProfile != null) {
            widget.onNavigateToProfile!();
          } else {
            Navigator.pushReplacement(
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
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format Nama Bulan Bahasa Indonesia
  static String _getMonthName(int month) {
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
}

