import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/claude_analysis_result.dart';
import '../models/hazard_report.dart';
import '../models/hazard_type.dart';
import '../services/claude_service.dart';
import '../services/geolocation_service.dart';
import 'report_provider.dart';

// ---------------------------------------------------------------------------
// Service providers
// ---------------------------------------------------------------------------

final claudeServiceProvider = Provider<ClaudeService>((ref) => ClaudeService());
final geolocationServiceProvider =
    Provider<GeolocationService>((ref) => GeolocationService());

// ---------------------------------------------------------------------------
// Camera state
// ---------------------------------------------------------------------------

class CameraState {
  const CameraState({
    this.controller,
    this.isInitialized = false,
    this.isMockMode = false,
    this.isAnalyzing = false,
    this.analysisResult,
    this.hazardDetected = false,
    this.statusMessage = 'Scanning environment...',
    this.flashEnabled = false,
    this.capturedReport,
    this.error,
  });

  final CameraController? controller;
  final bool isInitialized;

  /// True when running on simulator / no camera — shows mock hazard image instead.
  final bool isMockMode;
  final bool isAnalyzing;
  final ClaudeAnalysisResult? analysisResult;
  final bool hazardDetected;
  final String statusMessage;
  final bool flashEnabled;
  final HazardReport? capturedReport;
  final String? error;

  CameraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    bool? isMockMode,
    bool? isAnalyzing,
    ClaudeAnalysisResult? analysisResult,
    bool? hazardDetected,
    String? statusMessage,
    bool? flashEnabled,
    HazardReport? capturedReport,
    String? error,
    bool clearCapturedReport = false,
    bool clearError = false,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isMockMode: isMockMode ?? this.isMockMode,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      analysisResult: analysisResult ?? this.analysisResult,
      hazardDetected: hazardDetected ?? this.hazardDetected,
      statusMessage: statusMessage ?? this.statusMessage,
      flashEnabled: flashEnabled ?? this.flashEnabled,
      capturedReport:
          clearCapturedReport ? null : (capturedReport ?? this.capturedReport),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ---------------------------------------------------------------------------
// Camera notifier
// ---------------------------------------------------------------------------

final cameraProvider =
    StateNotifierProvider.autoDispose<CameraNotifier, CameraState>(
  (ref) => CameraNotifier(
    ref.read(claudeServiceProvider),
    ref.read(geolocationServiceProvider),
    ref,
  ),
);

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier(this._claude, this._geo, this._ref)
      : super(const CameraState());

  final ClaudeService _claude;
  final GeolocationService _geo;
  final Ref _ref;

  /// Guards all async state updates against post-dispose writes.
  /// autoDispose tears the notifier down during the navigation transition;
  /// without this flag any pending `state = ...` continuation crashes.
  bool _disposed = false;

  void _safeSetState(CameraState Function(CameraState) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _enterMockMode();
        return;
      }
      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      _safeSetState((s) => s.copyWith(
            controller: controller,
            isInitialized: true,
            isMockMode: false,
          ));
      // 1 s total before showing hazard result
      await Future.delayed(const Duration(milliseconds: 1000));
      _startBackgroundScan();
    } catch (_) {
      _enterMockMode();
    }
  }

  void _enterMockMode() async {
    _safeSetState((s) => s.copyWith(isInitialized: true, isMockMode: true));
    await Future.delayed(const Duration(milliseconds: 1000));
    _startBackgroundScan();
  }

  /// Shows the AI "hazard detected" result immediately (0 ms extra delay).
  /// Uses mock() data so the displayed type matches the full analysis result.
  void _startBackgroundScan() async {
    if (_disposed) return;
    final mock = ClaudeAnalysisResult.mock();
    _safeSetState((s) => s.copyWith(
          hazardDetected: true,
          statusMessage: 'Hazard Detected: ${mock.hazardType.displayName}',
        ));
  }

  Future<void> toggleFlash() async {
    final ctrl = state.controller;
    if (ctrl == null || !state.isInitialized) return;
    final newVal = !state.flashEnabled;
    await ctrl.setFlashMode(newVal ? FlashMode.torch : FlashMode.off);
    _safeSetState((s) => s.copyWith(flashEnabled: newVal));
  }

  /// Capture or load a mock image, analyse it, build and return the HazardReport.
  /// All state mutations are guarded so navigation can safely dispose this notifier
  /// while the async chain is still in flight.
  Future<HazardReport?> captureAndAnalyze() async {
    if (state.isAnalyzing) return null;
    if (!state.isMockMode &&
        (state.controller == null || !state.isInitialized)) {
      return null;
    }

    _safeSetState((s) =>
        s.copyWith(isAnalyzing: true, statusMessage: 'Analyzing image...'));

    try {
      final Uint8List imageBytes;
      // Asset path used as the imagePath so Report Detail can show the photo.
      const String mockImagePath = 'assets/images/mock_hazard.png';
      String? imagePath;

      if (state.isMockMode) {
        final data = await rootBundle.load(mockImagePath);
        imageBytes = data.buffer.asUint8List();
        imagePath = mockImagePath; // ← shows real image in Report Detail
      } else {
        final file = await state.controller!.takePicture();
        imageBytes = await file.readAsBytes();
        imagePath = file.path;
      }

      final analysis = await _claude.analyzeImage(imageBytes);

      // In mock mode use Berchtesgaden directly — simulator GPS returns
      // Apple HQ (California) which resolves to the wrong authority.
      final double lat;
      final double lng;
      if (state.isMockMode) {
        lat = 47.5489;
        lng = 12.9742;
      } else {
        final pos = await _geo.getCurrentPosition();
        lat = pos?.latitude ?? 47.5489;
        lng = pos?.longitude ?? 12.9742;
      }
      final elevation = _geo.getElevation(lat, lng);
      final authority = _geo.resolveAuthority(lat, lng);

      final report = HazardReport(
        id: const Uuid().v4(),
        type: analysis.hazardType,
        priority: analysis.priority,
        title: analysis.title,
        description: analysis.description,
        proposedSolution: analysis.proposedSolution,
        latitude: lat,
        longitude: lng,
        elevationMeters: elevation,
        imagePath: imagePath,
        reporterName: 'You (Anonymous)',
        authorityId: authority.id,
        authorityName: authority.name,
        status: ReportStatus.pending,
      );

      // Persist to the global store before navigating.
      _ref.read(reportsProvider.notifier).addReport(report);

      // Update state — guarded; notifier may already be disposed at this point
      // if navigation happened before analysis completed.
      _safeSetState((s) => s.copyWith(
            isAnalyzing: false,
            analysisResult: analysis,
            capturedReport: report,
            hazardDetected: true,
            statusMessage:
                'Hazard Detected: ${analysis.hazardType.displayName}',
          ));

      return report;
    } catch (_) {
      _safeSetState((s) => s.copyWith(
            isAnalyzing: false,
            error: 'Analysis failed. Please try again.',
            statusMessage: 'Scanning environment...',
          ));
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true; // Must be set BEFORE super.dispose()
    state.controller?.dispose();
    super.dispose();
  }
}
