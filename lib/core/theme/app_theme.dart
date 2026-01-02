import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1565C0); // Trustworthy Blue
  static const Color actionGreen = Color(0xFF2E7D32); // Success/Action
  static const Color alertOrange = Color(0xFFEF6C00); // Warnings
  static const Color backgroundGrey = Color(0xFFF5F5F5); // Easy on eyes

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        secondary: actionGreen,
        surface: Colors.white,
        background: backgroundGrey,
      ),
      useMaterial3: true,
      
      // Universal Design Typography (Large & Readable)
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryBlue),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87), // Main text
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),

      // High Visibility Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60), // Large Touch Target
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      
      // Clear & Modern Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100], // Softer background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // More rounded
          borderSide: BorderSide.none, // Cleaner default look
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Spacious
        labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        floatingLabelStyle: const TextStyle(fontSize: 16, color: primaryBlue, fontWeight: FontWeight.w600),
      ),
      
      // cardTheme: const CardTheme(
      //   elevation: 4,
      //   color: Colors.white,
      //   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // ),
    );
  }
}
