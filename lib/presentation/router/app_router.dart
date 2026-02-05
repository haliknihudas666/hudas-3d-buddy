import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/calculator/calculator_screen.dart';
import '../screens/printers/printers_screen.dart';
import '../screens/filaments/filaments_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/settings/general_settings_screen.dart';
import '../screens/settings/pre_processing_screen.dart';
import '../screens/settings/post_processing_screen.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String printers = '/printers';
  static const String filaments = '/filaments';
  static const String history = '/history';
  static const String generalSettings = '/settings/general';
  static const String preProcessing = '/settings/pre-processing';
  static const String postProcessing = '/settings/post-processing';
}

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CalculatorScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.printers,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PrintersScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.filaments,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const FilamentsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.history,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HistoryScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.generalSettings,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const GeneralSettingsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.preProcessing,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PreProcessingScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.postProcessing,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PostProcessingScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: _ErrorScreen(error: state.error),
    ),
  );
});

/// Fade transition animation
Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// Slide transition animation
Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(0.05, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeOutCubic;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

  return SlideTransition(
    position: animation.drive(tween),
    child: FadeTransition(
      opacity: animation.drive(fadeTween),
      child: child,
    ),
  );
}

/// Error screen
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
