import 'package:flutter/material.dart';

/// YouTube-style dark theme
class YTTheme {
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF212121);
  static const Color surfaceLight = Color(0xFF272727);
  static const Color surfaceHighlight = Color(0xFF303030);
  static const Color red = Color(0xFFFF0000);
  static const Color redLight = Color(0xFFFF3333);
  static const Color textPrimary = Color(0xFFF1F1F1);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textTertiary = Color(0xFF717171);
  static const Color divider = Color(0xFF303030);
  static const Color chipBg = Color(0xFF272727);
  static const Color chipSelected = Color(0xFFFFFFFF);
  static const Color bottomNavBg = Color(0xFF0F0F0F);
  static const Color bottomNavSelected = Color(0xFFFFFFFF);
  static const Color bottomNavUnselected = Color(0xFF717171);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      surface: surface,
      primary: red,
      secondary: red,
      onSurface: textPrimary,
      outline: textSecondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bottomNavBg,
      selectedItemColor: bottomNavSelected,
      unselectedItemColor: bottomNavUnselected,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: chipBg,
      selectedColor: chipSelected,
      labelStyle: const TextStyle(color: textPrimary),
      secondaryLabelStyle: const TextStyle(color: background),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerColor: divider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      bodySmall: TextStyle(color: textTertiary, fontSize: 12),
      titleMedium: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    iconTheme: const IconThemeData(color: textPrimary),
  );
}
