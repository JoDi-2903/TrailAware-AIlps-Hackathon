import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Glassmorphism `BoxDecoration` factory for Alpine Modernism surfaces.
/// Always wrap the decorated container in a `ClipRRect` + `BackdropFilter`
/// — see `GlassPanel` widget which handles that correctly.
abstract final class GlassMorphism {
  /// Light glass panel — primary card / overlay surface.
  /// rgba(255,255,255,0.7) with 1px white/40% border and ambient shadow.
  static BoxDecoration panel({
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(24)),
  }) {
    return BoxDecoration(
      color: const Color(0xB3FFFFFF), // rgba(255,255,255,0.7)
      borderRadius: borderRadius,
      border: Border.all(
        color: const Color(0x66FFFFFF), // rgba(255,255,255,0.4)
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000), // rgba(0,0,0,0.05)
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Dark camera UI panel — used for camera controls and badges.
  /// rgba(0,0,0,0.6) with 1px white/15% border.
  static BoxDecoration dark({
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(100)),
  }) {
    return BoxDecoration(
      color: AppColors.cameraUiPanel, // rgba(0,0,0,0.6)
      borderRadius: borderRadius,
      border: Border.all(
        color: const Color(0x26FFFFFF), // rgba(255,255,255,0.15)
        width: 1,
      ),
    );
  }

  /// Navigation bar glass — surface/80 + upward ambient shadow.
  static BoxDecoration navbar() {
    return BoxDecoration(
      color: const Color(0xCCF9FAF6), // surface at 80% opacity
      border: const Border(
        top: BorderSide(
          color: Color(0x66FFFFFF), // rgba(255,255,255,0.4)
          width: 1,
        ),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 20,
          offset: Offset(0, -4),
        ),
      ],
    );
  }

  /// Floating action element shadow — used on primary buttons.
  static List<BoxShadow> get fabShadow => const [
        BoxShadow(
          color: Color(0x261B4332), // rgba(27,67,50,0.15)
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];
}
