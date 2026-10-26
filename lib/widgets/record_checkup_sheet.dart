// lib/widgets/record_checkup_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/history_data.dart';
import '../core/schedule_data.dart';

class RecordCheckupSheet extends StatefulWidget {
  final CheckupHistoryItem? initialItem;
  final ScheduleItem? fromSchedule;
  final DateTime? defaultDate;

  const RecordCheckupSheet({
    super.key,
    this.initialItem,
    this.fromSchedule,
    this.defaultDate,
  });

  /// Helper statis untuk menampilkan bottom sheet dengan konfigurasi yang konsisten
  static Future<bool?> show(
    BuildContext context, {
    CheckupHistoryItem? initialItem,
    ScheduleItem? fromSchedule,
    DateTime? defaultDate,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecordCheckupSheet(
        initialItem: initialItem,
        fromSchedule: fromSchedule,
        defaultDate: defaultDate,
      ),
    );
  }

  @override
  State<RecordCheckupSheet> createState() => _RecordCheckupSheetState();
}

class _RecordCheckupSheetState extends State<RecordCheckupSheet> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  late TextEditingController _locationController;
  late TextEditingController _doctorController;
  late TextEditingController _gestationalAgeController;
  late TextEditingController _bloodPressureController;
  late TextEditingController _weightController;
  late TextEditingController _fetalHeartRateController;
  late TextEditingController _notesController;

  bool get _isEditMode => widget.initialItem != null;

  @override
  void initState() {
    super.initState();

    final item = widget.initialItem;
    final sched = widget.fromSchedule;

    if (item != null) {
      _selectedDate = item.date;
      _locationController = TextEditingController(text: item.location);
      _doctorController =
          TextEditingController(text: item.doctorOrMidwife ?? '');
      _gestationalAgeController =
          TextEditingController(text: item.gestationalAge ?? '');
      _bloodPressureController =
          TextEditingController(text: item.bloodPressure ?? '');
      _weightController = TextEditingController(text: item.weight ?? '');
      _fetalHeartRateController =
          TextEditingController(text: item.fetalHeartRate ?? '');
      _notesController = TextEditingController(text: item.notes ?? '');
    } else if (sched != null) {
      _selectedDate = sched.date;
      _locationController = TextEditingController(text: sched.location);
      _doctorController = TextEditingController();
      _gestationalAgeController = TextEditingController();
      _bloodPressureController = TextEditingController();
      _weightController = TextEditingController();
      _fetalHeartRateController = TextEditingController();
      _notesController = TextEditingController();
    } else {
      _selectedDate = widget.defaultDate ?? DateTime.now();
      _locationController = TextEditingController();
      _doctorController = TextEditingController();
      _gestationalAgeController = TextEditingController();
      _bloodPressureController = TextEditingController();
      _weightController = TextEditingController();
      _fetalHeartRateController = TextEditingController();
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _doctorController.dispose();
    _gestationalAgeController.dispose();
    _bloodPressureController.dispose();
    _weightController.dispose();
    _fetalHeartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveResult() {
    if (!_formKey.currentState!.validate()) return;

    final location = _locationController.text.trim();
    final doctor = _doctorController.text.trim();
    final age = _gestationalAgeController.text.trim();
    final bp = _bloodPressureController.text.trim();
    final weight = _weightController.text.trim();
    final fhr = _fetalHeartRateController.text.trim();
    final notes = _notesController.text.trim();

    if (_isEditMode) {
      final updated = CheckupHistoryItem(
        id: widget.initialItem!.id,
        date: _selectedDate,
        location: location,
        status: widget.initialItem!.status,
        doctorOrMidwife: doctor.isNotEmpty ? doctor : null,
        gestationalAge: age.isNotEmpty ? age : null,
        bloodPressure: bp.isNotEmpty ? bp : null,
        weight: weight.isNotEmpty ? weight : null,
        fetalHeartRate: fhr.isNotEmpty ? fhr : null,
        notes: notes.isNotEmpty ? notes : null,
      );
      HistoryData.instance.updateHistory(updated);
    } else {
      final newItem = CheckupHistoryItem(
        id: HistoryData.instance.nextId,
        date: _selectedDate,
        location: location,
        status: 'Selesai',
        doctorOrMidwife: doctor.isNotEmpty ? doctor : null,
        gestationalAge: age.isNotEmpty ? age : null,
        bloodPressure: bp.isNotEmpty ? bp : null,
        weight: weight.isNotEmpty ? weight : null,
        fetalHeartRate: fhr.isNotEmpty ? fhr : null,
        notes: notes.isNotEmpty ? notes : null,
      );

      HistoryData.instance.addHistory(newItem);

      // Jika riwayat dicatat dari jadwal tertentu, hapus jadwal tersebut dari antrean
      if (widget.fromSchedule != null) {
        ScheduleData.instance.deleteSchedule(widget.fromSchedule!.id);
      }
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 14.0,
            bottom: bottomInset + 16.0,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Header Judul & Sub-judul
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
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
                              _isEditMode
                                  ? 'Ubah Catatan Medis'
                                  : 'Catat Hasil Pemeriksaan',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.fromSchedule != null
                                  ? 'Jadwal akan ditandai selesai dan dipindahkan ke Riwayat.'
                                  : 'Masukkan detail pemeriksaan dari Buku KIA Anda.',
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

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 18),

                  // ─── 1. TANGGAL PEMERIKSAAN ───
                  _buildSectionLabel('Tanggal Pemeriksaan *'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 13.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.accentTeal,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Ubah',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 2. TEMPAT / KLINIK ───
                  _buildSectionLabel('Tempat / Fasilitas Kesehatan *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama tempat / klinik tidak boleh kosong';
                      }
                      return null;
                    },
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                    decoration: _inputDecoration(
                      hint: 'Contoh: Klinik ABC, Puskesmas, Bidan XYZ',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 3. DOKTER / BIDAN ───
                  _buildSectionLabel('Nama Dokter / Bidan (Opsional)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _doctorController,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                    decoration: _inputDecoration(
                      hint: 'Contoh: dr. Sarah, Sp.OG / Bidan Rahma',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ─── 4. PARAMETER MEDIS (2x2 GRID) ───
                  _buildSectionLabel('Hasil Pemeriksaan Medis (Opsional)'),
                  const SizedBox(height: 4),
                  Text(
                    'Isi sesuai catatan di Buku KIA atau hasil USG.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // Usia Janin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSubLabel('Usia Janin'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _gestationalAgeController,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                              decoration: _compactInputDecoration(
                                hint: '24 Minggu',
                                prefixIcon: Icons.child_care_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Tensi Darah
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSubLabel('Tensi Darah'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _bloodPressureController,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                              decoration: _compactInputDecoration(
                                hint: '115/75 mmHg',
                                prefixIcon: Icons.favorite_border_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Berat Badan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSubLabel('Berat Badan Ibu'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _weightController,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                              decoration: _compactInputDecoration(
                                hint: '58 kg',
                                prefixIcon: Icons.monitor_weight_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Detak Jantung Janin (DJJ)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSubLabel('Detak Jantung (DJJ)'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _fetalHeartRateController,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                              decoration: _compactInputDecoration(
                                hint: '142 bpm',
                                prefixIcon: Icons.monitor_heart_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── 5. CATATAN MEDIS DOKTER ───
                  _buildSectionLabel('Catatan Dokter / Bidan (Opsional)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.primaryDark,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Contoh: Janin aktif, posisi normal, teruskan vitamin kalsium dan istirahat teratur.',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.accentTeal, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(14.0),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── TOMBOL AKSI SIMPAN ───
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveResult,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isEditMode ? 'Simpan Perubahan' : 'Simpan ke Riwayat',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _buildSubLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF64748B),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFF94A3B8),
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 19,
        color: const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accentTeal, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13.0),
    );
  }

  InputDecoration _compactInputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 12,
        color: const Color(0xFF94A3B8),
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 17,
        color: const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentTeal, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
    );
  }

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

