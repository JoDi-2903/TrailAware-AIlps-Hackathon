import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/hazard_report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../shared/widgets/gradient_button.dart';

/// Feel-good confirmation screen shown after submitting a hazard report.
/// Matches stitch_trailaware_alpine_ai/v2/trailaware_success/code.html
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, this.report});

  final HazardReport? report;

  @override
  Widget build(BuildContext context) {
    final authorityName =
        report?.authorityName ?? 'the responsible authority';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

                  // Success icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Headline
                  Text(
                    'Thank you for your\ncontribution!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtext
                  Text(
                    'Your report helps keep the Alpine community safe. '
                    'We have notified $authorityName and '
                    'shared the data with Komoot for hiker rerouting.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Impact score bento card
                  GlassPanel(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryFixed,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.onSecondaryFixed,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Impact Score',
                                style: AppTextStyles.headlineMediumMobile
                                    .copyWith(color: AppColors.onSurface),
                              ),
                              Text(
                                'Community Contribution',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '+${report?.impactScore ?? 10}',
                                style: AppTextStyles.displayLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'POINTS',
                                style: AppTextStyles.labelCaps.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Back to Home button
                  GradientButton(
                    label: 'Back to Home',
                    onPressed: () => context.go('/'),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          )
              // Single unified entrance — starts after the 400ms page fade completes.
              .animate()
              .slideY(
                begin: 0.06,
                end: 0,
                delay: 300.ms,
                duration: 500.ms,
                curve: const Cubic(0.16, 1, 0.3, 1),
              )
              .fadeIn(delay: 300.ms, duration: 400.ms),
    );
  }
}
