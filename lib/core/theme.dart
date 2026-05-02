import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFFF9F7F2); // Premium Creamy White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF2D5A27); // Deep Emerald Green
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFEEEEEE);

  // Themes
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        surface: background,
        primary: accent,
        onPrimary: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: textPrimary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: divider),
        ),
      ),
    );
  }

  // Custom Styles
  static BoxDecoration get translationBoxDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(4),
    border: const Border(left: BorderSide(color: accent, width: 4)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(10),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static TextStyle get arabicTextStyle => GoogleFonts.amiri(
    fontSize: 24,
    height: 1.8,
    color: textPrimary,
  );

  static TextStyle get translationTextStyle => GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    color: textPrimary,
  );
  
  static TextStyle get urduTextStyle => GoogleFonts.notoNastaliqUrdu(
    fontSize: 18,
    height: 1.8,
    color: textPrimary,
  );

  static TextStyle get hindiTextStyle => GoogleFonts.notoSansDevanagari(
    fontSize: 16,
    height: 1.5,
    color: textPrimary,
  );

  // Night Mode (PRD RE-01)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Dark Charcoal
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFDAA520), // Golden Amber for readability
        surface: Color(0xFF1A1A1A),
      ),
      // ... more dark theme details
    );
  }
}
