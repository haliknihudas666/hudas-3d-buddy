import '../entities/printer_entity.dart';

/// Repository interface for printer data operations
abstract class PrinterRepository {
  /// Get all saved printers
  Future<List<PrinterEntity>> getPrinters();

  /// Get a single printer by ID
  Future<PrinterEntity?> getPrinterById(String id);

  /// Save a new printer
  Future<void> savePrinter(PrinterEntity printer);

  /// Update an existing printer
  Future<void> updatePrinter(PrinterEntity printer);

  /// Delete a printer by ID
  Future<void> deletePrinter(String id);

  /// Delete all printers
  Future<void> deleteAllPrinters();
}
