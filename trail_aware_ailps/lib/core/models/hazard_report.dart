import 'package:uuid/uuid.dart';
import 'hazard_type.dart';

/// A single trail hazard report submitted by a user.
/// Plain Dart class (no Freezed) to avoid codegen complexity at hackathon speed.
class HazardReport {
  HazardReport({
    String? id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    required this.proposedSolution,
    required this.latitude,
    required this.longitude,
    this.elevationMeters,
    this.imagePath,
    DateTime? reportedAt,
    this.reporterName = 'Anonymous Hiker',
    required this.authorityId,
    required this.authorityName,
    this.status = ReportStatus.pending,
    this.impactScore = 10,
  })  : id = id ?? const Uuid().v4(),
        reportedAt = reportedAt ?? DateTime.now();

  final String id;
  final HazardType type;
  final ReportPriority priority;
  final String title;
  final String description;
  final String proposedSolution;
  final double latitude;
  final double longitude;
  final double? elevationMeters;

  /// Local file path to captured image (null when using mock data).
  final String? imagePath;

  final DateTime reportedAt;
  final String reporterName;

  /// ID of the responsible authority, resolved by geo-routing.
  final String authorityId;
  final String authorityName;

  ReportStatus status;

  /// Points awarded to the user for this report — always 10 for hackathon.
  final int impactScore;

  /// Returns a copy with updated status.
  HazardReport copyWith({ReportStatus? status}) {
    return HazardReport(
      id: id,
      type: type,
      priority: priority,
      title: title,
      description: description,
      proposedSolution: proposedSolution,
      latitude: latitude,
      longitude: longitude,
      elevationMeters: elevationMeters,
      imagePath: imagePath,
      reportedAt: reportedAt,
      reporterName: reporterName,
      authorityId: authorityId,
      authorityName: authorityName,
      status: status ?? this.status,
      impactScore: impactScore,
    );
  }

  /// Approximate distance string for display in alert cards.
  String get distanceLabel {
    // Mock based on lat/lon — real impl would use user's live position.
    const double mockDistanceKm = 2.3;
    if (mockDistanceKm < 1) {
      return '${(mockDistanceKm * 1000).round()} m away';
    }
    return '${mockDistanceKm.toStringAsFixed(1)} km away';
  }

  /// Formatted timestamp for display.
  String get timeAgo {
    final diff = DateTime.now().difference(reportedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Short location label for cards.
  String get locationLabel {
    return 'Trail ${(latitude * 10).truncate()}, ${(longitude * 5).truncate() > 0 ? "North" : "South"} Sector';
  }
}
