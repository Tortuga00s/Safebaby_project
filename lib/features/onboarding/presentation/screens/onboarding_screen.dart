// lib/screens/onboarding_screen.dart
import 'package:safebaby/features/profile/presentation/screens/create_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';

class OnboardingItem {
  final String step;
  final String title;
  final String description;
  final IconData icon;

  const OnboardingItem({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      step: '01 / 03',
      title: 'Kelola Jadwal Kontrol',
      description:
          'Simpan jadwal pemeriksaan kehamilan dengan mudah dan teratur.',
      icon: Icons.calendar_month_outlined,
    ),
    OnboardingItem(
      step: '02 / 03',
      title: 'Pengingat Tepat Waktu',
      description: 'Dapatkan notifikasi 3 hari sebelum jadwal kontrol.',
      icon: Icons.notifications_none_rounded,
    ),
    OnboardingItem(
      step: '03 / 03',
      title: 'Simpan Riwayat Pemeriksaan',
      description: 'Catat dan lihat kembali informasi pemeriksaan sebelumnya.',
      icon: Icons.history_rounded,
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreateProfileScreen()),
      );
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(
      _items.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    // Skala tinggi area kartu ilustrasi yang proporsional
    final cardHeight = (screenHeight * 0.36).clamp(280.0, 330.0);
    final isLastPage = _currentIndex == _items.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // ─── 1. TOP BAR ───
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    // Logo Emblem Teal & Nama Brand
                    Image.asset(
                      'assets/images/safebaby_emblem_teal.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SafeBaby',
                      style: GoogleFonts.inter(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),

                    // Tombol Lewati: Menghilang halus (Fade Out) di halaman terakhir
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isLastPage ? 0.0 : 1.0,
                      child: IgnorePointer(
                        ignoring: isLastPage,
                        child: TextButton(
                          onPressed: _skipToLast,
                          child: Text(
                            'Lewati',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── 2. SLIDER KONTEN DENGAN GAP ANTAR HALAMAN & ANIMASI ───
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isCurrent = index == _currentIndex;

                    return Padding(
                      // GAP horizontal antar halaman agar saat swipe kartu tidak menempel
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kartu Ilustrasi dengan Animasi Scale Halus saat Aktif
                          AnimatedScale(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            scale: isCurrent ? 1.0 : 0.94,
                            child: SizedBox(
                              height: cardHeight,
                              width: double.infinity,
                              child: _buildIllustrationCard(item.icon, isCurrent),
                            ),
                          ),

                          // Gap terukur antara gambar dan teks
                          const SizedBox(height: 28),

                          // Teks Step: "01 / 03"
                          Text(
                            item.step,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentTeal,
                              letterSpacing: 0.6,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Judul Slide (Tinggi terkunci agar stabil)
                          SizedBox(
                            height: 68,
                            child: Text(
                              item.title,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Deskripsi Slide (Tinggi terkunci agar stabil)
                          SizedBox(
                            height: 48,
                            child: Text(
                              item.description,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                                height: 1.5,
                              ),
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ─── 3. BOTTOM BAR (ANIMATED INDICATOR & NEXT BUTTON) ───
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 8.0, left: 6.0, right: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dot Page Indicator dengan Animasi Kapsul
                    Row(
                      children: List.generate(
                        _items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          margin: const EdgeInsets.only(right: 6.0),
                          width: _currentIndex == index ? 26.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.accentTeal
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Bulat Navigasi dengan Animasi Icon Morphs
                    InkWell(
                      onTap: _nextPage,
                      borderRadius: BorderRadius.circular(28),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isLastPage ? AppColors.accentTeal : AppColors.primaryDark,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isLastPage
                                      ? AppColors.accentTeal
                                      : AppColors.primaryDark)
                                  .withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isLastPage
                                ? Icons.check_rounded
                                : Icons.arrow_forward_ios_rounded,
                            key: ValueKey<bool>(isLastPage),
                            color: Colors.white,
                            size: isLastPage ? 24 : 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget Ilustrasi: Kotak Mint + Lingkaran Riak + Kartu Putih Melayang Beranimasi
  Widget _buildIllustrationCard(IconData icon, bool isActive) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran Riak Luar
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentTeal.withValues(alpha: 0.12),
                width: 1.2,
              ),
            ),
          ),
          // Lingkaran Riak Dalam
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentTeal.withValues(alpha: 0.18),
                width: 1.2,
              ),
            ),
          ),

          // Kartu Putih Melayang dengan Bayangan Halus
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 195,
            height: 220,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0B2341).withValues(
                    alpha: isActive ? 0.10 : 0.05,
                  ),
                  blurRadius: isActive ? 24 : 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon dalam kotak mint rounded
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.accentTeal, size: 28),
                ),

                const SizedBox(height: 18),

                // Skeleton Bar 1
                Container(
                  height: 7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE5EE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(height: 8),

                // Skeleton Bar 2
                Container(
                  height: 7,
                  width: 95,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE5EE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const Spacer(),

                // Chip: Tersimpan aman
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        color: AppColors.accentTeal,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tersimpan aman',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
