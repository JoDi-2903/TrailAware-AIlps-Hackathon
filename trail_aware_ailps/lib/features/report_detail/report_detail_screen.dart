import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/hazard_report.dart';
import '../../core/models/hazard_type.dart';
import '../../core/providers/report_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/priority_badge.dart';

/// Detailed view of a single hazard report.
/// Matches stitch_trailaware_alpine_ai/v2/trailaware_report_details_updated_map/code.html
class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportsProvider.notifier).getById(reportId);

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Report not found')),
        body: const Center(child: Text('This report no longer exists.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Scrollable content with top padding for header
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 76)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(report),
                    const SizedBox(height: 16),
                    _buildPhoto(report),
                    const SizedBox(height: 16),
                    _buildSituationCard(report),
                    const SizedBox(height: 12),
                    _buildAiAnalysisCard(report),
                    const SizedBox(height: 12),
                    _buildMetadataCard(report),
                    const SizedBox(height: 12),
                    _buildMap(report),
                  ]),
                ),
              ),
            ],
          ),

          // Fixed glassmorphic header
          _Header(onBack: () => context.pop()),

          // Sticky bottom action bar
          _BottomBar(report: report, ref: ref),
        ],
      ),
    );
  }

  Widget _buildHeader(HazardReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PriorityBadge(priority: report.priority),
            const SizedBox(width: 8),
            Text(
              'ID: #AL-${report.id.substring(0, 6).toUpperCase()}',
              style: AppTextStyles.labelCaps.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 10),
        Text(
          report.title,
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.onSurface,
          ),
        ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                report.locationLabel,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }

  Widget _buildPhoto(HazardReport report) {
    // Resolve the image widget: asset path → Image.asset, file path → Image.file, null → placeholder
    Widget imageWidget;
    final path = report.imagePath;
    if (path != null && path.startsWith('assets/')) {
      imageWidget = Image.asset(path, fit: BoxFit.cover);
    } else if (path != null) {
      imageWidget = Image.file(File(path), fit: BoxFit.cover);
    } else {
      imageWidget = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A5568), Color(0xFF2D3748), Color(0xFF1A202C)],
          ),
        ),
        child: const Icon(Icons.image_outlined, color: Colors.white24, size: 64),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageWidget,
            // Subtle dark gradient so timestamp chip is always readable
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                ),
              ),
            ),
            // Timestamp chip
            Positioned(
              bottom: 12,
              left: 12,
              child: GlassPanel(
                style: GlassPanelStyle.dark,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_camera, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'Captured ${report.timeAgo}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildSituationCard(HazardReport report) {
    return GlassPanel(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Situation Description',
              style: AppTextStyles.headlineMediumMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              report.description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.08, duration: 400.ms, delay: 200.ms).fadeIn();
  }

  Widget _buildAiAnalysisCard(HazardReport report) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.smart_toy_outlined, size: 18, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Analysis & Proposed Solution',
                  style: AppTextStyles.headlineMediumMobile.copyWith(
                    color: AppColors.secondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            report.proposedSolution,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.08, duration: 400.ms, delay: 250.ms).fadeIn();
  }

  Widget _buildMetadataCard(HazardReport report) {
    return GlassPanel(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Details',
              style: AppTextStyles.headlineMediumMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 14),
            _MetaRow(
              icon: Icons.person_outline,
              label: 'Reported By',
              value: report.reporterName,
            ),
            _MetaRow(
              icon: Icons.schedule_outlined,
              label: 'Timestamp',
              value: _formatDate(report.reportedAt),
            ),
            _MetaRow(
              icon: Icons.landscape_outlined,
              label: 'Elevation',
              value: report.elevationMeters != null
                  ? '${report.elevationMeters!.round()} meters ASL'
                  : 'Unknown',
            ),
            _MetaRow(
              icon: Icons.my_location_outlined,
              label: 'Coordinates',
              value:
                  '${report.latitude.toStringAsFixed(4)}° N, ${report.longitude.toStringAsFixed(4)}° E',
            ),
            _MetaRow(
              icon: Icons.business_outlined,
              label: 'Notified Authority',
              value: report.authorityName,
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.08, duration: 400.ms, delay: 300.ms).fadeIn();
  }

  Widget _buildMap(HazardReport report) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 192,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(report.latitude, report.longitude),
            initialZoom: 13,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.trailaware.trail_aware_ailps',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(report.latitude, report.longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 350.ms);
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} - '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} UTC';
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;

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
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primary, size: 20),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      'Report Details',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineMediumMobile.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.report, required this.ref});
  final HazardReport report;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GlassPanel(
        borderRadius: BorderRadius.zero,
        sigmaBlur: 16,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: 'Close Report',
                    onPressed: () => context.pop(),
                    outlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: 'Dispatch Team',
                    leadingIcon: Icons.local_shipping_outlined,
                    onPressed: () {
                      ref.read(reportsProvider.notifier).updateStatus(
                            report.id,
                            ReportStatus.assigned,
                          );
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
