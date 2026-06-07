import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/glass_morphism.dart';

/// Style variants for GlassPanel.
enum GlassPanelStyle { panel, dark, navbar }

/// Glassmorphism surface widget used throughout Alpine Modernism UI.
///
/// Usage:
/// ```dart
/// GlassPanel(
///   borderRadius: BorderRadius.circular(16),
///   child: Padding(padding: EdgeInsets.all(16), child: ...),
/// )
/// ```
///
/// IMPORTANT: ClipRRect wraps BackdropFilter — required for rounded corners on iOS.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.style = GlassPanelStyle.panel,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding,
    this.sigmaBlur = 20.0,
  });

  final Widget child;
  final GlassPanelStyle style;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double sigmaBlur;

  @override
  Widget build(BuildContext context) {
    final decoration = switch (style) {
      GlassPanelStyle.panel => GlassMorphism.panel(borderRadius: borderRadius),
      GlassPanelStyle.dark => GlassMorphism.dark(borderRadius: borderRadius),
      GlassPanelStyle.navbar => GlassMorphism.navbar(),
    };

    Widget content = padding != null ? Padding(padding: padding!, child: child) : child;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaBlur, sigmaY: sigmaBlur),
        child: DecoratedBox(
          decoration: decoration,
          child: content,
        ),
      ),
    );
  }
}

/// Compact dark glass pill used in the camera UI for controls/badges.
class CameraUIPill extends StatelessWidget {
  const CameraUIPill({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      style: GlassPanelStyle.dark,
      borderRadius: BorderRadius.circular(100),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Round dark glass button for camera controls (flash, focus, close).
class CameraIconButton extends StatelessWidget {
  const CameraIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48.0,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GlassPanel(
        style: GlassPanelStyle.dark,
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}
