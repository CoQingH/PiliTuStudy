import 'package:flutter/material.dart';

class YTTheme {
  static const Color red = Color(0xFFFF0000);

  static ThemeData dark = _build(Brightness.dark);
  static ThemeData light = _build(Brightness.light);

  static ThemeData _build(Brightness b) {
    final d = b == Brightness.dark;
    final bg = d ? const Color(0xFF0F0F0F) : const Color(0xFFFFFFFF);
    final surf = d ? const Color(0xFF212121) : const Color(0xFFF2F2F2);
    final t1 = d ? const Color(0xFFF1F1F1) : const Color(0xFF0F0F0F);
    final t2 = d ? const Color(0xFFAAAAAA) : const Color(0xFF606060);
    final t3 = d ? const Color(0xFF717171) : const Color(0xFF909090);
    final div = d ? const Color(0xFF303030) : const Color(0xFFE5E5E5);

    return ThemeData(
      brightness: b,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: b, primary: red, secondary: red, surface: surf, onSurface: t1, outline: t2,
        error: red, onPrimary: Colors.white, onSecondary: Colors.white, onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(backgroundColor: bg, elevation: 0, scrolledUnderElevation: 0, foregroundColor: t1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg, selectedItemColor: t1, unselectedItemColor: t3,
        type: BottomNavigationBarType.fixed, elevation: 0,
      ),
      dividerColor: div,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: t1, fontSize: 16), bodyMedium: TextStyle(color: t2, fontSize: 14),
        bodySmall: TextStyle(color: t3, fontSize: 12), titleMedium: TextStyle(color: t1, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      iconTheme: IconThemeData(color: t1),
      snackBarTheme: SnackBarThemeData(backgroundColor: surf, contentTextStyle: TextStyle(color: t1)),
    );
  }
}

/// Quick access to theme colors from context
extension YTColors on BuildContext {
  Color get ytBg => Theme.of(this).scaffoldBackgroundColor;
  Color get ytSurf => Theme.of(this).colorScheme.surface;
  Color get ytT1 => Theme.of(this).colorScheme.onSurface;
  Color get ytT2 => Theme.of(this).colorScheme.outline;
  Color get ytT3 => Theme.of(this).textTheme.bodySmall!.color!;
  Color get ytDiv => Theme.of(this).dividerColor;
  Color get ytRed => YTTheme.red;
}
