import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/report_provider.dart';
import '../../core/models/hazard_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../shared/widgets/hazard_report_card.dart';
import '../../shared/widgets/kpi_card.dart';

/// Authority-facing dashboard for reviewing and acting on hazard reports.
/// Matches stitch_trailaware_alpine_ai/v2/trailaware_authority_dashboard_redux/code.html
class AuthorityDashboardScreen extends ConsumerWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final pendingCount = ref.watch(pendingCountProvider);
    final resolvedCount = ref.watch(resolvedCountProvider);

    return ColoredBox(
      color: AppColors.surface,
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Title section
                    Text(
                      'Authority Dashboard',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 6),
                    Text(
                      'Review and manage pending hazard reports from the field.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ).animate().fadeIn(delay: 50.ms),
                    const SizedBox(height: 20),

                    // KPI grid
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 110,
                            child: KpiCard(
                              label: 'PENDING ALERTS',
                              value: pendingCount,
                              icon: Icons.warning_amber_outlined,
                              iconColor: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 110,
                            child: KpiCard(
                              label: 'RESOLVED TODAY',
                              value: resolvedCount,
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().slideY(begin: 0.1, duration: 400.ms, delay: 100.ms).fadeIn(),
                    const SizedBox(height: 24),

                    // Reports list header
                    Text(
                      'Pending Hazard Reports',
                      style: AppTextStyles.headlineMediumMobile.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 12),

                    // Report cards
                    ...reports.asMap().entries.map((entry) {
                      final index = entry.key;
                      final report = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HazardReportCard(
                          report: report,
                          showAuthorityActions: true,
                          onTap: () => context.push('/report/${report.id}'),
                          onDetails: () => context.push('/report/${report.id}'),
                          onDispatch: () {
                            ref
                                .read(reportsProvider.notifier)
                                .updateStatus(report.id, ReportStatus.assigned);
                          },
                        ).animate().slideY(
                              begin: 0.1,
                              duration: 400.ms,
                              delay: Duration(milliseconds: 200 + index * 80),
                              curve: Curves.easeOutCubic,
                            ).fadeIn(),
                      );
                    }),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),

          // Fixed top bar (same as HomeScreen)
          _TopBar(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: GlassPanel(
        borderRadius: BorderRadius.zero,
        sigmaBlur: 16,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 20,
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'TrailAware AIlps',
                    style: AppTextStyles.headlineMediumMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
