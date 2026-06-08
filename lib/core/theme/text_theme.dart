import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get textTheme {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      // Headings (Plus Jakarta Sans Bold)
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
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      
      // Body (Plus Jakarta Sans Regular/Medium)
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Brand / Logo font
  static TextStyle get brandLogo => GoogleFonts.baloo2(
    fontWeight: FontWeight.w800, // ExtraBold
  );

  // Angka uang font
  static TextStyle get moneyAmount => GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.w600, // SemiBold
  );
}
