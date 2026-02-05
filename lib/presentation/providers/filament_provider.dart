import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/filament_entity.dart';
import 'di_providers.dart';

/// State notifier for managing filament list
class FilamentNotifier extends AsyncNotifier<List<FilamentEntity>> {
  @override
  Future<List<FilamentEntity>> build() async {
    return _loadFilaments();
  }

  Future<List<FilamentEntity>> _loadFilaments() async {
    final repository = ref.read(filamentRepositoryProvider);
    return repository.getFilaments();
  }

  /// Add a new filament
  Future<void> addFilament({
    required String name,
    required String brand,
    required String material,
    required double diameter,
    required double pricePerSpool,
    required double weightPerSpool,
    double density = 1.24,
    int nozzleTemp = 200,
    int bedTemp = 60,
    double wastagePercent = 5.0,
    String? color,
  }) async {
    final repository = ref.read(filamentRepositoryProvider);
    final filament = FilamentEntity(
      id: const Uuid().v4(),
      name: name,
      brand: brand,
      material: material,
      diameter: diameter,
      pricePerSpool: pricePerSpool,
      weightPerSpool: weightPerSpool,
      density: density,
      nozzleTemp: nozzleTemp,
      bedTemp: bedTemp,
      wastagePercent: wastagePercent,
      color: color,
    );
    await repository.saveFilament(filament);
    ref.invalidateSelf();
  }

  /// Update an existing filament
  Future<void> updateFilament(FilamentEntity filament) async {
    final repository = ref.read(filamentRepositoryProvider);
    await repository.updateFilament(filament);
    ref.invalidateSelf();
  }

  /// Delete a filament
  Future<void> deleteFilament(String id) async {
    final repository = ref.read(filamentRepositoryProvider);
    await repository.deleteFilament(id);
    ref.invalidateSelf();
  }

  /// Get a filament by ID
  Future<FilamentEntity?> getFilamentById(String id) async {
    final repository = ref.read(filamentRepositoryProvider);
    return repository.getFilamentById(id);
  }
}

/// Provider for filament list
final filamentNotifierProvider =
    AsyncNotifierProvider<FilamentNotifier, List<FilamentEntity>>(
  FilamentNotifier.new,
);

/// Provider for selected filament
final selectedFilamentProvider = StateProvider<FilamentEntity?>((ref) => null);

/// Provider for filament being edited (form state)
final filamentFormProvider = StateProvider<FilamentEntity?>((ref) => null);
