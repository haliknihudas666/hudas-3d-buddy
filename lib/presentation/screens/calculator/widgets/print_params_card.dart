import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../providers/calculator_provider.dart';
import '../../../widgets/widgets.dart';

/// Card for print parameters input
class PrintParamsCard extends ConsumerStatefulWidget {
  const PrintParamsCard({super.key});

  @override
  ConsumerState<PrintParamsCard> createState() => _PrintParamsCardState();
}

class _PrintParamsCardState extends ConsumerState<PrintParamsCard> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    // Sync controller with state (handles reset/load)
    final stateName = state.name ?? '';
    if (_nameController.text != stateName) {
      _nameController.value = _nameController.value.copyWith(
        text: stateName,
        selection: TextSelection.collapsed(offset: stateName.length),
        composing: TextRange.empty,
      );
    }

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

            // Print Name
            ModernTextField(
              label: 'Print Name (Optional)',
              hint: 'e.g. Iron Man Helmet',
              controller: _nameController,
              prefixIcon: const Icon(Icons.description_rounded),
              onChanged: (value) {
                notifier.updatePrintParams(name: value);
              },
            ),
            const SizedBox(height: 16),

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
          ],
        ),
      ),
    );
  }
}
