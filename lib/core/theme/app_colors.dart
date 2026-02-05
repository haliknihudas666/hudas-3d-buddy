import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors - Vibrant Orange/Amber (3D Printing theme)
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFFF8A5B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF1A1A1A);

  // Secondary Colors - Deep Purple
  static const Color secondary = Color(0xFF6C63FF);
  static const Color secondaryDark = Color(0xFF8B85FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF1A1A1A);

  // Tertiary Colors - Teal
  static const Color tertiary = Color(0xFF00BFA6);
  static const Color tertiaryDark = Color(0xFF5DF2D6);

  // Error Colors
  static const Color error = Color(0xFFDC3545);
  static const Color errorDark = Color(0xFFFF6B6B);
  static const Color onError = Color(0xFFFFFFFF);

  // Success Colors
  static const Color success = Color(0xFF28A745);
  static const Color successDark = Color(0xFF4ADE80);

  // Warning Colors
  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFFD93D);

  // Light Theme Surface Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F3F4);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF6C757D);
  static const Color lightOutline = Color(0xFFDEE2E6);

  // Dark Theme Surface Colors
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);
  static const Color darkOnBackground = Color(0xFFE6EDF3);
  static const Color darkOnSurface = Color(0xFFE6EDF3);
  static const Color darkOnSurfaceVariant = Color(0xFF8B949E);
  static const Color darkOutline = Color(0xFF30363D);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF8A5B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B85FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF5DF2D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Light color scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: Color(0xFFFFE0D6),
    onPrimaryContainer: Color(0xFF3D1500),
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: Color(0xFFE8E6FF),
    onSecondaryContainer: Color(0xFF1A1A5E),
    tertiary: tertiary,
    onTertiary: onSecondary,
    tertiaryContainer: Color(0xFFD4FFF6),
    onTertiaryContainer: Color(0xFF003D36),
    error: error,
    onError: onError,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: lightSurface,
    onSurface: lightOnSurface,
    surfaceContainerHighest: lightSurfaceVariant,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightOutline,
    outlineVariant: Color(0xFFE9ECEF),
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: darkSurface,
    onInverseSurface: darkOnSurface,
    inversePrimary: primaryDark,
  );

  /// Dark color scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    primaryContainer: Color(0xFF5C2A00),
    onPrimaryContainer: Color(0xFFFFDBCB),
    secondary: secondaryDark,
    onSecondary: onSecondaryDark,
    secondaryContainer: Color(0xFF3D3A8F),
    onSecondaryContainer: Color(0xFFE8E6FF),
    tertiary: tertiaryDark,
    onTertiary: onSecondaryDark,
    tertiaryContainer: Color(0xFF006B5E),
    onTertiaryContainer: Color(0xFFD4FFF6),
    error: errorDark,
    onError: Color(0xFF1A1A1A),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: darkSurface,
    onSurface: darkOnSurface,
    surfaceContainerHighest: darkSurfaceVariant,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
    outlineVariant: Color(0xFF444C56),
    shadow: Colors.black54,
    scrim: Colors.black87,
    inverseSurface: lightSurface,
    onInverseSurface: lightOnSurface,
    inversePrimary: primary,
  );
}
