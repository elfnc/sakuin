import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get textTheme {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
