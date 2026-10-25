// lib/core/schedule_data.dart
import 'package:flutter/foundation.dart';

class ScheduleItem {
  final int id;
  final DateTime date;
  final String time;
  final String location;
  final String status;

  const ScheduleItem({
    required this.id,
    required this.date,
    required this.time,
    required this.location,
    this.status = 'Terjadwal',
  });
}

class ScheduleData {
  // Singleton instance
  static final ScheduleData instance = ScheduleData._internal();
  ScheduleData._internal();

  // State reaktif dengan ValueNotifier (mulai kosong secara default sebelum pengguna membuat jadwal)
  final ValueNotifier<List<ScheduleItem>> schedulesNotifier =
      ValueNotifier<List<ScheduleItem>>([]);

  // Pengaturan Pengingat Otomatis (Aktif/Nonaktif)
  final ValueNotifier<bool> isReminderEnabledNotifier =
      ValueNotifier<bool>(true);

  // Standar hari pengingat tetap (H-3 sebelum jadwal kontrol)
  static const int reminderDaysBefore = 3;

  List<ScheduleItem> get schedules => schedulesNotifier.value;
  bool get isReminderEnabled => isReminderEnabledNotifier.value;

  void setReminderEnabled(bool enabled) {
    isReminderEnabledNotifier.value = enabled;
  }

  // Jadwal terdekat yang akan datang (upcoming)
  ScheduleItem? get upcomingSchedule {
    if (schedulesNotifier.value.isEmpty) return null;
    final sorted = [...schedulesNotifier.value]
      ..sort((a, b) => a.date.compareTo(b.date));
    return sorted.first;
  }

  // Apakah pengguna sudah memiliki setidaknya 1 jadwal
  bool get hasSchedules => schedulesNotifier.value.isNotEmpty;

  // Menambahkan jadwal baru
  void addSchedule(ScheduleItem item) {
    schedulesNotifier.value = [...schedulesNotifier.value, item];
  }

  // Memperbarui jadwal yang sudah ada
  void updateSchedule(ScheduleItem updatedItem) {
    schedulesNotifier.value = schedulesNotifier.value.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();
  }

  // Menghapus jadwal berdasarkan id
  void deleteSchedule(int id) {
    schedulesNotifier.value =
        schedulesNotifier.value.where((item) => item.id != id).toList();
  }

  // Mencari jadwal berdasarkan tanggal
  ScheduleItem? getScheduleForDay(int year, int month, int day) {
    for (final item in schedulesNotifier.value) {
      if (item.date.year == year &&
          item.date.month == month &&
          item.date.day == day) {
        return item;
      }
    }
    return null;
  }

  // Memeriksa apakah suatu hari memiliki jadwal kontrol
  bool hasScheduleOnDay(int year, int month, int day) {
    return getScheduleForDay(year, month, day) != null;
  }
}

