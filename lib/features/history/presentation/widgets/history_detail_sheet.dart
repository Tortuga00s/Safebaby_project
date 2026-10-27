// lib/screens/history/widgets/history_detail_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/core/utils/date_formatter.dart';
import 'package:safebaby/features/history/data/history_data.dart';

class HistoryDetailSheet {
  static void show(
    BuildContext context, {
    required CheckupHistoryItem item,
    required ValueChanged<CheckupHistoryItem> onEdit,
  }) {
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
                            onEdit(item);
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
                        value: AppDateFormatter.formatSimpleDate(item.date),
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
                            onEdit(item);
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

  static Widget _buildDetailRow({
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

  static Widget _buildHealthParamCard({
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
}

