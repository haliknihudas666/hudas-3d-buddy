import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// General settings screen
class GeneralSettingsScreen extends ConsumerWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settingsAsync = ref.watch(generalSettingsProvider);

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
                'General Settings',
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
                    // Currency Section
                    _buildSectionCard(
                      context,
                      title: 'Currency',
                      icon: Icons.attach_money_rounded,
                      color: AppColors.primary,
                      children: [
                        ModernDropdown<String>(
                          label: 'Currency',
                          value: settings.currency,
                          items: CurrencyOptions.currencies,
                          labelBuilder: (c) =>
                              '${CurrencyOptions.currencySymbols[c]} $c',
                          onChanged: (value) {
                            if (value != null) {
                              ref
                                  .read(generalSettingsProvider.notifier)
                                  .updateField(currency: value);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Electricity Section
                    _buildSectionCard(
                      context,
                      title: 'Electricity',
                      icon: Icons.bolt_rounded,
                      color: AppColors.warning,
                      children: [
                        NumberInputField(
                          label: 'Electricity Rate',
                          value: settings.electricityRatePerKwh,
                          min: 0,
                          max: 100,
                          step: 0.01,
                          suffix: '/kWh',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(electricityRatePerKwh: value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Labor Section
                    _buildSectionCard(
                      context,
                      title: 'Labor',
                      icon: Icons.person_rounded,
                      color: AppColors.secondary,
                      children: [
                        NumberInputField(
                          label: 'Labor Rate',
                          value: settings.laborRatePerHour,
                          min: 0,
                          max: 1000,
                          step: 5,
                          suffix: '/hour',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(laborRatePerHour: value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Pricing Adjustments Section
                    _buildSectionCard(
                      context,
                      title: 'Pricing Adjustments',
                      icon: Icons.tune_rounded,
                      color: AppColors.tertiary,
                      children: [
                        NumberInputField(
                          label: 'Failure Rate Buffer',
                          value: settings.failureRatePercent,
                          min: 0,
                          max: 100,
                          step: 1,
                          suffix: '%',
                          decimals: 1,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(failureRatePercent: value);
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Markup Percentage',
                          value: settings.markupPercent,
                          min: 0,
                          max: 500,
                          step: 5,
                          suffix: '%',
                          decimals: 1,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(markupPercent: value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Additional Costs Section
                    _buildSectionCard(
                      context,
                      title: 'Additional Costs',
                      icon: Icons.add_shopping_cart_rounded,
                      color: AppColors.error,
                      children: [
                        NumberInputField(
                          label: 'Packaging Cost per Item',
                          value: settings.packagingCostPerItem,
                          min: 0,
                          max: 1000,
                          step: 5,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(packagingCostPerItem: value);
                          },
                        ),
                        const SizedBox(height: 16),
                        NumberInputField(
                          label: 'Base Shipping Price',
                          value: settings.shippingBasePrice,
                          min: 0,
                          max: 1000,
                          step: 10,
                          suffix: '',
                          decimals: 2,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(shippingBasePrice: value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tax Section
                    _buildSectionCard(
                      context,
                      title: 'Taxes',
                      icon: Icons.receipt_rounded,
                      color: AppColors.success,
                      children: [
                        LabeledSwitch(
                          label: 'Include Tax',
                          subtitle: 'Add tax to suggested price',
                          value: settings.includeTax,
                          onChanged: (value) {
                            ref
                                .read(generalSettingsProvider.notifier)
                                .updateField(includeTax: value);
                          },
                        ),
                        if (settings.includeTax) ...[
                          const SizedBox(height: 16),
                          NumberInputField(
                            label: 'Tax Rate',
                            value: settings.taxPercent,
                            min: 0,
                            max: 50,
                            step: 0.5,
                            suffix: '%',
                            decimals: 1,
                            onChanged: (value) {
                              ref
                                  .read(generalSettingsProvider.notifier)
                                  .updateField(taxPercent: value);
                            },
                          ),
                        ],
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
