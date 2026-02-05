import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/filament_entity.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// Filaments management screen
class FilamentsScreen extends ConsumerWidget {
  const FilamentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filamentsAsync = ref.watch(filamentNotifierProvider);

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
                'Filaments',
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
                onPressed: () => _showFilamentDialog(context, ref),
                tooltip: 'Add Filament',
              ),
            ],
          ),
          filamentsAsync.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(message: 'Loading filaments...'),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (filaments) {
              if (filaments.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.cable_rounded,
                    title: 'No Filaments Yet',
                    message: 'Add your first filament spool to get started',
                    action: FilledButton.icon(
                      onPressed: () => _showFilamentDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Filament'),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildFilamentCard(
                      context,
                      ref,
                      filaments[index],
                    ),
                    childCount: filaments.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilamentDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Filament'),
      ),
    );
  }

  Widget _buildFilamentCard(
    BuildContext context,
    WidgetRef ref,
    FilamentEntity filament,
  ) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '₱');

    // Get color based on material
    Color materialColor;
    switch (filament.material.toUpperCase()) {
      case 'PLA':
        materialColor = AppColors.primary;
        break;
      case 'ABS':
        materialColor = AppColors.error;
        break;
      case 'PETG':
        materialColor = AppColors.secondary;
        break;
      case 'TPU':
        materialColor = AppColors.tertiary;
        break;
      default:
        materialColor = AppColors.warning;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showFilamentDialog(context, ref, filament),
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
              onPressed: (_) => _deleteFilament(context, ref, filament),
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
          onTap: () => _showFilamentDialog(context, ref, filament),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: materialColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: materialColor.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.cable_rounded,
                      color: materialColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filament.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${filament.brand} • ${filament.material}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: materialColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      filament.material,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: materialColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatChip(
                    context,
                    Icons.straighten_rounded,
                    '${filament.diameter}mm',
                    theme.colorScheme.onSurfaceVariant,
                  ),
                  _buildStatChip(
                    context,
                    Icons.monitor_weight_rounded,
                    '${filament.weightPerSpool}g',
                    theme.colorScheme.onSurfaceVariant,
                  ),
                  _buildStatChip(
                    context,
                    Icons.attach_money_rounded,
                    currencyFormat.format(filament.pricePerSpool),
                    AppColors.tertiary,
                  ),
                  _buildStatChip(
                    context,
                    Icons.price_change_rounded,
                    '${(filament.pricePerGram * 1000).toStringAsFixed(2)}/kg',
                    AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.thermostat_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Nozzle: ${filament.nozzleTemp}°C • Bed: ${filament.bedTemp}°C',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
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

  void _showFilamentDialog(
    BuildContext context,
    WidgetRef ref, [
    FilamentEntity? filament,
  ]) {
    final isEditing = filament != null;
    final formKey = GlobalKey<FormState>();

    // Form controllers
    final nameController = TextEditingController(text: filament?.name ?? '');
    final brandController = TextEditingController(text: filament?.brand ?? '');
    String selectedMaterial = filament?.material ?? 'PLA';
    final diameterController = TextEditingController(
      text: filament?.diameter.toString() ?? '1.75',
    );
    final priceController = TextEditingController(
      text: filament?.pricePerSpool.toString() ?? '',
    );
    final weightController = TextEditingController(
      text: filament?.weightPerSpool.toString() ?? '1000',
    );
    final densityController = TextEditingController(
      text: filament?.density.toString() ?? '1.24',
    );
    final nozzleTempController = TextEditingController(
      text: filament?.nozzleTemp.toString() ?? '200',
    );
    final bedTempController = TextEditingController(
      text: filament?.bedTemp.toString() ?? '60',
    );
    final wastageController = TextEditingController(
      text: filament?.wastagePercent.toString() ?? '5',
    );
    final colorController = TextEditingController(text: filament?.color ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
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
                          isEditing ? 'Edit Filament' : 'Add Filament',
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
                            label: 'Filament Name',
                            hint: 'e.g., Red PLA',
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
                                  hint: 'e.g., eSUN',
                                  controller: brandController,
                                  validator: (v) =>
                                      v?.isEmpty == true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedMaterial,
                                  decoration: const InputDecoration(
                                    labelText: 'Material',
                                  ),
                                  items: FilamentMaterials.materials
                                      .map((m) => DropdownMenuItem(
                                            value: m,
                                            child: Text(m),
                                          ))
                                      .toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      selectedMaterial = v ?? 'PLA';
                                      // Auto-fill density
                                      densityController.text = FilamentMaterials
                                              .densities[v]
                                              ?.toString() ??
                                          '1.24';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ModernTextField(
                                  label: 'Diameter',
                                  hint: '1.75',
                                  controller: diameterController,
                                  keyboardType: TextInputType.number,
                                  suffixText: 'mm',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ModernTextField(
                                  label: 'Density',
                                  hint: '1.24',
                                  controller: densityController,
                                  keyboardType: TextInputType.number,
                                  suffixText: 'g/cm³',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ModernTextField(
                                  label: 'Price/Spool',
                                  hint: '1000',
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  prefixText: '₱',
                                  validator: (v) =>
                                      v?.isEmpty == true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ModernTextField(
                                  label: 'Weight/Spool',
                                  hint: '1000',
                                  controller: weightController,
                                  keyboardType: TextInputType.number,
                                  suffixText: 'g',
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
                                  label: 'Nozzle Temp',
                                  hint: '200',
                                  controller: nozzleTempController,
                                  keyboardType: TextInputType.number,
                                  suffixText: '°C',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ModernTextField(
                                  label: 'Bed Temp',
                                  hint: '60',
                                  controller: bedTempController,
                                  keyboardType: TextInputType.number,
                                  suffixText: '°C',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ModernTextField(
                                  label: 'Wastage',
                                  hint: '5',
                                  controller: wastageController,
                                  keyboardType: TextInputType.number,
                                  suffixText: '%',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ModernTextField(
                                  label: 'Color (optional)',
                                  hint: 'e.g., Red',
                                  controller: colorController,
                                  prefixIcon: const Icon(Icons.palette_rounded),
                                ),
                              ),
                            ],
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
                              final newFilament = FilamentEntity(
                                id: filament?.id ?? const Uuid().v4(),
                                name: nameController.text,
                                brand: brandController.text,
                                material: selectedMaterial,
                                diameter:
                                    double.tryParse(diameterController.text) ??
                                        1.75,
                                pricePerSpool:
                                    double.tryParse(priceController.text) ?? 0,
                                weightPerSpool:
                                    double.tryParse(weightController.text) ??
                                        1000,
                                density:
                                    double.tryParse(densityController.text) ??
                                        1.24,
                                nozzleTemp:
                                    int.tryParse(nozzleTempController.text) ??
                                        200,
                                bedTemp:
                                    int.tryParse(bedTempController.text) ?? 60,
                                wastagePercent:
                                    double.tryParse(wastageController.text) ??
                                        5,
                                color: colorController.text.isEmpty
                                    ? null
                                    : colorController.text,
                              );

                              final notifier =
                                  ref.read(filamentNotifierProvider.notifier);
                              if (isEditing) {
                                await notifier.updateFilament(newFilament);
                              } else {
                                await notifier.addFilament(
                                  name: newFilament.name,
                                  brand: newFilament.brand,
                                  material: newFilament.material,
                                  diameter: newFilament.diameter,
                                  pricePerSpool: newFilament.pricePerSpool,
                                  weightPerSpool: newFilament.weightPerSpool,
                                  density: newFilament.density,
                                  nozzleTemp: newFilament.nozzleTemp,
                                  bedTemp: newFilament.bedTemp,
                                  wastagePercent: newFilament.wastagePercent,
                                  color: newFilament.color,
                                );
                              }

                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          child:
                              Text(isEditing ? 'Save Changes' : 'Add Filament'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteFilament(
    BuildContext context,
    WidgetRef ref,
    FilamentEntity filament,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Filament'),
        content: Text('Are you sure you want to delete "${filament.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(filamentNotifierProvider.notifier)
                  .deleteFilament(filament.id);
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
