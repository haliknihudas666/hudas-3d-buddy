import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// Pre-processing settings screen
class PreProcessingScreen extends ConsumerWidget {
  const PreProcessingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(preProcessingSettingsProvider);

    return Scaffold(
      drawer: const AppSidebar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Pre-Processing',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
            ),
          ),
          settingsAsync.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(message: 'Loading settings...'),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (settings) {
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Info Card
                    GlassCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppColors.secondaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.design_services_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pre-Processing Costs',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Configure rates for work done before printing',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3D Modeling Section
                    _buildSectionCard(
                      context,
                      title: '3D Modeling',
                      icon: Icons.view_in_ar_rounded,
                      color: AppColors.primary,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.modelingRatePerHour,
                          min: 0,
                          max: 1000,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(modelingRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.modelingFlatFee,
                          min: 0,
                          max: 10000,
                          step: 50,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(modelingFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Slicing Section
                    _buildSectionCard(
                      context,
                      title: 'Slicing & File Prep',
                      icon: Icons.layers_rounded,
                      color: AppColors.secondary,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.slicingRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(slicingRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.slicingFlatFee,
                          min: 0,
                          max: 1000,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(slicingFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Consultation Section
                    _buildSectionCard(
                      context,
                      title: 'Consultation',
                      icon: Icons.chat_rounded,
                      color: AppColors.tertiary,
                      children: [
                        NumberInputField(
                          label: 'Consultation Rate',
                          value: settings.consultationRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(
                                      consultationRatePerHour: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Additional Fees Section
                    _buildSectionCard(
                      context,
                      title: 'Additional Fees',
                      icon: Icons.add_circle_outline_rounded,
                      color: AppColors.warning,
                      children: [
                        NumberInputField(
                          label: 'File Repair Fee',
                          value: settings.fileRepairFee,
                          min: 0,
                          max: 1000,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(fileRepairFee: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Custom Design Surcharge',
                          value: settings.customDesignSurcharge,
                          min: 0,
                          max: 5000,
                          step: 50,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(
                                      customDesignSurcharge: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Rush Order Premium',
                          value: settings.rushOrderPercent,
                          min: 0,
                          max: 200,
                          step: 5,
                          suffix: '%',
                          decimals: 1,
                          onChanged: (value) {
                            ref
                                .read(preProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(rushOrderPercent: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
