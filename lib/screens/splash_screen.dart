// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _footerFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController dengan durasi 1600ms (1.6 detik)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 1. Animasi Logo: Muncul (Fade) dan Membesar Halus (Scale) di awal (0% - 55%)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // 2. Animasi Judul "SafeBaby": Meluncur ke atas dan Fade-in (30% - 80%)
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.80, curve: Curves.easeOut),
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Animasi Footer Caption: Muncul lembut di akhir (60% - 100%)
    _footerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );

    // PENTING: Tunggu hingga frame pertama selesai digambar di layar HP,
    // lalu beri jeda 300ms agar animasi tidak 'termakan' oleh loading awal aplikasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    // Wajib dispose AnimationController untuk mencegah memory leak
    _controller.dispose();
    super.dispose();
  }

  void _replayAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    // Skala dinamis responsif berdasarkan lebar layar device
    final logoSize = (screenSize.width * 0.35).clamp(125.0, 160.0);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _replayAnimation, // Tap layar di mana saja untuk memutar ulang animasi
        child: Stack(
        children: [
          // 1. Layer Background: Garis kurva halus
          Positioned.fill(
            child: CustomPaint(painter: _BackgroundCurvePainter()),
          ),

          // 2. Layer Konten Tengah: True Center dengan Animasi Bertahap
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo Animasi: Scale & Fade
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Image.asset(
                      'assets/images/safebaby_emblem_teal.png',
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Judul "SafeBaby" Animasi: Slide-up & Fade
                FadeTransition(
                  opacity: _titleFadeAnimation,
                  child: SlideTransition(
                    position: _titleSlideAnimation,
                    child: Text(
                      'SafeBaby',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 36,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Layer Footer Animasi: Fade-in lembut di bagian bawah
          Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: FadeTransition(
                  opacity: _footerFadeAnimation,
                  child: Text(
                    'Pendamping kehamilan yang aman & terpercaya',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footer.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// CustomPainter untuk menggambar kurva melengkung halus di background
class _BackgroundCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Kurva atas kanan
    final pathTop = Path();
    pathTop.moveTo(size.width * 0.45, 0);
    pathTop.quadraticBezierTo(
      size.width * 0.52,
      size.height * 0.22,
      size.width,
      size.height * 0.26,
    );
    canvas.drawPath(pathTop, paint);

    // Kurva bawah kiri
    final pathBottom = Path();
    pathBottom.moveTo(0, size.height * 0.72);
    pathBottom.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.76,
      size.width * 0.42,
      size.height,
    );
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
