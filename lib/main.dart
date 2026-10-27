// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safebaby/features/onboarding/presentation/screens/splash_screen.dart';

void main() {
  runApp(const SafeBabyApp());
}

class SafeBabyApp extends StatelessWidget {
  const SafeBabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeBaby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: const SplashScreen(),
    );
  }
}
