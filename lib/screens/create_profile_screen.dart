// lib/screens/create_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_theme.dart';
import '../core/profile_data.dart';
import 'dashboard_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  // Input controller dalam keadaan kosong (nilai contoh dijadikan placeholder / hintText)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pregnancyController = TextEditingController();

  // File foto profil yang dipilih oleh user
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Update avatar inisial secara otomatis saat user mengetik nama
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _pregnancyController.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan inisial dari nama yang diketik (default: 'SR')
  String _getInitials() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return 'SR';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Fungsi validasi data profil sebelum masuk ke Dashboard
  void _saveProfile() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final phone = _phoneController.text.trim();
    final pregnancy = _pregnancyController.text.trim();

    // Validasi form: semua kolom wajib diisi
    if (name.isEmpty) {
      _showWarningSnackBar('Mohon isi nama lengkap Anda.');
      return;
    }
    if (age.isEmpty) {
      _showWarningSnackBar('Mohon isi usia Anda.');
      return;
    }
    if (phone.isEmpty) {
      _showWarningSnackBar('Mohon isi nomor telepon Anda.');
      return;
    }
    if (pregnancy.isEmpty) {
      _showWarningSnackBar('Mohon isi informasi kehamilan Anda.');
      return;
    }

    // Simpan ke state global ProfileData
    ProfileData.instance.updateProfile(
      name: name,
      age: age.contains('Tahun') ? age : '$age Tahun',
      phone: phone,
      pregnancyInfo: pregnancy,
      profileImage: _profileImage,
    );

    // Ekstrak nama depan secara dinamis & rapi untuk greeting di Dashboard
    final firstName = name.split(RegExp(r'\s+')).first;
    final formattedName = firstName.isNotEmpty
        ? firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()
        : 'Siti';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userName: formattedName,
        ),
      ),
    );
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Fungsi bottom sheet untuk memilih foto dari Galeri atau Kamera
  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Foto Profil',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.accentTeal,
                ),
                title: Text(
                  'Pilih dari Galeri',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        _profileImage = File(image.path);
                      });
                    }
                  } catch (e) {
                    debugPrint('Error pick gallery: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal memilih foto: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.accentTeal,
                ),
                title: Text(
                  'Ambil dari Kamera',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        _profileImage = File(image.path);
                      });
                    }
                  } catch (e) {
                    debugPrint('Error pick camera: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengambil foto: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ─── 1. HEADER (JUDUL & SUBTITLE) ───
              Text(
                'Buat Profil',
                style: GoogleFonts.inter(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi informasi untuk pengalaman yang lebih personal.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // ─── 2. AVATAR PROFILE DENGAN PILIH FOTO ───
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Stack(
                        children: [
                          // Kotak Avatar Rounded Mint / Foto yang Dipilih
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F5F3),
                              borderRadius: BorderRadius.circular(28),
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: _profileImage == null
                                ? Text(
                                    _getInitials(),
                                    style: GoogleFonts.inter(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  )
                                : null,
                          ),

                          // Badge Bulat Navy dengan Icon Edit Pensil
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Teks Link Tambah / Ubah Foto
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Text(
                        _profileImage != null
                            ? 'Ganti foto profil'
                            : 'Tambahkan foto profil',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ─── 3. FORM INPUT SECTION DENGAN PLACEHOLDER / HINTTEXT ───
              // Input 1: Nama Lengkap
              _buildInputField(
                label: 'Nama lengkap',
                controller: _nameController,
                hintText: 'Siti Rahma',
              ),

              const SizedBox(height: 16),

              // Input 2 & 3: Usia & Nomor Telepon (Berdampingan 50:50)
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Usia',
                      controller: _ageController,
                      hintText: '27 Tahun',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildInputField(
                      label: 'Nomor telepon',
                      controller: _phoneController,
                      hintText: '08xxxxxxxxx',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Input 4: Informasi Kehamilan
              _buildInputField(
                label: 'Informasi kehamilan',
                controller: _pregnancyController,
                hintText: 'Kehamilan Pertama',
              ),

              const SizedBox(height: 36),

              // ─── 4. BOTTOM ACTION (TOMBOL SIMPAN & FOOTER) ───
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Simpan Profil',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Footer Keamanan Data
              Center(
                child: Text(
                  'Data Anda disimpan secara privat dan aman.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Component untuk Input Field dengan HintText / Placeholder
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Warna latar abu-abu lembut
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8), // Warna abu-abu placeholder
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
