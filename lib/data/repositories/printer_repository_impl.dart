import '../../domain/entities/printer_entity.dart';
import '../../domain/repositories/printer_repository.dart';
import '../datasources/printer_local_datasource.dart';

/// Implementation of PrinterRepository using local data source
class PrinterRepositoryImpl implements PrinterRepository {
  final PrinterLocalDataSource _localDataSource;

  PrinterRepositoryImpl(this._localDataSource);

  @override
  Future<List<PrinterEntity>> getPrinters() {
    return _localDataSource.getPrinters();
  }

  @override
  Future<PrinterEntity?> getPrinterById(String id) {
    return _localDataSource.getPrinterById(id);
  }

  @override
  Future<void> savePrinter(PrinterEntity printer) {
    return _localDataSource.savePrinter(printer);
  }

  @override
  Future<void> updatePrinter(PrinterEntity printer) {
    return _localDataSource.updatePrinter(printer);
  }

  @override
  Future<void> deletePrinter(String id) {
    return _localDataSource.deletePrinter(id);
  }

  @override
  Future<void> deleteAllPrinters() {
    return _localDataSource.deleteAllPrinters();
  }
}
