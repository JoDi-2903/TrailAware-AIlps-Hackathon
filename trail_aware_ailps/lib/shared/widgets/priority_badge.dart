import 'package:flutter/material.dart';

import '../../core/models/hazard_type.dart';
import '../../core/theme/app_text_styles.dart';

/// Pill badge displaying a report's priority with color-coded border and text.
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  final ReportPriority priority;

  /// Compact mode shows only icon + label, no padding.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = priority.color;
    final showWarning = priority == ReportPriority.critical ||
        priority == ReportPriority.high;

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority.containerColor.withValues(alpha: 0.25),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showWarning) ...[
            Icon(Icons.warning_amber_rounded, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            priority.displayLabel,
            style: AppTextStyles.labelCaps.copyWith(
              color: color,
              fontSize: 10,
              letterSpacing: 0.08 * 10,
            ),
          ),
        ],
      ),
    );
  }
}
