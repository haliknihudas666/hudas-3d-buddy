import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../router/app_router.dart';

/// Modern glassmorphic sidebar with navigation
class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkSurface.withOpacity(0.95),
                    AppColors.darkSurfaceVariant.withOpacity(0.90),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lightSurface.withOpacity(0.95),
                    AppColors.lightSurfaceVariant.withOpacity(0.90),
                  ],
                ),
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),
              const SizedBox(height: 8),
              const Divider(indent: 16, endIndent: 16),
              const SizedBox(height: 8),

              // Navigation items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.calculate_rounded,
                      label: 'Calculator',
                      route: AppRoutes.home,
                      isSelected: currentRoute == AppRoutes.home,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.print_rounded,
                      label: 'Printers',
                      route: AppRoutes.printers,
                      isSelected: currentRoute == AppRoutes.printers,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.cable_rounded,
                      label: 'Filaments',
                      route: AppRoutes.filaments,
                      isSelected: currentRoute == AppRoutes.filaments,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.history_rounded,
                      label: 'History',
                      route: AppRoutes.history,
                      isSelected: currentRoute == AppRoutes.history,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'SETTINGS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.tune_rounded,
                      label: 'General Settings',
                      route: AppRoutes.generalSettings,
                      isSelected: currentRoute == AppRoutes.generalSettings,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.design_services_rounded,
                      label: 'Pre-Processing',
                      route: AppRoutes.preProcessing,
                      isSelected: currentRoute == AppRoutes.preProcessing,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.auto_fix_high_rounded,
                      label: 'Post-Processing',
                      route: AppRoutes.postProcessing,
                      isSelected: currentRoute == AppRoutes.postProcessing,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'APPEARANCE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                    _buildThemeSwitch(context, ref, isDarkMode),
                  ],
                ),
              ),

              // Footer
              const Divider(indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.view_in_ar_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hudas 3D Buddy',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'v1.0.0',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(
      BuildContext context, WidgetRef ref, bool isDarkMode) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ref.read(isDarkModeProvider.notifier).toggle();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  size: 22,
                  color: isDark ? AppColors.primaryDark : AppColors.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    isDarkMode ? 'Dark Mode' : 'Light Mode',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(isDarkModeProvider.notifier).toggle();
                  },
                  activeColor:
                      isDark ? AppColors.primaryDark : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3D Print',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Cost Calculator',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            if (!isSelected) {
              context.go(route);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        (isDark ? AppColors.primaryDark : AppColors.primary)
                            .withOpacity(0.15),
                        (isDark ? AppColors.primaryDark : AppColors.primary)
                            .withOpacity(0.05),
                      ],
                    )
                  : null,
              border: isSelected
                  ? Border.all(
                      color:
                          (isDark ? AppColors.primaryDark : AppColors.primary)
                              .withOpacity(0.3),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? (isDark ? AppColors.primaryDark : AppColors.primary)
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.primaryDark : AppColors.primary)
                        : theme.colorScheme.onSurface,
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
