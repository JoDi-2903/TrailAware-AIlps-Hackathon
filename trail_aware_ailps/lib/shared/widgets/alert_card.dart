import 'package:flutter/material.dart';

import '../../core/models/hazard_report.dart';
import '../../core/models/hazard_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'glass_panel.dart';
import 'gradient_button.dart';
import 'priority_badge.dart';

/// Horizontally scrollable alert card for the Home screen "Nearby Alerts" row.
/// Matches trailaware_dashboard/code.html alert card design.
class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  final HazardReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GlassPanel(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority badge + distance
                    Row(
                      children: [
                        PriorityBadge(priority: report.priority),
                        const Spacer(),
                        Text(
                          report.distanceLabel,
                          style: AppTextStyles.labelCaps.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      report.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      report.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Details button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GradientButton(
                        label: 'Details',
                        onPressed: onTap,
                        outlined: true,
                        fullWidth: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 4px priority accent top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                decoration: BoxDecoration(gradient: report.priority.accentGradient),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
