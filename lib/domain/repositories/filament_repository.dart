import '../entities/filament_entity.dart';

/// Repository interface for filament data operations
abstract class FilamentRepository {
  /// Get all saved filaments
  Future<List<FilamentEntity>> getFilaments();

  /// Get a single filament by ID
  Future<FilamentEntity?> getFilamentById(String id);

  /// Save a new filament
  Future<void> saveFilament(FilamentEntity filament);

  /// Update an existing filament
  Future<void> updateFilament(FilamentEntity filament);

  /// Delete a filament by ID
  Future<void> deleteFilament(String id);

  /// Delete all filaments
  Future<void> deleteAllFilaments();
}
