import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../providers/calculator_provider.dart';
import '../../../widgets/widgets.dart';

/// Card for print parameters input
class PrintParamsCard extends ConsumerWidget {
  const PrintParamsCard({super.key});

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
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.print_rounded,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Print Parameters',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Print Time
            NumberInputField(
              label: 'Print Time',
              value: state.printTimeHours,
              min: 0,
              max: 1000,
              step: 0.5,
              suffix: 'hours',
              decimals: 1,
              onChanged: (value) {
                notifier.updatePrintParams(printTimeHours: value);
              },
            ),
            const SizedBox(height: 16),

            // Filament Weight
            NumberInputField(
              label: 'Filament Weight',
              value: state.filamentWeightGrams,
              min: 0,
              max: 10000,
              step: 5,
              suffix: 'grams',
              decimals: 1,
              onChanged: (value) {
                notifier.updatePrintParams(filamentWeightGrams: value);
              },
            ),
            const SizedBox(height: 16),

            // Quantity
            NumberInputField(
              label: 'Quantity',
              value: state.quantity.toDouble(),
              min: 1,
              max: 1000,
              step: 1,
              suffix: 'pcs',
              decimals: 0,
              onChanged: (value) {
                notifier.updatePrintParams(quantity: value.toInt());
              },
            ),
            const SizedBox(height: 16),

            // Infill Percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Infill Percentage',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${state.infillPercent}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: state.infillPercent.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (value) {
                      notifier.updatePrintParams(infillPercent: value.toInt());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Layer Height
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Layer Height',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${state.layerHeight.toStringAsFixed(2)} mm',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.secondary,
                    inactiveTrackColor: AppColors.secondary.withOpacity(0.2),
                    thumbColor: AppColors.secondary,
                    overlayColor: AppColors.secondary.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: state.layerHeight,
                    min: 0.05,
                    max: 0.5,
                    divisions: 18,
                    onChanged: (value) {
                      notifier.updatePrintParams(layerHeight: value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
