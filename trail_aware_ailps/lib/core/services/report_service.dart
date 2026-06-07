import '../models/hazard_report.dart';
import '../models/hazard_type.dart';

/// In-memory store for hazard reports.
/// Pre-seeded with realistic mock data so UI is never empty on first launch.
class ReportService {
  ReportService() {
    _reports.addAll(_seedReports());
  }

  final List<HazardReport> _reports = [];

  List<HazardReport> get reports => List.unmodifiable(_reports);

  int get pendingCount =>
      _reports.where((r) => r.status == ReportStatus.pending).length;

  int get resolvedCount =>
      _reports.where((r) => r.status == ReportStatus.resolved).length;

  void addReport(HazardReport report) {
    _reports.insert(0, report); // Newest first
  }

  void updateStatus(String id, ReportStatus status) {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: status);
    }
  }

  HazardReport? getById(String id) {
    try {
      return _reports.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<HazardReport> _seedReports() {
    final now = DateTime.now();
    return [
      HazardReport(
        id: 'seed-001',
        type: HazardType.rockfall,
        priority: ReportPriority.high,
        title: 'Massive Rockfall on Trail 4A',
        description:
            'A significant rockslide has completely blocked Trail 4A '
            'approximately 500 meters below the Eagle\'s Peak summit. '
            'Debris field covers about 30 meters with boulders over 2m in diameter.',
        proposedSolution:
            'Deploy excavator and geological survey team. '
            'Estimated clearing: 3–5 days. Close trail section immediately.',
        latitude: 47.5489,
        longitude: 12.9742,
        elevationMeters: 2850,
        imagePath: 'assets/images/mock_hazard.png',
        reportedAt: now.subtract(const Duration(hours: 2)),
        reporterName: 'Alex M., Trail Guide',
        authorityId: 'NP-BERCHTESGADEN',
        authorityName: 'Nationalpark Berchtesgaden',
        status: ReportStatus.pending,
      ),
      HazardReport(
        id: 'seed-002',
        type: HazardType.bridgeDamage,
        priority: ReportPriority.medium,
        title: 'Washed-out Bridge Segment',
        description:
            'The wooden bridge over the Königsseer Ache has a damaged plank section. '
            'One central board is missing and two others are compromised. '
            'Crossing is possible with care but poses injury risk.',
        proposedSolution:
            'Replace damaged planks with treated timber (3–4 boards). '
            'Temporary detour via southern ford until repairs complete.',
        latitude: 47.5520,
        longitude: 12.9680,
        elevationMeters: 680,
        imagePath: 'assets/images/mock_bridge.png',
        reportedAt: now.subtract(const Duration(hours: 6)),
        reporterName: 'Maria K.',
        authorityId: 'NP-BERCHTESGADEN',
        authorityName: 'Nationalpark Berchtesgaden',
        status: ReportStatus.pending,
      ),
      HazardReport(
        id: 'seed-003',
        type: HazardType.flooding,
        priority: ReportPriority.low,
        title: 'Seasonal Flooding Near Meadow',
        description:
            'Spring snowmelt has caused the lower meadow trail section to flood. '
            'Water depth is approximately 15cm across a 40-meter stretch. '
            'Trail is passable with waterproof footwear.',
        proposedSolution:
            'Install temporary stepping stones or boardwalk section. '
            'Monitor water level — expected to recede within 2–3 weeks.',
        latitude: 47.5610,
        longitude: 12.9810,
        elevationMeters: 620,
        imagePath: 'assets/images/mock_flood.png',
        reportedAt: now.subtract(const Duration(days: 1)),
        reporterName: 'Thomas B.',
        authorityId: 'NP-BERCHTESGADEN',
        authorityName: 'Nationalpark Berchtesgaden',
        status: ReportStatus.assigned,
      ),
    ];
  }
}
