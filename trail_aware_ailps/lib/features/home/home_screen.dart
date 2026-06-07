import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/providers/report_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/alert_card.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/kpi_card.dart';

/// Main home screen — v2 bento dashboard design.
/// Matches stitch_trailaware_alpine_ai/v2/trailaware_dashboard/code.html
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final pendingCount = ref.watch(pendingCountProvider);
    final resolvedCount = ref.watch(resolvedCountProvider);

    return ColoredBox(
      color: AppColors.surface,
      child: Stack(
        children: [
          // Scrollable content — top padding accounts for status bar + top bar
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Dynamic safe-area + top-bar height spacer
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top + 64,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Welcome section
                    Text(
                      'Good morning, Hiker',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 4),
                    Text(
                      'Current elevation: 1,420 m  •  Conditions: Clear',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 50.ms),
                    const SizedBox(height: 20),

                    // Map tile
                    _MapTile()
                        .animate()
                        .slideY(begin: 0.1, curve: Curves.easeOutCubic, duration: 500.ms)
                        .fadeIn(delay: 100.ms),
                    const SizedBox(height: 12),

                    // 2×2 KPI grid — compact height
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 96,
                            child: KpiCard(
                              label: 'TEMPERATURE',
                              value: 12,
                              icon: Icons.thermostat_outlined,
                              iconColor: AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 96,
                            child: KpiCard(
                              label: 'PACE (KM/H)',
                              value: 3,
                              icon: Icons.directions_walk_outlined,
                              iconColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().slideY(begin: 0.1, duration: 500.ms, delay: 150.ms).fadeIn(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 96,
                            child: KpiCard(
                              label: 'PENDING ALERTS',
                              value: pendingCount,
                              icon: Icons.warning_amber_outlined,
                              iconColor: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 96,
                            child: KpiCard(
                              label: 'RESOLVED TODAY',
                              value: resolvedCount,
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().slideY(begin: 0.1, duration: 500.ms, delay: 200.ms).fadeIn(),
                    const SizedBox(height: 20),

                    // Report Hazard CTA
                    GradientButton(
                      label: 'Report Hazard',
                      leadingIcon: Icons.photo_camera_outlined,
                      onPressed: () => context.push('/camera'),
                    ).animate().slideY(begin: 0.1, duration: 500.ms, delay: 250.ms).fadeIn(),
                    const SizedBox(height: 24),

                    // Nearby Alerts header
                    Row(
                      children: [
                        Text(
                          'Nearby Alerts',
                          style: AppTextStyles.headlineMediumMobile.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/dashboard'),
                          child: Text(
                            'VIEW ALL',
                            style: AppTextStyles.labelCaps.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 12),

                    // Horizontal alert cards
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: reports.take(3).length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return AlertCard(
                            report: report,
                            onTap: () => context.push('/report/${report.id}'),
                          ).animate().slideX(
                                begin: 0.15,
                                duration: 500.ms,
                                delay: Duration(milliseconds: 300 + index * 80),
                                curve: Curves.easeOutCubic,
                              ).fadeIn();
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),

          // Fixed glassmorphic top bar
          _TopBar(),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class _TopBar extends StatelessWidget {
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Location icon button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  // Brand title
                  Text(
                    'TrailAware AIlps',
                    style: AppTextStyles.headlineMediumMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  // Profile avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryFixed,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapTile extends StatelessWidget {
  // Berchtesgaden National Park — Bavarian Alps, Germany
  static const _center = LatLng(47.5489, 12.9742);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Real OSM tile map
            FlutterMap(
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 11.5,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.none),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.trailaware.trail_aware_ailps',
                ),
                // Seed report pins
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(47.5489, 12.9742),
                      width: 32,
                      height: 32,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 14),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .scaleXY(
                            begin: 1.0,
                            end: 1.15,
                            duration: 1200.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                    Marker(
                      point: const LatLng(47.5520, 12.9680),
                      width: 28,
                      height: 28,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Subtle top/bottom gradient for readability of overlaid chips
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.30),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            // Location chip bottom-left
            Positioned(
              bottom: 12,
              left: 12,
              child: GlassPanel(
                style: GlassPanelStyle.dark,
                borderRadius: BorderRadius.circular(100),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Berchtesgadener Land',
                        style: TextStyle(
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
            // Recenter button bottom-right
            Positioned(
              bottom: 12,
              right: 12,
              child: GlassPanel(
                style: GlassPanelStyle.dark,
                borderRadius: BorderRadius.circular(100),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.my_location, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
