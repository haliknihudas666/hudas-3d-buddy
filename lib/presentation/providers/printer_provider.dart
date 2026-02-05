import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/printer_entity.dart';
import 'di_providers.dart';

/// State notifier for managing printer list
class PrinterNotifier extends AsyncNotifier<List<PrinterEntity>> {
  @override
  Future<List<PrinterEntity>> build() async {
    return _loadPrinters();
  }

  Future<List<PrinterEntity>> _loadPrinters() async {
    final repository = ref.read(printerRepositoryProvider);
    return repository.getPrinters();
  }

  /// Add a new printer
  Future<void> addPrinter({
    required String name,
    required String brand,
    required String model,
    required double wattage,
    required double purchasePrice,
    double maintenanceCostPerYear = 0.0,
    int expectedLifetimeHours = 2000,
    double consumablesCostPerHour = 0.0,
    String? buildVolume,
    String? notes,
  }) async {
    final repository = ref.read(printerRepositoryProvider);
    final printer = PrinterEntity(
      id: const Uuid().v4(),
      name: name,
      brand: brand,
      model: model,
      wattage: wattage,
      purchasePrice: purchasePrice,
      maintenanceCostPerYear: maintenanceCostPerYear,
      expectedLifetimeHours: expectedLifetimeHours,
      consumablesCostPerHour: consumablesCostPerHour,
      buildVolume: buildVolume,
      notes: notes,
    );
    await repository.savePrinter(printer);
    ref.invalidateSelf();
  }

  /// Update an existing printer
  Future<void> updatePrinter(PrinterEntity printer) async {
    final repository = ref.read(printerRepositoryProvider);
    await repository.updatePrinter(printer);
    ref.invalidateSelf();
  }

  /// Delete a printer
  Future<void> deletePrinter(String id) async {
    final repository = ref.read(printerRepositoryProvider);
    await repository.deletePrinter(id);
    ref.invalidateSelf();
  }

  /// Get a printer by ID
  Future<PrinterEntity?> getPrinterById(String id) async {
    final repository = ref.read(printerRepositoryProvider);
    return repository.getPrinterById(id);
  }
}

/// Provider for printer list
final printerNotifierProvider =
    AsyncNotifierProvider<PrinterNotifier, List<PrinterEntity>>(
  PrinterNotifier.new,
);

/// Provider for selected printer
final selectedPrinterProvider = StateProvider<PrinterEntity?>((ref) => null);

/// Provider for printer being edited (form state)
final printerFormProvider = StateProvider<PrinterEntity?>((ref) => null);
