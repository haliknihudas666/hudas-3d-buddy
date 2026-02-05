import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/printer_entity.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// Printers management screen
class PrintersScreen extends ConsumerWidget {
  const PrintersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final printersAsync = ref.watch(printerNotifierProvider);

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
                'Printers',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _showPrinterDialog(context, ref),
                tooltip: 'Add Printer',
              ),
            ],
          ),
          printersAsync.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(message: 'Loading printers...'),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (printers) {
              if (printers.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.print_rounded,
                    title: 'No Printers Yet',
                    message: 'Add your first 3D printer to get started',
                    action: FilledButton.icon(
                      onPressed: () => _showPrinterDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Printer'),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPrinterCard(
                      context,
                      ref,
                      printers[index],
                    ),
                    childCount: printers.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPrinterDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Printer'),
      ),
    );
  }

  Widget _buildPrinterCard(
    BuildContext context,
    WidgetRef ref,
    PrinterEntity printer,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: '₱');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showPrinterDialog(context, ref, printer),
              flex: 1,
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Edit',
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
            SlidableAction(
              onPressed: (_) => _deletePrinter(context, ref, printer),
              flex: 1,
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: GlassCard(
          onTap: () => _showPrinterDialog(context, ref, printer),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.print_rounded,
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
                          printer.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${printer.brand} ${printer.model}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatChip(
                    context,
                    Icons.bolt_rounded,
                    '${printer.wattage.toStringAsFixed(0)}W',
                    AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    context,
                    Icons.schedule_rounded,
                    '${printer.depreciationCostPerHour.toStringAsFixed(2)}/hr',
                    AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    context,
                    Icons.attach_money_rounded,
                    currencyFormat.format(printer.purchasePrice),
                    AppColors.tertiary,
                  ),
                ],
              ),
              if (printer.buildVolume != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.view_in_ar_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Build Volume: ${printer.buildVolume}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrinterDialog(
    BuildContext context,
    WidgetRef ref, [
    PrinterEntity? printer,
  ]) {
    final isEditing = printer != null;
    final formKey = GlobalKey<FormState>();

    // Form controllers
    final nameController = TextEditingController(text: printer?.name ?? '');
    final brandController = TextEditingController(text: printer?.brand ?? '');
    final modelController = TextEditingController(text: printer?.model ?? '');
    final wattageController = TextEditingController(
      text: printer?.wattage.toString() ?? '200',
    );
    final priceController = TextEditingController(
      text: printer?.purchasePrice.toString() ?? '',
    );
    final lifetimeController = TextEditingController(
      text: printer?.expectedLifetimeHours.toString() ?? '2000',
    );
    final maintenanceController = TextEditingController(
      text: printer?.maintenanceCostPerYear.toString() ?? '0',
    );
    final consumablesController = TextEditingController(
      text: printer?.consumablesCostPerHour.toString() ?? '0',
    );
    final buildVolumeController = TextEditingController(
      text: printer?.buildVolume ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      isEditing ? 'Edit Printer' : 'Add Printer',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ModernTextField(
                        label: 'Printer Name',
                        hint: 'e.g., My Ender 3',
                        controller: nameController,
                        prefixIcon: const Icon(Icons.label_rounded),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ModernTextField(
                              label: 'Brand',
                              hint: 'e.g., Creality',
                              controller: brandController,
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              label: 'Model',
                              hint: 'e.g., Ender 3 V2',
                              controller: modelController,
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ModernTextField(
                              label: 'Wattage',
                              hint: '200',
                              controller: wattageController,
                              keyboardType: TextInputType.number,
                              suffixText: 'W',
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              label: 'Purchase Price',
                              hint: '15000',
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              prefixText: '₱',
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ModernTextField(
                        label: 'Expected Lifetime',
                        hint: '2000',
                        controller: lifetimeController,
                        keyboardType: TextInputType.number,
                        suffixText: 'hours',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ModernTextField(
                              label: 'Maintenance/Year',
                              hint: '0',
                              controller: maintenanceController,
                              keyboardType: TextInputType.number,
                              prefixText: '₱',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              label: 'Consumables/Hour',
                              hint: '0',
                              controller: consumablesController,
                              keyboardType: TextInputType.number,
                              prefixText: '₱',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ModernTextField(
                        label: 'Build Volume (optional)',
                        hint: 'e.g., 220x220x250 mm',
                        controller: buildVolumeController,
                        prefixIcon: const Icon(Icons.view_in_ar_rounded),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Save Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final newPrinter = PrinterEntity(
                            id: printer?.id ?? const Uuid().v4(),
                            name: nameController.text,
                            brand: brandController.text,
                            model: modelController.text,
                            wattage:
                                double.tryParse(wattageController.text) ?? 200,
                            purchasePrice:
                                double.tryParse(priceController.text) ?? 0,
                            expectedLifetimeHours:
                                int.tryParse(lifetimeController.text) ?? 2000,
                            maintenanceCostPerYear:
                                double.tryParse(maintenanceController.text) ??
                                    0,
                            consumablesCostPerHour:
                                double.tryParse(consumablesController.text) ??
                                    0,
                            buildVolume: buildVolumeController.text.isEmpty
                                ? null
                                : buildVolumeController.text,
                          );

                          final notifier =
                              ref.read(printerNotifierProvider.notifier);
                          if (isEditing) {
                            await notifier.updatePrinter(newPrinter);
                          } else {
                            await notifier.addPrinter(
                              name: newPrinter.name,
                              brand: newPrinter.brand,
                              model: newPrinter.model,
                              wattage: newPrinter.wattage,
                              purchasePrice: newPrinter.purchasePrice,
                              expectedLifetimeHours:
                                  newPrinter.expectedLifetimeHours,
                              maintenanceCostPerYear:
                                  newPrinter.maintenanceCostPerYear,
                              consumablesCostPerHour:
                                  newPrinter.consumablesCostPerHour,
                              buildVolume: newPrinter.buildVolume,
                            );
                          }

                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: Text(isEditing ? 'Save Changes' : 'Add Printer'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deletePrinter(
    BuildContext context,
    WidgetRef ref,
    PrinterEntity printer,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Printer'),
        content: Text('Are you sure you want to delete "${printer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(printerNotifierProvider.notifier)
                  .deletePrinter(printer.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
