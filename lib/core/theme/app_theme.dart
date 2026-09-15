import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryBlue = Color(0xFF2D82FA);
  static Color primaryPink = Color(0xFFF94C84);

  // Light Mode Colors
  static final Color _lightBg = Color(0xFFF7F7F9);
  static final Color _lightSurface = Colors.white;
  static final Color _lightTextPrimary = Color(0xFF1E1E1E);
  static final Color _lightTextSecondary = Color(0xFF6B6B6B);
  static final Color _lightDivider = Color(0xFFE0E0E0);

  // Dark Mode Colors
  static final Color _darkBg = Color(0xFF161618);
  static final Color _darkSurface = Color(0xFF25252A);
  static final Color _darkTextPrimary = Colors.white;
  static final Color _darkTextSecondary = Color(0xFF9E9E9E);
  static final Color _darkDivider = Color(0xFF333338);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBg,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryPink,
        surface: _lightSurface,
        surfaceContainerHighest: Color(0xFFF3F4F6),
        onSurface: _lightTextPrimary,
        onSurfaceVariant: _lightTextSecondary,
        outline: _lightDivider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBg,
        elevation: 0,
        iconTheme: IconThemeData(color: _lightTextPrimary),
        titleTextStyle: TextStyle(
          color: _lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: _lightTextSecondary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBg,
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryPink,
        surface: _darkSurface,
        surfaceContainerHighest: Color(0xFF1E1E22), // Un gris sutilmente distinto
        onSurface: _darkTextPrimary,
        onSurfaceVariant: _darkTextSecondary,
        outline: _darkDivider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBg,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkTextPrimary),
        titleTextStyle: TextStyle(
          color: _darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkBg,
        selectedItemColor: primaryBlue,
        unselectedItemColor: _darkTextSecondary,
      ),
    );
  }
}
