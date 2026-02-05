import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../domain/entities/filament_entity.dart';
import '../../../domain/entities/printer_entity.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'widgets/cost_breakdown_card.dart';
import 'widgets/print_params_card.dart';
import 'widgets/processing_options_card.dart';

/// Main calculator screen for 3D print cost calculation
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final calculatorState = ref.watch(calculatorProvider);
    final generalSettingsAsync = ref.watch(generalSettingsProvider);
    final lastJob = ref.watch(lastCalculatedJobProvider);

    return Scaffold(
      drawer: const AppSidebar(),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '3D Print Calculator',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              // Adjusted padding to be somewhat standard or removed if centering handles it.
              // Standard FlexibleSpaceBar with centerTitle handles padding well usually.
              // We'll keep a small bottom padding.
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  ref.read(calculatorProvider.notifier).clear();
                  ref.read(lastCalculatedJobProvider.notifier).state = null;
                },
                tooltip: 'Reset',
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Equipment Selection
                _buildEquipmentSelection(context),
                const SizedBox(height: 20),

                // Tabs for Print Params, Pre-Processing, Post-Processing
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDark ? AppColors.primaryDark : AppColors.primary,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Print'),
                      Tab(text: 'Pre-Process'),
                      Tab(text: 'Post-Process'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tab content (Dynamic Height)
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    return [
                      const PrintParamsCard(),
                      const PreProcessingOptionsCard(),
                      const PostProcessingOptionsCard(),
                    ][_tabController.index];
                  },
                ),
                const SizedBox(height: 20),

                // Calculate Button
                _buildCalculateButton(context),
                const SizedBox(height: 16),

                // Export Button (Visible only when job is calculated)
                if (lastJob != null) ...[
                  _buildExportButton(context),
                  const SizedBox(height: 20),
                ],

                // Cost Breakdown
                const CostBreakdownCard(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSelection(BuildContext context) {
    final theme = Theme.of(context);
    final printersAsync = ref.watch(printerNotifierProvider);
    final filamentsAsync = ref.watch(filamentNotifierProvider);
    final calculatorState = ref.watch(calculatorProvider);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings_suggest_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Equipment',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Printer Dropdown
          printersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (printers) {
              return ModernDropdown<PrinterEntity>(
                label: 'Printer',
                value: calculatorState.printer,
                items: printers,
                labelBuilder: (p) => '${p.name} (${p.brand})',
                hint: 'Select a printer',
                prefixIcon: const Icon(Icons.print_rounded),
                onChanged: (printer) {
                  ref.read(calculatorProvider.notifier).setPrinter(printer);
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Filament Dropdown
          filamentsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (filaments) {
              return ModernDropdown<FilamentEntity>(
                label: 'Filament',
                value: calculatorState.filament,
                items: filaments,
                labelBuilder: (f) => '${f.name} - ${f.material} (${f.brand})',
                hint: 'Select a filament',
                prefixIcon: const Icon(Icons.cable_rounded),
                onChanged: (filament) {
                  ref.read(calculatorProvider.notifier).setFilament(filament);
                },
              );
            },
          ),

          // Equipment info
          if (calculatorState.printer != null ||
              calculatorState.filament != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            if (calculatorState.printer != null)
              _buildInfoRow(
                'Printer Cost/hr',
                NumberFormat.currency(symbol: '₱').format(
                  calculatorState.printer!.printerCostPerHour,
                ),
                Icons.attach_money_rounded,
              ),
            if (calculatorState.filament != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Filament Cost/g',
                NumberFormat.currency(symbol: '₱').format(
                  calculatorState.filament!.effectivePricePerGram,
                ),
                Icons.attach_money_rounded,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton(BuildContext context) {
    final calculatorState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final canCalculate = calculatorState.printer != null &&
        calculatorState.filament != null &&
        calculatorState.printTimeHours > 0 &&
        calculatorState.filamentWeightGrams > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: canCalculate ? AppColors.primaryGradient : null,
        color: canCalculate
            ? null
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        boxShadow: canCalculate
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canCalculate ? _calculate : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: calculatorState.isCalculating
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calculate_rounded,
                        color: canCalculate
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Calculate Cost',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: canCalculate
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: _exportPdf,
      icon: const Icon(Icons.picture_as_pdf_rounded),
      label: const Text('Export PDF Quote'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: theme.colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final job = ref.read(lastCalculatedJobProvider);
    final calculatorState = ref.read(calculatorProvider);

    if (job != null) {
      final pdfData = await PdfGenerator.generatePrintJobPdf(
        job: job,
        printer: calculatorState.printer,
        filament: calculatorState.filament,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdfData,
        name: 'Quote_${job.name ?? 'PrintJob'}.pdf',
      );
    }
  }

  Future<void> _calculate() async {
    final notifier = ref.read(calculatorProvider.notifier);
    final job = await notifier.calculateCost();

    if (job != null) {
      ref.read(lastCalculatedJobProvider.notifier).state = job;

      // Auto-save to history
      final saved = await notifier.saveToHistory(job);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saved
                ? 'Calculated and saved to history!'
                : 'Calculated, but failed to save to history.'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }
}
