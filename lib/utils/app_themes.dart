import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AbColors.primary,
    scaffoldBackgroundColor: AbColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AbColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AbColors.secondary,
    ),
    colorScheme: const ColorScheme.light(
      primary: AbColors.primary,
      secondary: AbColors.secondary,
      background: AbColors.backgroundLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AbColors.textLight),
      bodyMedium: TextStyle(color: AbColors.textLight),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AbColors.primary,
    scaffoldBackgroundColor: AbColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AbColors.primary,
      foregroundColor: AbColors.textDark,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AbColors.secondary,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AbColors.primary,
      secondary: AbColors.secondary,
      background: AbColors.backgroundDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AbColors.textDark),
      bodyMedium: TextStyle(color: AbColors.textDark),
    ),
  );
}
