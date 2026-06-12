import 'package:flutter/material.dart';

class AppTheme {
  // Palette
  static const Color primary = Color(0xFF006B6B);
  static const Color primaryDark = Color(0xFF004D4D);
  static const Color primaryLight = Color(0xFF008F8F);
  static const Color accent = Color(0xFFE8A838);
  static const Color accentLight = Color(0xFFFFF3D6);
  static const Color surface = Color(0xFFF7F9F9);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A2E2E);
  static const Color textSecondary = Color(0xFF5A7A7A);
  static const Color danger = Color(0xFFD64C4C);
  static const Color success = Color(0xFF2E9E6B);
  static const Color divider = Color(0xFFE0EEEE);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          surface: surface,
        ),
        scaffoldBackgroundColor: surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 2,
          shadowColor: primary.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
          hintStyle:
              TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
        ),
        useMaterial3: true,
      );
}
