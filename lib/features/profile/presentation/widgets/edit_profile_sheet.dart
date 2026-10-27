// lib/screens/profile/widgets/edit_profile_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:safebaby/core/theme/app_theme.dart';
import 'package:safebaby/features/profile/data/profile_data.dart';

class EditProfileSheet {
  static final ImagePicker _picker = ImagePicker();

  static void show(BuildContext context, UserProfile currentProfile) {
    final nameController = TextEditingController(text: currentProfile.name);
    final ageController = TextEditingController(
      text: currentProfile.age.replaceAll('Tahun', '').trim(),
    );
    final phoneController = TextEditingController(text: currentProfile.phone);
    final pregnancyController =
        TextEditingController(text: currentProfile.pregnancyInfo);

    File? newImage = currentProfile.profileImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final bottomInset = MediaQuery.of(modalContext).viewInsets.bottom;

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
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

                        // Header Modal
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF8F6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.accentTeal,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Profil Anda',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Perbarui data diri dan informasi kehamilan Anda.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Pilih / Ganti Foto Profil
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final XFile? picked = await _picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 85,
                              );
                              if (picked != null) {
                                setModalState(() {
                                  newImage = File(picked.path);
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A5F),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: newImage != null
                                        ? Image.file(
                                            newImage!,
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text(
                                              currentProfile.initials,
                                              style: GoogleFonts.inter(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: AppColors.accentTeal,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Input 1: Nama Lengkap
                        _buildModalInputLabel('Nama Lengkap'),
                        const SizedBox(height: 6),
                        _buildModalTextField(
                          controller: nameController,
                          hint: 'Siti Rahma',
                          prefixIcon: Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: 14),

                        // Input 2: Usia & Nomor Telepon
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildModalInputLabel('Usia'),
                                  const SizedBox(height: 6),
                                  _buildModalTextField(
                                    controller: ageController,
                                    hint: '27',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.cake_outlined,
                                    suffixText: 'Tahun',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildModalInputLabel('Nomor Telepon'),
                                  const SizedBox(height: 6),
                                  _buildModalTextField(
                                    controller: phoneController,
                                    hint: '08xxxxxxxxx',
                                    keyboardType: TextInputType.phone,
                                    prefixIcon: Icons.phone_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Input 3: Informasi Kehamilan
                        _buildModalInputLabel('Informasi Kehamilan'),
                        const SizedBox(height: 6),
                        _buildModalTextField(
                          controller: pregnancyController,
                          hint: 'Kehamilan pertama',
                          prefixIcon: Icons.child_care_rounded,
                        ),

                        const SizedBox(height: 22),

                        // Tombol Simpan Perubahan
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = nameController.text.trim();
                              final age = ageController.text.trim();
                              final phone = phoneController.text.trim();
                              final pregnancy =
                                  pregnancyController.text.trim();

                              if (name.isEmpty ||
                                  age.isEmpty ||
                                  phone.isEmpty ||
                                  pregnancy.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua data wajib diisi.'),
                                    backgroundColor: Color(0xFFEF4444),
                                  ),
                                );
                                return;
                              }

                              ProfileData.instance.updateProfile(
                                name: name,
                                age: age,
                                phone: phone,
                                pregnancyInfo: pregnancy,
                                profileImage: newImage,
                              );

                              Navigator.pop(ctx);

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
                                      Text(
                                        'Profil berhasil diperbarui!',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Simpan Perubahan',
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
                            onPressed: () => Navigator.pop(ctx),
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
            );
          },
        );
      },
    );
  }

  static Widget _buildModalInputLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDark,
      ),
    );
  }

  static Widget _buildModalTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 13,
          color: const Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: 18,
          color: const Color(0xFF94A3B8),
        ),
        suffixText: suffixText,
        suffixStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
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
          borderSide:
              const BorderSide(color: AppColors.accentTeal, width: 1.5),
        ),
      ),
    );
  }
}

