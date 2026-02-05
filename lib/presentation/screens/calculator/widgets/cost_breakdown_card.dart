import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../providers/calculator_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/widgets.dart';

/// Card showing the cost breakdown
class CostBreakdownCard extends ConsumerWidget {
  const CostBreakdownCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final job = ref.watch(lastCalculatedJobProvider);
    final settingsAsync = ref.watch(generalSettingsProvider);

    if (job == null) {
      return GlassCard(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Cost Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Calculate a print to see the breakdown',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(
      symbol: settingsAsync.value?.currency == 'PHP' ? '₱' : '\$',
      decimalDigits: 2,
    );

    return Column(
      children: [
        // Summary Card
        GradientCard(
          gradient: AppColors.successGradient,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggested Price',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          currencyFormat.format(job.suggestedPrice),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMiniStat(
                    context,
                    'Total Cost',
                    currencyFormat.format(job.totalCost),
                  ),
                  _buildMiniStat(
                    context,
                    'Markup',
                    '${job.markupPercentage.toStringAsFixed(1)}%',
                  ),
                  _buildMiniStat(
                    context,
                    'Per Unit',
                    currencyFormat.format(job.pricePerUnit),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Detailed Breakdown
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 20,
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cost Breakdown',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Material Costs
              _buildSection(context, 'Material Costs', [
                _buildCostRow(
                    context, 'Filament', job.filamentCost, currencyFormat),
              ]),

              // Operation Costs
              _buildSection(context, 'Operation Costs', [
                _buildCostRow(context, 'Electricity', job.electricityCost,
                    currencyFormat),
                _buildCostRow(context, 'Printer (depreciation)',
                    job.printerCost, currencyFormat),
                _buildCostRow(context, 'Labor', job.laborCost, currencyFormat),
              ]),

              // Processing Costs
              if (job.preProcessingCost > 0 || job.postProcessingCost > 0)
                _buildSection(context, 'Processing Costs', [
                  if (job.preProcessingCost > 0)
                    _buildCostRow(context, 'Pre-Processing',
                        job.preProcessingCost, currencyFormat),
                  if (job.postProcessingCost > 0)
                    _buildCostRow(context, 'Post-Processing',
                        job.postProcessingCost, currencyFormat),
                ]),

              const Divider(),
              _buildCostRow(context, 'Subtotal', job.subtotal, currencyFormat,
                  isBold: true),

              // Adjustments
              _buildSection(context, 'Adjustments', [
                _buildCostRow(context, 'Failure Buffer', job.failureBuffer,
                    currencyFormat),
                _buildCostRow(context, 'Markup', job.markup, currencyFormat),
                if (job.packagingCost > 0)
                  _buildCostRow(
                      context, 'Packaging', job.packagingCost, currencyFormat),
                if (job.tax > 0)
                  _buildCostRow(context, 'Tax', job.tax, currencyFormat),
                if (job.shippingCost > 0)
                  _buildCostRow(
                      context, 'Shipping', job.shippingCost, currencyFormat),
              ]),

              const Divider(thickness: 2),
              _buildCostRow(
                context,
                'Total Cost',
                job.totalCost,
                currencyFormat,
                isBold: true,
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildCostRow(
    BuildContext context,
    String label,
    double amount,
    NumberFormat format, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? (isDark ? AppColors.primaryDark : AppColors.primary)
                  : null,
            ),
          ),
          Text(
            format.format(amount),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: isTotal
                  ? (isDark ? AppColors.primaryDark : AppColors.primary)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
