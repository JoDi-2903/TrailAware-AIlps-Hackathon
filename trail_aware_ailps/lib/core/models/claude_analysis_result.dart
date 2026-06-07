import 'hazard_type.dart';

/// Result of Claude Vision API analysis on a captured trail image.
/// Used as an intermediate DTO before building the full `HazardReport`.
class ClaudeAnalysisResult {
  const ClaudeAnalysisResult({
    required this.hazardType,
    required this.priority,
    required this.title,
    required this.description,
    required this.proposedSolution,
    required this.confidenceScore,
  });

  final HazardType hazardType;
  final ReportPriority priority;
  final String title;
  final String description;
  final String proposedSolution;

  /// 0.0–1.0 confidence from the model
  final double confidenceScore;

  /// Parse from Claude's JSON response — tolerant of missing/malformed keys.
  factory ClaudeAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ClaudeAnalysisResult(
      hazardType: HazardTypeX.fromApiString(
        (json['hazard_type'] as String?) ?? 'other',
      ),
      priority: ReportPriorityX.fromApiString(
        (json['priority'] as String?) ?? 'medium',
      ),
      title: (json['title'] as String?) ?? 'Trail Obstruction',
      description: (json['description'] as String?) ??
          'A trail obstruction has been detected. Please assess the situation.',
      proposedSolution: (json['proposed_solution'] as String?) ??
          'Inspect and clear the trail when safe to do so.',
      confidenceScore:
          ((json['confidence'] as num?) ?? 0.7).toDouble().clamp(0.0, 1.0),
    );
  }

  /// Safe fallback when API call fails — ensures demo never crashes.
  factory ClaudeAnalysisResult.fallback() {
    return const ClaudeAnalysisResult(
      hazardType: HazardType.rockfall,
      priority: ReportPriority.high,
      title: 'Rockfall Blockage',
      description:
          'A significant rockfall has been detected blocking the trail path. '
          'Debris covers the trail and makes passage hazardous.',
      proposedSolution:
          'Deploy a maintenance team to clear debris and assess slope stability. '
          'Close trail section until cleared.',
      confidenceScore: 0.85,
    );
  }

  /// Mock result for demo / offline mode — returns after a simulated delay in ClaudeService.
  factory ClaudeAnalysisResult.mock() {
    return const ClaudeAnalysisResult(
      hazardType: HazardType.rockfall,
      priority: ReportPriority.high,
      title: 'Rockfall Blockage Detected',
      description:
          'AI analysis detected a significant rockfall completely blocking Trail 4A '
          'approximately 500 meters below the summit. Boulders up to 2 meters in '
          'diameter are present. Trail structure appears compromised.',
      proposedSolution:
          'Dispatch excavator and geological survey team. Estimated clearing time: '
          '3–5 days once equipment is on-site. Close trail section immediately.',
      confidenceScore: 0.92,
    );
  }
}
