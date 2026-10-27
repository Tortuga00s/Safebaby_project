// lib/core/date_formatter.dart
import 'package:flutter/material.dart';

class AppDateFormatter {
  static const List<String> monthNames = [
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

  static const List<String> dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  /// Mengembalikan nama bulan dalam Bahasa Indonesia (1-12)
  static String getMonthName(int month) {
    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    }
    return '';
  }

  /// Mengembalikan nama hari dalam Bahasa Indonesia (DateTime.monday - sunday)
  static String getDayName(int weekday) {
    if (weekday >= 1 && weekday <= 7) {
      return dayNames[weekday - 1];
    }
    return '';
  }

  /// Format: "20 Oktober 2026"
  static String formatSimpleDate(DateTime date) {
    return '${date.day} ${getMonthName(date.month)} ${date.year}';
  }

  /// Format: "Senin, 20 Oktober 2026"
  static String formatFullDate(DateTime date) {
    return '${getDayName(date.weekday)}, ${date.day} ${getMonthName(date.month)} ${date.year}';
  }

  /// Format: "09.00 WIB"
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour.$minute WIB';
  }
}

