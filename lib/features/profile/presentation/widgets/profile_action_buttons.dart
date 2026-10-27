// lib/screens/profile/widgets/profile_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safebaby/core/theme/app_theme.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onLogoutPressed;

  const ProfileActionButtons({
    super.key,
    required this.onEditPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tombol Edit Profil (Mint Button)
        Material(
          color: const Color(0xFFEAF8F6),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onEditPressed,
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
        ),

        const SizedBox(height: 14),

        // Tombol Keluar (Soft Red Button)
        Material(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onLogoutPressed,
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
        ),
      ],
    );
  }
}

