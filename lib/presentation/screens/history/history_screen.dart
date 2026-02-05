import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../domain/entities/filament_entity.dart';
import '../../../domain/entities/print_job_entity.dart';
import '../../../domain/entities/printer_entity.dart';
import '../../../domain/repositories/filament_repository.dart';
import '../../../domain/repositories/printer_repository.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// History screen showing saved print calculations
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(printJobHistoryProvider);

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
                'History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              historyAsync.maybeWhen(
                data: (jobs) => jobs.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded),
                        onPressed: () => _clearHistory(context, ref),
                        tooltip: 'Clear History',
                      )
                    : null,
                orElse: () => null,
              ),
            ].whereType<Widget>().toList(),
          ),
          historyAsync.when(
            loading: () => const SliverFillRemaining(
              child: LoadingIndicator(message: 'Loading history...'),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (jobs) {
              if (jobs.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.history_rounded,
                    title: 'No History Yet',
                    message: 'Your saved print calculations will appear here',
                  ),
                );
              }

              // Sort by date, newest first
              final sortedJobs = List<PrintJobEntity>.from(jobs)
                ..sort((a, b) => (b.createdAt ?? DateTime.now())
                    .compareTo(a.createdAt ?? DateTime.now()));

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildJobCard(
                      context,
                      ref,
                      sortedJobs[index],
                    ),
                    childCount: sortedJobs.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    WidgetRef ref,
    PrintJobEntity job,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: '₱');
    final dateFormat = DateFormat.yMMMd().add_jm();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.successGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.name ?? 'Untitled Print',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (job.createdAt != null)
                        Text(
                          dateFormat.format(job.createdAt!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                // Export Button
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  onPressed: () => _exportPdf(context, ref, job),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Export PDF',
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => _deleteJob(context, ref, job),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Suggested Price',
                    currencyFormat.format(job.suggestedPrice),
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Total Cost',
                    currencyFormat.format(job.totalCost),
                    AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Profit',
                    '${job.profitMargin.toStringAsFixed(1)}%',
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  '${job.printTimeHours.toStringAsFixed(1)} hrs',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.scale_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  '${job.filamentWeightGrams.toStringAsFixed(0)}g',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.numbers_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'x${job.quantity}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    WidgetRef ref,
    PrintJobEntity job,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      PrinterEntity? printer;
      FilamentEntity? filament;

      // Fetch printer details if available
      if (job.printerId != null) {
        try {
          printer = await ref
              .read(printerRepositoryProvider)
              .getPrinterById(job.printerId!);
        } catch (_) {}
      }

      // Fetch filament details if available
      if (job.filamentId != null) {
        try {
          filament = await ref
              .read(filamentRepositoryProvider)
              .getFilamentById(job.filamentId!);
        } catch (_) {}
      }

      // Close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }

      final pdfData = await PdfGenerator.generatePrintJobPdf(
        job: job,
        printer: printer,
        filament: filament,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdfData,
        name: 'Quote_${job.name ?? 'PrintJob'}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        // Ensure loading dialog is closed
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  void _deleteJob(
    BuildContext context,
    WidgetRef ref,
    PrintJobEntity job,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text(
          'Are you sure you want to delete "${job.name ?? 'this record'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(printJobHistoryProvider.notifier).deletePrintJob(job.id);
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

  void _clearHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all history? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(printJobHistoryProvider.notifier).clearHistory();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
