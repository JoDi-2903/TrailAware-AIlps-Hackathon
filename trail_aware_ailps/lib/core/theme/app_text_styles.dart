import 'package:flutter/material.dart';

/// Alpine Modernism typography tokens.
/// All sizes match the design spec (logical pixels = CSS px on standard density).
/// No custom font is declared — Flutter uses SF Pro automatically on iOS.
abstract final class AppTextStyles {
  /// 34px bold — primary headlines, success screen
  static const TextStyle displayLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 41 / 34, // line-height 41px
    letterSpacing: 0.37,
  );

  /// 24px semibold — section headers on tablet/desktop
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 30 / 24,
    letterSpacing: 0,
  );

  /// 20px semibold — section headers on mobile (most common)
  static const TextStyle headlineMediumMobile = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 25 / 20,
    letterSpacing: 0,
  );

  /// 17px regular — primary body text (iOS standard size)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 22 / 17,
    letterSpacing: -0.41, // iOS system body letter-spacing
  );

  /// 15px regular — secondary body, descriptions, captions
  static const TextStyle bodySmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 20 / 15,
    letterSpacing: 0,
  );

  /// 12px semibold uppercase — metadata labels, badge text, nav labels
  static const TextStyle labelCaps = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.72, // 0.06em × 12px
  );
}
