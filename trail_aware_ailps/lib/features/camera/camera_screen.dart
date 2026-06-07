import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/camera_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/glass_panel.dart';
import 'widgets/camera_reticle.dart';

/// Full-screen camera screen for AI hazard detection.
/// Matches stitch_trailaware_alpine_ai/v2/trailaware_ai_reporter_refined/code.html
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initCamera();
    });
  }

  @override
  void deactivate() {
    // Do NOT manually dispose here — autoDispose handles cleanup automatically.
    // Calling notifier.dispose() twice (here + autoDispose) crashes the app.
    super.deactivate();
  }

  Future<void> _onCapture() async {
    HapticFeedback.mediumImpact();
    final report = await ref.read(cameraProvider.notifier).captureAndAnalyze();
    // Check mounted BEFORE any context access — the notifier may have been
    // disposed during the await if the user navigated away manually.
    if (!mounted) return;
    if (report != null) {
      // Navigate immediately; do not read any provider after this point.
      context.pushReplacement('/success', extra: report);
    }
  }

  @override
  Widget build(BuildContext context) {
    final camState = ref.watch(cameraProvider);

    return PopScope(
      // No manual dispose needed — autoDispose cleans up when the route is removed.
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Camera preview, mock hazard image, or dark placeholder
            if (camState.isInitialized && camState.controller != null && !camState.isMockMode)
              CameraPreview(camState.controller!)
            else if (camState.isMockMode)
              Image.asset(
                'assets/images/mock_hazard.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Container(color: Colors.black),

            // 2. Gradient overlay
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.6, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Subtle reticle pulse glow — replaces full-screen red sweep
            //    A soft white radial glow behind the reticle breathes in/out.
            if (camState.isInitialized)
              IgnorePointer(
                child: Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .custom(
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                        builder: (context, value, child) => Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: (camState.hazardDetected
                                        ? AppColors.error
                                        : Colors.white)
                                    .withValues(alpha: 0.06 + value * 0.10),
                                blurRadius: 24 + value * 20,
                                spreadRadius: value * 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
              ),

            // 4. Camera reticle (centered)
            Center(
              child: CameraReticle(
                hazardDetected: camState.hazardDetected,
              ),
            ),

            // 5. Top navigation bar
            _TopBar(onClose: () => context.pop()),

            // 6. Bottom status + controls
            _BottomSection(
              camState: camState,
              onCapture: _onCapture,
              onFlash: () => ref.read(cameraProvider.notifier).toggleFlash(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Close button
              CameraIconButton(
                icon: Icons.close,
                onPressed: onClose,
              ),
              const Spacer(),
              // "AI Analysis Active" pill
              CameraUIPill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 800.ms),
                    const SizedBox(width: 6),
                    Text(
                      'AI ANALYSIS ACTIVE',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48), // balance for close button
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom section
// ---------------------------------------------------------------------------

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.camState,
    required this.onCapture,
    required this.onFlash,
  });

  final CameraState camState;
  final VoidCallback onCapture;
  final VoidCallback onFlash;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status bar
            _StatusBar(camState: camState),
            const SizedBox(height: 16),
            // Controls row
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flash
                  CameraIconButton(
                    icon: camState.flashEnabled
                        ? Icons.flash_on
                        : Icons.flash_off_outlined,
                    onPressed: onFlash,
                    iconColor: camState.flashEnabled
                        ? AppColors.primaryFixed
                        : Colors.white,
                  ),
                  // Capture button
                  _CaptureButton(
                    isAnalyzing: camState.isAnalyzing,
                    onTap: onCapture,
                  ),
                  // Focus
                  CameraIconButton(
                    icon: Icons.center_focus_strong_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.camState});
  final CameraState camState;

  @override
  Widget build(BuildContext context) {
    final detected = camState.hazardDetected;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: detected
                ? AppColors.error.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ANALYSIS STATUS',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  camState.statusMessage,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: detected ? AppColors.errorContainer : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Status icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: detected
                  ? Icon(
                      Icons.warning_amber_rounded,
                      key: const ValueKey('warning'),
                      color: AppColors.error,
                      size: 28,
                    )
                  : Icon(
                      Icons.radar,
                      key: const ValueKey('radar'),
                      color: AppColors.primaryFixed,
                      size: 28,
                    )
                      .animate(onPlay: (c) => c.repeat())
                      .rotate(duration: 2000.ms, curve: Curves.linear),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureButton extends StatefulWidget {
  const _CaptureButton({required this.isAnalyzing, required this.onTap});
  final bool isAnalyzing;
  final VoidCallback onTap;

  @override
  State<_CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<_CaptureButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.isAnalyzing) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 3),
          ),
          child: Center(
            child: widget.isAnalyzing
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryFixed,
                      strokeWidth: 2.5,
                    ),
                  )
                : Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
