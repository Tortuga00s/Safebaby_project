// lib/core/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF0B2341); // Navy background
  static const Color accentTeal = Color(0xFF23B3A2); // Teal button & icon
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFF9CB1C9); // Subtitle text
  static const Color textFooter = Color(0xFF5F7C99); // Caption text
}

class AppTextStyles {
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 16,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle get footer => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFooter,
  );
}
