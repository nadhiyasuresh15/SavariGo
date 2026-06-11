// constants/app_colors.dart
// SavariGo Brand Color Palette

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color yellow     = Color(0xFFFFCC00);
  static const Color black      = Color(0xFF1A1A1A);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color green      = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);

  // UI shades
  static const Color background = Color(0xFFF5F6FA);
  static const Color grey       = Color(0xFFE0E0E0);
  static const Color lightGrey  = Color(0xFFF5F5F5);
  static const Color textMuted  = Color(0xFF777777);
  static const Color textDark   = Color(0xFF333333);

  // Status colors
  static const Color red        = Color(0xFFD32F2F);
  static const Color orange     = Color(0xFFFF9500);
  static const Color pink       = Color(0xFFE91E63);
  static const Color blue       = Color(0xFF1565C0);
  static const Color lightPink  = Color(0xFFFCE4EC);

  // Gradient
  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFFCC00), Color(0xFFFFD740)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
