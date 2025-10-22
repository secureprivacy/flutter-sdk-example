import 'package:flutter/material.dart';

class SPAppColors {
  const SPAppColors._();

  // Primary color
  static const primary = Color(0xFF007A6D); // ARGB(255,0,122,109)

  // Primary variant (slightly darker)
  static const primaryVariant = Color(0xFF005E54);

  // Secondary color
  static const secondary = Color(0xFF00BFA5);

  // Secondary variant
  static const secondaryVariant = Color(0xFF008E77);

  // Background and surface
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);

  // Error
  static const error = Color(0xFFB00020);

  // On colors (for text/icons on top of the above colors)
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF00332F);
  static const onBackground = Color(0xFF000000);
  static const onSurface = Color(0xFF000000);
  static const onError = Color(0xFFFFFFFF);

  // MaterialColor for primary swatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF007A6D,
    <int, Color>{
      50: Color(0xFFE0F2F1),
      100: Color(0xFFB2DFDB),
      200: Color(0xFF80CBC4),
      300: Color(0xFF4DB6AC),
      400: Color(0xFF26A69A),
      500: Color(0xFF007A6D), // Primary
      600: Color(0xFF00897B),
      700: Color(0xFF00796B),
      800: Color(0xFF00695C),
      900: Color(0xFF004D40),
    },
  );
}
