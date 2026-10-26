// lib/core/profile_data.dart
import 'dart:io';
import 'package:flutter/foundation.dart';

class UserProfile {
  final String name;
  final String age;
  final String phone;
  final String pregnancyInfo;
  final String status;
  final File? profileImage;

  const UserProfile({
    this.name = 'Siti Rahma',
    this.age = '27 Tahun',
    this.phone = '08xxxxxxxxx',
    this.pregnancyInfo = 'Kehamilan pertama',
    this.status = 'Profil terverifikasi',
    this.profileImage,
  });

  /// Mendapatkan nama depan yang rapi untuk greeting di Dashboard
  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'Siti';
    final first = parts.first;
    return first.isNotEmpty
        ? first[0].toUpperCase() + first.substring(1).toLowerCase()
        : 'Siti';
  }

  /// Mendapatkan 2 huruf inisial dari nama pengguna (contoh: Siti Rahma -> SR)
  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'SR';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  UserProfile copyWith({
    String? name,
    String? age,
    String? phone,
    String? pregnancyInfo,
    String? status,
    File? profileImage,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      pregnancyInfo: pregnancyInfo ?? this.pregnancyInfo,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class ProfileData {
  // Singleton instance
  static final ProfileData instance = ProfileData._internal();
  ProfileData._internal();

  // State reaktif dengan ValueNotifier
  final ValueNotifier<UserProfile> profileNotifier =
      ValueNotifier<UserProfile>(const UserProfile());

  UserProfile get profile => profileNotifier.value;

  /// Memperbarui informasi profil pengguna
  void updateProfile({
    required String name,
    required String age,
    required String phone,
    required String pregnancyInfo,
    String? status,
    File? profileImage,
  }) {
    profileNotifier.value = UserProfile(
      name: name.trim(),
      age: age.contains('Tahun') ? age.trim() : '${age.trim()} Tahun',
      phone: phone.trim(),
      pregnancyInfo: pregnancyInfo.trim(),
      status: status ?? profileNotifier.value.status,
      profileImage: profileImage ?? profileNotifier.value.profileImage,
    );
  }

  /// Reset profil pengguna ke kondisi bawaan
  void resetProfile() {
    profileNotifier.value = const UserProfile();
  }
}

