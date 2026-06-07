import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';

/// Camera viewfinder reticle — 4 corner brackets + contained scan shimmer + center dot.
class CameraReticle extends StatelessWidget {
  const CameraReticle({
    super.key,
    this.hazardDetected = false,
    this.size = 256.0,
  });

  final bool hazardDetected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cornerColor = hazardDetected
        ? AppColors.error.withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.85);

    final scanColor = hazardDetected ? AppColors.error : Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Scan shimmer — thin line sweeping inside the box only
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        scanColor.withValues(alpha: 0.7),
                        scanColor.withValues(alpha: 0.9),
                        scanColor.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .moveY(
                      begin: 0,
                      end: size,
                      duration: 2200.ms,
                      curve: Curves.easeInOut,
                    )
                    .fadeIn(duration: 200.ms),
              ),
            ),
          ),

          // Corner brackets
          Positioned(
            top: 0, left: 0,
            child: _CornerBracket(color: cornerColor, corner: _Corner.topLeft, detected: hazardDetected),
          ),
          Positioned(
            top: 0, right: 0,
            child: _CornerBracket(color: cornerColor, corner: _Corner.topRight, detected: hazardDetected),
          ),
          Positioned(
            bottom: 0, left: 0,
            child: _CornerBracket(color: cornerColor, corner: _Corner.bottomLeft, detected: hazardDetected),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: _CornerBracket(color: cornerColor, corner: _Corner.bottomRight, detected: hazardDetected),
          ),

          // Center dot
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: scanColor.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({
    required this.color,
    required this.corner,
    required this.detected,
  });

  final Color color;
  final _Corner corner;
  final bool detected;

  @override
  Widget build(BuildContext context) {
    Widget bracket = SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _CornerPainter(color: color, corner: corner),
      ),
    );

    // When hazard detected, brackets pulse with a subtle scale breath
    if (detected) {
      bracket = bracket
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(
            begin: 1.0,
            end: 1.15,
            duration: 700.ms,
            curve: Curves.easeInOut,
          );
    }

    return bracket;
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({required this.color, required this.corner});

  final Color color;
  final _Corner corner;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const arm = 20.0;

    switch (corner) {
      case _Corner.topLeft:
        canvas.drawLine(Offset(0, arm), Offset.zero, paint);
        canvas.drawLine(Offset.zero, Offset(arm, 0), paint);
      case _Corner.topRight:
        canvas.drawLine(Offset(size.width - arm, 0), Offset(size.width, 0), paint);
        canvas.drawLine(Offset(size.width, 0), Offset(size.width, arm), paint);
      case _Corner.bottomLeft:
        canvas.drawLine(Offset(0, size.height - arm), Offset(0, size.height), paint);
        canvas.drawLine(Offset(0, size.height), Offset(arm, size.height), paint);
      case _Corner.bottomRight:
        canvas.drawLine(Offset(size.width - arm, size.height), Offset(size.width, size.height), paint);
        canvas.drawLine(Offset(size.width, size.height - arm), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.color != color || old.corner != corner;
}
