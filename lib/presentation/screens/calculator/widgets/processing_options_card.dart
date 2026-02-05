import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../providers/calculator_provider.dart';
import '../../../widgets/widgets.dart';

/// Card for pre-processing options
class PreProcessingOptionsCard extends ConsumerWidget {
  const PreProcessingOptionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return SingleChildScrollView(
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.design_services_rounded,
                    color: AppColors.tertiary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Pre-Processing',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Costs before printing starts',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Modeling Hours
            NumberInputField(
              label: '3D Modeling Time',
              value: state.modelingHours,
              min: 0,
              max: 100,
              step: 0.5,
              suffix: 'hours',
              decimals: 1,
              onChanged: (value) {
                notifier.updatePreProcessing(modelingHours: value);
              },
            ),
            const SizedBox(height: 16),

            // Slicing Hours
            NumberInputField(
              label: 'Slicing & Preparation Time',
              value: state.slicingHours,
              min: 0,
              max: 10,
              step: 0.25,
              suffix: 'hours',
              decimals: 2,
              onChanged: (value) {
                notifier.updatePreProcessing(slicingHours: value);
              },
            ),
            const SizedBox(height: 20),

            // Custom Design Toggle
            LabeledSwitch(
              label: 'Custom Design',
              subtitle: 'Apply custom design surcharge',
              value: state.isCustomDesign,
              onChanged: (value) {
                notifier.updatePreProcessing(isCustomDesign: value);
              },
            ),

            // Rush Order Toggle
            LabeledSwitch(
              label: 'Rush Order',
              subtitle: 'Apply rush order premium',
              value: state.isRushOrder,
              onChanged: (value) {
                notifier.updatePreProcessing(isRushOrder: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Card for post-processing options
class PostProcessingOptionsCard extends ConsumerWidget {
  const PostProcessingOptionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return SingleChildScrollView(
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_fix_high_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Post-Processing',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Finishing work after printing',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Support Removal
            _buildProcessOption(
              context: context,
              label: 'Support Removal',
              icon: Icons.content_cut_rounded,
              isEnabled: state.needsSupportRemoval,
              hours: state.supportRemovalHours,
              onToggle: (value) {
                notifier.updatePostProcessing(needsSupportRemoval: value);
              },
              onHoursChanged: (value) {
                notifier.updatePostProcessing(supportRemovalHours: value);
              },
            ),

            // Sanding
            _buildProcessOption(
              context: context,
              label: 'Sanding',
              icon: Icons.gradient_rounded,
              isEnabled: state.needsSanding,
              hours: state.sandingHours,
              onToggle: (value) {
                notifier.updatePostProcessing(needsSanding: value);
              },
              onHoursChanged: (value) {
                notifier.updatePostProcessing(sandingHours: value);
              },
            ),

            // Painting
            _buildProcessOption(
              context: context,
              label: 'Painting',
              icon: Icons.format_paint_rounded,
              isEnabled: state.needsPainting,
              hours: state.paintingHours,
              onToggle: (value) {
                notifier.updatePostProcessing(needsPainting: value);
              },
              onHoursChanged: (value) {
                notifier.updatePostProcessing(paintingHours: value);
              },
            ),

            // Coating
            _buildProcessOption(
              context: context,
              label: 'Coating/Sealing',
              icon: Icons.layers_rounded,
              isEnabled: state.needsCoating,
              hours: state.coatingHours,
              onToggle: (value) {
                notifier.updatePostProcessing(needsCoating: value);
              },
              onHoursChanged: (value) {
                notifier.updatePostProcessing(coatingHours: value);
              },
            ),

            // Assembly
            _buildProcessOption(
              context: context,
              label: 'Assembly',
              icon: Icons.construction_rounded,
              isEnabled: state.needsAssembly,
              hours: state.assemblyHours,
              onToggle: (value) {
                notifier.updatePostProcessing(needsAssembly: value);
              },
              onHoursChanged: (value) {
                notifier.updatePostProcessing(assemblyHours: value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isEnabled,
    required double hours,
    required void Function(bool) onToggle,
    required void Function(double) onHoursChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? (isDark ? AppColors.primaryDark : AppColors.primary)
                  .withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
        color: isEnabled
            ? (isDark ? AppColors.primaryDark : AppColors.primary)
                .withOpacity(0.05)
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isEnabled
                    ? (isDark ? AppColors.primaryDark : AppColors.primary)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
            ],
          ),
          if (isEnabled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Time:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: hours > 0
                            ? () => onHoursChanged((hours - 0.25).clamp(0, 100))
                            : null,
                        visualDensity: VisualDensity.compact,
                      ),
                      Expanded(
                        child: Text(
                          '${hours.toStringAsFixed(2)} hrs',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () =>
                            onHoursChanged((hours + 0.25).clamp(0, 100)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
