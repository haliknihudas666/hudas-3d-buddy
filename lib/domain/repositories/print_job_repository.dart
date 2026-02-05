import '../entities/print_job_entity.dart';

/// Repository interface for print job data operations
abstract class PrintJobRepository {
  /// Get all saved print jobs
  Future<List<PrintJobEntity>> getPrintJobs();

  /// Alias for getPrintJobs
  Future<List<PrintJobEntity>> getAllPrintJobs() => getPrintJobs();

  /// Get a single print job by ID
  Future<PrintJobEntity?> getPrintJobById(String id);

  /// Save a new print job
  Future<void> savePrintJob(PrintJobEntity job);

  /// Update an existing print job
  Future<void> updatePrintJob(PrintJobEntity job);

  /// Delete a print job by ID
  Future<void> deletePrintJob(String id);

  /// Delete all print jobs
  Future<void> deleteAllPrintJobs();

  /// Alias for deleteAllPrintJobs
  Future<void> clearAllPrintJobs() => deleteAllPrintJobs();

  /// Get print jobs within a date range
  Future<List<PrintJobEntity>> getPrintJobsByDateRange(
    DateTime start,
    DateTime end,
  );
}
