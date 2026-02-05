import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/print_job_entity.dart';
import '../../domain/repositories/print_job_repository.dart';
import 'di_providers.dart';

/// Provider for print job history state
final printJobHistoryProvider = AsyncNotifierProvider<PrintJobHistoryNotifier, List<PrintJobEntity>>(
  () => PrintJobHistoryNotifier(),
);

/// Notifier for managing print job history
class PrintJobHistoryNotifier extends AsyncNotifier<List<PrintJobEntity>> {
  PrintJobRepository get _repository => ref.read(printJobRepositoryProvider);

  @override
  Future<List<PrintJobEntity>> build() async {
    return await _repository.getAllPrintJobs();
  }

  /// Add a print job to history
  Future<void> addPrintJob(PrintJobEntity job) async {
    state = const AsyncValue.loading();
    try {
      await _repository.savePrintJob(job);
      state = AsyncValue.data(await _repository.getAllPrintJobs());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete a print job from history
  Future<void> deletePrintJob(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePrintJob(id);
      state = AsyncValue.data(await _repository.getAllPrintJobs());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    state = const AsyncValue.loading();
    try {
      await _repository.clearAllPrintJobs();
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Get print jobs by date range
  Future<List<PrintJobEntity>> getJobsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.getPrintJobsByDateRange(start, end);
  }

  /// Get total revenue for a period
  Future<double> getTotalRevenue(DateTime start, DateTime end) async {
    final jobs = await getJobsByDateRange(start, end);
    double total = 0.0;
    for (final job in jobs) {
      total += job.suggestedPrice;
    }
    return total;
  }
}
