import 'package:flutter/material.dart';

/// Alpine Modernism design system color tokens.
/// All values sourced from stitch_trailaware_alpine_ai/v2/alpine_modernism/DESIGN.md.
abstract final class AppColors {
  // --- Primary (Deep Alpine Green) ---
  static const Color primary = Color(0xFF012D1D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1B4332);
  static const Color onPrimaryContainer = Color(0xFF86AF99);
  static const Color primaryFixed = Color(0xFFC1ECD4);
  static const Color primaryFixedDim = Color(0xFFA5D0B9);
  static const Color onPrimaryFixed = Color(0xFF002114);
  static const Color onPrimaryFixedVariant = Color(0xFF274E3D);
  static const Color inversePrimary = Color(0xFFA5D0B9);

  // --- Secondary (Glacial Blue) ---
  static const Color secondary = Color(0xFF386471);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFBCEAF9);
  static const Color onSecondaryContainer = Color(0xFF3F6B78);
  static const Color secondaryFixed = Color(0xFFBCEAF9);
  static const Color secondaryFixedDim = Color(0xFFA1CEDC);
  static const Color onSecondaryFixed = Color(0xFF001F27);
  static const Color onSecondaryFixedVariant = Color(0xFF1E4C59);

  // --- Tertiary (Slate / Deep Navy) ---
  static const Color tertiary = Color(0xFF212536);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF373B4C);
  static const Color onTertiaryContainer = Color(0xFFA2A5BA);

  // --- Error / Alert ---
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // --- Surface & Background ---
  static const Color surface = Color(0xFFF9FAF6);
  static const Color surfaceBright = Color(0xFFF9FAF6);
  static const Color surfaceDim = Color(0xFFDADAD7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F1);
  static const Color surfaceContainer = Color(0xFFEEEEEB);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E5);
  static const Color surfaceContainerHighest = Color(0xFFE2E3E0);
  static const Color background = Color(0xFFF9FAF6);

  // --- On-Surface ---
  static const Color onSurface = Color(0xFF1A1C1A);
  static const Color onSurfaceVariant = Color(0xFF414844);
  static const Color inverseSurface = Color(0xFF2F312F);
  static const Color inverseOnSurface = Color(0xFFF0F1EE);

  // --- Outline ---
  static const Color outline = Color(0xFF717973);
  static const Color outlineVariant = Color(0xFFC1C8C2);

  // --- Surface tint ---
  static const Color surfaceTint = Color(0xFF3F6653);

  // --- Camera UI overlay (black/60) ---
  static const Color cameraUiPanel = Color(0x99000000);

  // --- Convenience: transparent ---
  static const Color transparent = Colors.transparent;
}
