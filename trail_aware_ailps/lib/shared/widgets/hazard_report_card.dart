import 'package:flutter/material.dart';

import '../../core/models/hazard_report.dart';
import '../../core/models/hazard_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'glass_panel.dart';
import 'gradient_button.dart';
import 'priority_badge.dart';

/// Full-width list card used in the Authority Dashboard.
/// Shows a summary of a hazard report with optional authority action buttons.
class HazardReportCard extends StatelessWidget {
  const HazardReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.showAuthorityActions = false,
    this.onDispatch,
    this.onDetails,
  });

  final HazardReport report;
  final VoidCallback onTap;
  final bool showAuthorityActions;
  final VoidCallback? onDispatch;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: GlassPanel(
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: priority + time
                    Row(
                      children: [
                        PriorityBadge(priority: report.priority),
                        const SizedBox(width: 8),
                        Text(
                          report.timeAgo,
                          style: AppTextStyles.labelCaps.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          report.type.icon,
                          size: 18,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      report.title,
                      style: AppTextStyles.headlineMediumMobile.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            report.locationLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Description preview
                    Text(
                      report.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Proposed solution box
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 14, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              report.proposedSolution,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Authority action buttons
                    if (showAuthorityActions) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              label: report.priority == ReportPriority.critical ||
                                      report.priority == ReportPriority.high
                                  ? 'Dispatch Team'
                                  : 'Mark as Safe',
                              onPressed: onDispatch,
                              leadingIcon: report.priority ==
                                          ReportPriority.critical ||
                                      report.priority == ReportPriority.high
                                  ? Icons.local_shipping_outlined
                                  : Icons.check_circle_outline,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GradientButton(
                              label: 'Details',
                              onPressed: onDetails,
                              outlined: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // 4px top accent gradient bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 4,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                decoration:
                    BoxDecoration(gradient: report.priority.accentGradient),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
