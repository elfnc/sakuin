import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFFF38181); // Coral
  static const Color secondary = Color(0xFF95E1D3); // Tosca
  static const Color softAccent = Color(0xFFFCE38A); // Soft Yellow
  static const Color softBackground = Color(0xFFEAFFD0); // Soft Mint

  // Neutral Colors
  static const Color background = Color(0xFFFFFDF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF374151); // Darker (Gray 700)
  static const Color textMuted = Color(0xFF4B5563); // Darker (Gray 600)

  // Semantic Colors
  static const Color income = Color(0xFF36C690);
  static const Color expense = Color(0xFFF38181); // Same as primary
  static const Color saving = Color(0xFF95E1D3); // Same as secondary
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF60A5FA);
}
