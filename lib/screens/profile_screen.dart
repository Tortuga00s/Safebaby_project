// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_theme.dart';
import '../core/profile_data.dart';
import 'onboarding_screen.dart';
import 'schedule_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onNavigateToDashboard;
  final VoidCallback? onNavigateToSchedule;
  final VoidCallback? onNavigateToHistory;

  const ProfileScreen({
    super.key,
    this.isEmbedded = false,
    this.onNavigateToDashboard,
    this.onNavigateToSchedule,
    this.onNavigateToHistory,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 3;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile>(
      valueListenable: ProfileData.instance.profileNotifier,
      builder: (context, profile, _) {
        final content = SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ─── 1. TOP BAR: JUDUL PROFIL ───
                _buildHeader(),

                const SizedBox(height: 24),

                // ─── 2. HERO CARD IDENTITAS PENGGUNA ───
                _buildHeroCard(profile),

                const SizedBox(height: 20),

                // ─── 3. CARD INFORMASI DETAIL PENGGUNA ───
                _buildInfoCard(profile),

                const SizedBox(height: 24),

                // ─── 4. TOMBOL EDIT PROFIL (MINT BUTTON) ───
                _buildEditProfileButton(profile),

                const SizedBox(height: 14),

                // ─── 5. TOMBOL KELUAR (SOFT RED BUTTON) ───
                _buildLogoutButton(),

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
    return Text(
      'Profil',
      style: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
        letterSpacing: -0.5,
      ),
    );
  }

  // ─── 2. WIDGET HERO CARD (NAVY BACKGROUND) ───
  Widget _buildHeroCard(UserProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Kotak Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: profile.profileImage != null
                  ? Image.file(
                      profile.profileImage!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        profile.initials,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Teks Nama & Sub-judul Kehamilan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.pregnancyInfo,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3. WIDGET CARD INFORMASI AKUN (USIA, TELEPON, STATUS) ───
  Widget _buildInfoCard(UserProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            label: 'Usia',
            value: profile.age,
          ),
          const Divider(height: 28, color: Color(0xFFF1F5F9), thickness: 1.0),
          _buildInfoRow(
            label: 'Nomor telepon',
            value: profile.phone,
          ),
          const Divider(height: 28, color: Color(0xFFF1F5F9), thickness: 1.0),
          _buildInfoRow(
            label: 'Status',
            value: profile.status,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  // ─── 4. WIDGET TOMBOL EDIT PROFIL ───
  Widget _buildEditProfileButton(UserProfile profile) {
    return Material(
      color: const Color(0xFFEAF8F6),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showEditProfileBottomSheet(profile),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryDark,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Edit Profil',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 5. WIDGET TOMBOL KELUAR (LOGOUT) ───
  Widget _buildLogoutButton() {
    return Material(
      color: const Color(0xFFFFF1F2),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _confirmLogout,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Keluar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 6. BOTTOM SHEET EDIT PROFIL INTERAKTIF & DINAMIS ───
  void _showEditProfileBottomSheet(UserProfile currentProfile) {
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

  Widget _buildModalInputLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _buildModalTextField({
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

  // ─── 7. DIALOG KONFIRMASI KELUAR ───
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar Akun?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari aplikasi SafeBaby? Anda dapat masuk kembali kapan saja.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          actions: [
            TextButton(
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Keluar',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── 8. BOTTOM NAVIGATION BAR (STANDALONE MODE) ───
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
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            );
          }
        } else if (index == 2) {
          if (widget.onNavigateToHistory != null) {
            widget.onNavigateToHistory!();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
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
}

