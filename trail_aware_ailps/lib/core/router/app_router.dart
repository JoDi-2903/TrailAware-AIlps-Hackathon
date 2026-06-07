import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/camera/camera_screen.dart';
import '../../features/dashboard/authority_dashboard_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/report_detail/report_detail_screen.dart';
import '../../features/success/success_screen.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';
import '../models/hazard_report.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Shell route wraps Home + Dashboard + Profile with shared bottom nav
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AuthorityDashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    // Full-screen modal routes — no bottom nav
    GoRoute(
      path: '/camera',
      pageBuilder: (context, state) => _slideUpPage(
        key: state.pageKey,
        child: const CameraScreen(),
      ),
    ),
    GoRoute(
      path: '/success',
      pageBuilder: (context, state) {
        final report = state.extra as HazardReport?;
        // Fade-only transition — the screen's own flutter_animate stagger
        // handles all slide motion. A page-level slide would double up with
        // the per-element .slideY() animations and render content twice.
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: SuccessScreen(report: report),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondary, child) =>
              FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: '/report/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _slideUpPage(
          key: state.pageKey,
          child: ReportDetailScreen(reportId: id),
        );
      },
    ),
  ],
);

/// Slide-up + fade transition matching cubic-bezier(0.16, 1, 0.3, 1).
CustomTransitionPage<void> _slideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: const Cubic(0.16, 1.0, 0.3, 1.0),
        reverseCurve: Curves.easeIn,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

/// Shell widget that hosts the bottom navigation bar.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentLocation: GoRouterState.of(context).uri.toString(),
      ),
    );
  }
}
