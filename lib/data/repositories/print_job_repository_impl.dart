import '../../domain/entities/print_job_entity.dart';
import '../../domain/repositories/print_job_repository.dart';
import '../datasources/print_job_local_datasource.dart';

/// Implementation of PrintJobRepository using local data source
class PrintJobRepositoryImpl implements PrintJobRepository {
  final PrintJobLocalDataSource _localDataSource;

  PrintJobRepositoryImpl(this._localDataSource);

  @override
  Future<List<PrintJobEntity>> getPrintJobs() {
    return _localDataSource.getPrintJobs();
  }

  @override
  Future<PrintJobEntity?> getPrintJobById(String id) {
    return _localDataSource.getPrintJobById(id);
  }

  @override
  Future<void> savePrintJob(PrintJobEntity job) {
    return _localDataSource.savePrintJob(job);
  }

  @override
  Future<void> updatePrintJob(PrintJobEntity job) {
    return _localDataSource.updatePrintJob(job);
  }

  @override
  Future<void> deletePrintJob(String id) {
    return _localDataSource.deletePrintJob(id);
  }

  @override
  Future<void> deleteAllPrintJobs() {
    return _localDataSource.deleteAllPrintJobs();
  }

  @override
  Future<List<PrintJobEntity>> getPrintJobsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _localDataSource.getPrintJobsByDateRange(start, end);
  }

  @override
  Future<List<PrintJobEntity>> getAllPrintJobs() => getPrintJobs();

  @override
  Future<void> clearAllPrintJobs() => deleteAllPrintJobs();
}
