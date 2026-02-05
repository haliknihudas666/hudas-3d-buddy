import '../../domain/entities/filament_entity.dart';
import '../../domain/repositories/filament_repository.dart';
import '../datasources/filament_local_datasource.dart';

/// Implementation of FilamentRepository using local data source
class FilamentRepositoryImpl implements FilamentRepository {
  final FilamentLocalDataSource _localDataSource;

  FilamentRepositoryImpl(this._localDataSource);

  @override
  Future<List<FilamentEntity>> getFilaments() {
    return _localDataSource.getFilaments();
  }

  @override
  Future<FilamentEntity?> getFilamentById(String id) {
    return _localDataSource.getFilamentById(id);
  }

  @override
  Future<void> saveFilament(FilamentEntity filament) {
    return _localDataSource.saveFilament(filament);
  }

  @override
  Future<void> updateFilament(FilamentEntity filament) {
    return _localDataSource.updateFilament(filament);
  }

  @override
  Future<void> deleteFilament(String id) {
    return _localDataSource.deleteFilament(id);
  }

  @override
  Future<void> deleteAllFilaments() {
    return _localDataSource.deleteAllFilaments();
  }
}
