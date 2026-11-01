import 'package:flutter/material.dart';

abstract final class HoobColors {
  static const ink = Color(0xFF222325);
  static const lime = Color(0xFFE1F073);
  static const canvas = Color(0xFFFBFBFB);
  static const muted = Color(0xFF707173);
  static const line = Color(0xFFEDEDEE);
  static const yellow = Color(0xFFFFC73B);
  static const green = Color(0xFFE0F4E5);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: HoobColors.ink,
    primary: HoobColors.ink,
    secondary: HoobColors.lime,
    secondaryContainer: HoobColors.lime,
    onSecondaryContainer: HoobColors.ink,
    surface: Colors.white,
  );
  return ThemeData(
    colorScheme: scheme,
    fontFamily: 'RedHatDisplay',
    scaffoldBackgroundColor: HoobColors.canvas,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 38,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: -.6,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, height: 1.55),
      bodySmall: TextStyle(fontSize: 12, height: 1.5, color: HoobColors.muted),
    ).apply(bodyColor: HoobColors.ink, displayColor: HoobColors.ink),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: HoobColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF6F6F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: HoobColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: HoobColors.ink),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: HoobColors.ink,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        textStyle: const TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        foregroundColor: HoobColors.ink,
        side: const BorderSide(color: HoobColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: HoobColors.lime,
      side: const BorderSide(color: HoobColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    dividerTheme: const DividerThemeData(color: HoobColors.line, thickness: 1),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: HoobColors.lime,
      height: 72,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
