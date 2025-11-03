import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF5EFE6), // Arena suave
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7B8C5F),
      primary: const Color(0xFF7B8C5F), // Verde olivo suave
      secondary: const Color(0xFFD9C6A5), // Madera clara
      surface: const Color(0xFFFFFDF8), // Blanco cálido
      onPrimary: Colors.white,
      onSurface: const Color(0xFF3E3B32), // Marrón profundo (texto)
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5EFE6),
      foregroundColor: Color(0xFF3E3B32),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B8C5F),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFDF8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD9C6A5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF7B8C5F)),
      ),
      labelStyle: const TextStyle(color: Color(0xFF3E3B32)),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF3E3B32)),
      titleMedium: TextStyle(
        color: Color(0xFF3E3B32),
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF5A6B3F),
      secondary: const Color(0xFFBFAE94),
      surface: const Color(0xFF2E2B25),
      onPrimary: Colors.white,
      onSurface: const Color(0xFFEFEDE8),
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1C18),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E2B25),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5A6B3F),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
