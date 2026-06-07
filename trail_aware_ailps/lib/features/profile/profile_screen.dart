import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/report_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/glass_panel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final totalImpact = reports.length * 10;

    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryFixed, width: 3),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Jonathan',
                style: AppTextStyles.headlineMediumMobile.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Administrator',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: GlassPanel(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '${reports.length}',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'REPORTS',
                              style: AppTextStyles.labelCaps.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassPanel(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '+$totalImpact',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'IMPACT PTS',
                              style: AppTextStyles.labelCaps.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // About card
              GlassPanel(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.terrain_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TrailAware AIlps',
                                style: AppTextStyles.headlineMediumMobile
                                    .copyWith(color: AppColors.onSurface),
                              ),
                              Text(
                                'Version 1.0.0',
                                style: AppTextStyles.labelCaps.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AI-powered trail hazard reporting for the Alpine community. '
                        'Report rockfalls, landslides, and other trail obstructions — '
                        'your submission is instantly geo-routed to the responsible '
                        'authority and shared with hiking apps like Komoot.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.outlineVariant),
                      const SizedBox(height: 12),
                      // Info rows
                      _AboutRow(
                        icon: Icons.emoji_events_outlined,
                        color: AppColors.primary,
                        label: 'EUSALP Alpine AI-Hackathon 2026',
                        sublabel: '"Destination Resilience" Challenge',
                      ),
                      const SizedBox(height: 10),
                      _AboutRow(
                        icon: Icons.api_outlined,
                        color: AppColors.secondary,
                        label: 'Open Trail Data API',
                        sublabel: 'Komoot, OpenStreetMap & partner apps',
                      ),
                      const SizedBox(height: 10),
                      _AboutRow(
                        icon: Icons.smart_toy_outlined,
                        color: AppColors.secondary,
                        label: 'Powered by Claude AI',
                        sublabel: 'Hazard classification & priority scoring',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'TrailAware AIlps v1.0.0',
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.outlineVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.sublabel,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sublabel,
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
