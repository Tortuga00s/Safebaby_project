// lib/core/history_data.dart
import 'package:flutter/foundation.dart';

class CheckupHistoryItem {
  final int id;
  final DateTime date;
  final String location;
  final String status;
  final String? doctorOrMidwife;
  final String? gestationalAge;
  final String? bloodPressure;
  final String? weight;
  final String? fetalHeartRate;
  final String? notes;

  const CheckupHistoryItem({
    required this.id,
    required this.date,
    required this.location,
    this.status = 'Selesai',
    this.doctorOrMidwife,
    this.gestationalAge,
    this.bloodPressure,
    this.weight,
    this.fetalHeartRate,
    this.notes,
  });
}

class HistoryData {
  // Singleton instance
  static final HistoryData instance = HistoryData._internal();
  HistoryData._internal();

  // State reaktif dengan ValueNotifier (mulai kosong secara default)
  final ValueNotifier<List<CheckupHistoryItem>> historyNotifier =
      ValueNotifier<List<CheckupHistoryItem>>([]);

  List<CheckupHistoryItem> get history => historyNotifier.value;

  // Riwayat pemeriksaan paling terakhir (terbaru)
  CheckupHistoryItem? get latestHistory {
    if (historyNotifier.value.isEmpty) return null;
    final sorted = [...historyNotifier.value]
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first;
  }

  // ID berikutnya untuk riwayat baru
  int get nextId {
    if (historyNotifier.value.isEmpty) return 1;
    final maxId = historyNotifier.value
        .map((e) => e.id)
        .reduce((max, current) => current > max ? current : max);
    return maxId + 1;
  }

  // Menambahkan riwayat pemeriksaan baru
  void addHistory(CheckupHistoryItem item) {
    historyNotifier.value = [item, ...historyNotifier.value];
  }

  // Memperbarui riwayat pemeriksaan yang sudah ada
  void updateHistory(CheckupHistoryItem updatedItem) {
    historyNotifier.value = historyNotifier.value.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();
  }

  // Menghapus riwayat pemeriksaan
  void deleteHistory(int id) {
    historyNotifier.value =
        historyNotifier.value.where((item) => item.id != id).toList();
  }
}

