import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/router/app_router.dart';
import 'presentation/widgets/banner_ad_widget.dart';

/// Main application widget
class Hudas3DBuddyApp extends ConsumerWidget {
  const Hudas3DBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      title: 'Hudas 3D Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return Column(
          children: [
            Expanded(child: child!),
            SafeArea(
              top: false,
              child: Material(
                child: BannerAdWidget(),
              ),
            ),
          ],
        );
      },
    );
  }
}
