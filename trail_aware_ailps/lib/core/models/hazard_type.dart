import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Trail hazard categories reported by users.
enum HazardType {
  rockfall,
  landslide,
  fallenTree,
  flooding,
  erosion,
  bridgeDamage,
  other,
}

extension HazardTypeX on HazardType {
  String get displayName {
    switch (this) {
      case HazardType.rockfall:
        return 'Rockfall Blockage';
      case HazardType.landslide:
        return 'Landslide';
      case HazardType.fallenTree:
        return 'Fallen Tree';
      case HazardType.flooding:
        return 'Flooding';
      case HazardType.erosion:
        return 'Trail Erosion';
      case HazardType.bridgeDamage:
        return 'Bridge Damage';
      case HazardType.other:
        return 'Trail Obstruction';
    }
  }

  IconData get icon {
    switch (this) {
      case HazardType.rockfall:
        return Icons.landslide_outlined;
      case HazardType.landslide:
        return Icons.landslide_outlined;
      case HazardType.fallenTree:
        return Icons.park_outlined;
      case HazardType.flooding:
        return Icons.water_outlined;
      case HazardType.erosion:
        return Icons.terrain_outlined;
      case HazardType.bridgeDamage:
        return Icons.warning_amber_outlined;
      case HazardType.other:
        return Icons.report_problem_outlined;
    }
  }

  String get shortDescription {
    switch (this) {
      case HazardType.rockfall:
        return 'Rocks or boulders blocking the trail path';
      case HazardType.landslide:
        return 'Earth or debris slide covering the trail';
      case HazardType.fallenTree:
        return 'Tree fallen across or onto the trail';
      case HazardType.flooding:
        return 'Water overflow making the trail impassable';
      case HazardType.erosion:
        return 'Trail surface significantly eroded or damaged';
      case HazardType.bridgeDamage:
        return 'Bridge structure damaged or unsafe';
      case HazardType.other:
        return 'Other trail obstruction requiring attention';
    }
  }

  // Map API string values to enum
  static HazardType fromApiString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '_')) {
      case 'rockfall':
        return HazardType.rockfall;
      case 'landslide':
        return HazardType.landslide;
      case 'fallen_tree':
        return HazardType.fallenTree;
      case 'flooding':
        return HazardType.flooding;
      case 'erosion':
        return HazardType.erosion;
      case 'bridge_damage':
        return HazardType.bridgeDamage;
      default:
        return HazardType.other;
    }
  }
}

/// Report priority levels — drives visual hierarchy and routing urgency.
enum ReportPriority { critical, high, medium, low }

extension ReportPriorityX on ReportPriority {
  String get displayLabel {
    switch (this) {
      case ReportPriority.critical:
        return 'CRITICAL';
      case ReportPriority.high:
        return 'HIGH';
      case ReportPriority.medium:
        return 'MEDIUM';
      case ReportPriority.low:
        return 'LOW';
    }
  }

  Color get color {
    switch (this) {
      case ReportPriority.critical:
      case ReportPriority.high:
        return AppColors.error;
      case ReportPriority.medium:
        return AppColors.secondary;
      case ReportPriority.low:
        return AppColors.outline;
    }
  }

  Color get containerColor {
    switch (this) {
      case ReportPriority.critical:
      case ReportPriority.high:
        return AppColors.errorContainer;
      case ReportPriority.medium:
        return AppColors.secondaryContainer;
      case ReportPriority.low:
        return AppColors.surfaceContainerHigh;
    }
  }

  /// Gradient for the 4px top-border accent on cards.
  Gradient get accentGradient {
    switch (this) {
      case ReportPriority.critical:
      case ReportPriority.high:
        return const LinearGradient(
          colors: [Color(0xFFBA1A1A), Color(0xFFF97316)], // error → orange-400
        );
      case ReportPriority.medium:
        return LinearGradient(
          colors: [AppColors.secondary, AppColors.secondary],
        );
      case ReportPriority.low:
        return LinearGradient(
          colors: [AppColors.outlineVariant, AppColors.outlineVariant],
        );
    }
  }

  static ReportPriority fromApiString(String value) {
    switch (value.toLowerCase()) {
      case 'critical':
        return ReportPriority.critical;
      case 'high':
        return ReportPriority.high;
      case 'medium':
        return ReportPriority.medium;
      default:
        return ReportPriority.low;
    }
  }
}

/// Status lifecycle of a hazard report.
enum ReportStatus { pending, assigned, resolved }

extension ReportStatusX on ReportStatus {
  String get displayLabel {
    switch (this) {
      case ReportStatus.pending:
        return 'Pending';
      case ReportStatus.assigned:
        return 'Assigned';
      case ReportStatus.resolved:
        return 'Resolved';
    }
  }
}
