import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// Post-processing settings screen
class PostProcessingScreen extends ConsumerWidget {
  const PostProcessingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(postProcessingSettingsProvider);

    return Scaffold(
      drawer: const AppSidebar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Post-Processing',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
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
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_fix_high_rounded,
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
                                  'Post-Processing Costs',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Configure rates for finishing work after printing',
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

                    // Support Removal Section
                    _buildSectionCard(
                      context,
                      title: 'Support Removal',
                      icon: Icons.content_cut_rounded,
                      color: AppColors.error,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.supportRemovalRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(
                                      supportRemovalRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.supportRemovalFlatFee,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(
                                      supportRemovalFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sanding Section
                    _buildSectionCard(
                      context,
                      title: 'Sanding & Surface Finishing',
                      icon: Icons.gradient_rounded,
                      color: AppColors.warning,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.sandingRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(sandingRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.sandingFlatFee,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(sandingFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Painting Section
                    _buildSectionCard(
                      context,
                      title: 'Painting',
                      icon: Icons.format_paint_rounded,
                      color: AppColors.secondary,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.paintingRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(paintingRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Material Cost',
                          value: settings.paintingMaterialCost,
                          min: 0,
                          max: 1000,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(
                                      paintingMaterialCost: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.paintingFlatFee,
                          min: 0,
                          max: 500,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(paintingFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Coating Section
                    _buildSectionCard(
                      context,
                      title: 'Coating & Sealing',
                      icon: Icons.layers_rounded,
                      color: AppColors.tertiary,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.coatingRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(coatingRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Material Cost',
                          value: settings.coatingMaterialCost,
                          min: 0,
                          max: 1000,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(coatingMaterialCost: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Assembly Section
                    _buildSectionCard(
                      context,
                      title: 'Assembly',
                      icon: Icons.construction_rounded,
                      color: AppColors.primary,
                      children: [
                        NumberInputField(
                          label: 'Hourly Rate',
                          value: settings.assemblyRatePerHour,
                          min: 0,
                          max: 500,
                          step: 10,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(assemblyRatePerHour: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Flat Fee',
                          value: settings.assemblyFlatFee,
                          min: 0,
                          max: 500,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(assemblyFlatFee: value),
                                );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Special Treatments Section
                    _buildSectionCard(
                      context,
                      title: 'Special Treatments',
                      icon: Icons.science_rounded,
                      color: AppColors.success,
                      children: [
                        NumberInputField(
                          label: 'Heat Treatment Fee',
                          value: settings.heatTreatmentFee,
                          min: 0,
                          max: 500,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(heatTreatmentFee: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Vapor Smoothing Fee',
                          value: settings.vaporSmoothingFee,
                          min: 0,
                          max: 500,
                          step: 25,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(vaporSmoothingFee: value),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Quality Inspection Fee',
                          value: settings.inspectionFee,
                          min: 0,
                          max: 200,
                          step: 10,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(postProcessingSettingsProvider.notifier)
                                .updateSettings(
                                  settings.copyWith(inspectionFee: value),
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
