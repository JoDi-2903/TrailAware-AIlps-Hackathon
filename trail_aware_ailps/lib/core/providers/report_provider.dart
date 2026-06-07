import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hazard_report.dart';
import '../models/hazard_type.dart';
import '../services/report_service.dart';

/// Singleton report service shared across the app.
final reportServiceProvider = Provider<ReportService>((ref) => ReportService());

/// All hazard reports — mutable list managed by [ReportsNotifier].
final reportsProvider =
    StateNotifierProvider<ReportsNotifier, List<HazardReport>>(
  (ref) => ReportsNotifier(ref.read(reportServiceProvider)),
);

/// Count of reports currently in `pending` status.
final pendingCountProvider = Provider<int>((ref) {
  return ref
      .watch(reportsProvider)
      .where((r) => r.status == ReportStatus.pending)
      .length;
});

/// Count of reports resolved today.
final resolvedCountProvider = Provider<int>((ref) {
  final today = DateTime.now();
  return ref.watch(reportsProvider).where((r) {
    return r.status == ReportStatus.resolved &&
        r.reportedAt.day == today.day &&
        r.reportedAt.month == today.month &&
        r.reportedAt.year == today.year;
  }).length;
});

class ReportsNotifier extends StateNotifier<List<HazardReport>> {
  ReportsNotifier(this._service) : super(_service.reports);

  final ReportService _service;

  void addReport(HazardReport report) {
    _service.addReport(report);
    state = _service.reports.toList();
  }

  void updateStatus(String id, ReportStatus status) {
    _service.updateStatus(id, status);
    state = _service.reports.toList();
  }

  HazardReport? getById(String id) => _service.getById(id);
}
