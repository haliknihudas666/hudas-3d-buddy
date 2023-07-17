import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/screens.dart';

final appRouter = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: CustomRouter.kHomeRoute,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: CustomRouter.kPrinterRoute,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const FilamentManagementPage(),
        ),
      ),
      GoRoute(
        path: CustomRouter.kFilamentRoute,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const FilamentManagementPage(),
        ),
      ),
    ],
    initialLocation: CustomRouter.kHomeRoute,
    errorPageBuilder: (context, state) =>
        MaterialPage<void>(key: state.pageKey, child: _ErrorPage(state.error)),
    redirect: (context, state) {
      // final auth = ref.read(authProvider);
      // final introStatus = auth.userIntro;
      // final token = auth.token;

      // log(introStatus.toString(), name: 'Intro Status');

      // if (token != null) {
      //   return CustomRouter.kHomeRoute;
      // } else if (state.location == CustomRouter.kOnboardingRoute &&
      //     introStatus) {
      //   return CustomRouter.kAuthLandingRoute;
      // }

      return null;
    },
  );
});

class CustomRouter {
  /// /onboarding route
  static const String kOnboardingRoute = '/onboarding';

  /// / home route
  static const String kHomeRoute = '/';

  /// /printer route
  static const String kPrinterRoute = '/printer';

  /// /filament route
  static const String kFilamentRoute = '/filament';

  /// /history
  static const String kHistoryRoute = '/history';

  /// /calusettings
  static const String kCalcuSettingsRoute = '/calcusettings';

  /// /settings
  static const String kSettingsRoute = '/settings';
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage(this.error, {Key? key}) : super(key: key);
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('I think you are lost. There is no page here.'),
            TextButton(
              onPressed: () => context.go(CustomRouter.kHomeRoute),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
