import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home.dart';

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
    ],
    initialLocation: CustomRouter.kOnboardingRoute,
    errorPageBuilder: (context, state) =>
        MaterialPage<void>(key: state.pageKey, child: _ErrorPage(state.error)),
    redirect: (state) {
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
    urlPathStrategy: UrlPathStrategy.path,
  );
});

class CustomRouter {
  /// /onboarding route
  static const String kOnboardingRoute = '/onboarding';

  /// /login route
  static const String kAuthLandingRoute = '/authlanding';

  /// /login route
  static const String kLoginRoute = '/login';

  /// /register route
  static const String kRegisterRoute = '/register';

  /// /verify route
  static const String kOTPRoute = '/verify';

  /// / route
  static const String kHomeRoute = '/';

  /// /profile route
  static const String kProfileRoute = '/profile';
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
