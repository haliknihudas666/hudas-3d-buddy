import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/filament_local_datasource.dart';
import '../../data/datasources/printer_local_datasource.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/datasources/print_job_local_datasource.dart';
import '../../data/repositories/filament_repository_impl.dart';
import '../../data/repositories/printer_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/print_job_repository_impl.dart';
import '../../domain/repositories/filament_repository.dart';
import '../../domain/repositories/printer_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/print_job_repository.dart';

// ==================== Shared Preferences ====================

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

// ==================== Data Sources ====================

/// Provider for FilamentLocalDataSource
final filamentLocalDataSourceProvider = Provider<FilamentLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FilamentLocalDataSource(prefs);
});

/// Provider for PrinterLocalDataSource
final printerLocalDataSourceProvider = Provider<PrinterLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrinterLocalDataSource(prefs);
});

/// Provider for SettingsLocalDataSource
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsLocalDataSource(prefs);
});

/// Provider for PrintJobLocalDataSource
final printJobLocalDataSourceProvider = Provider<PrintJobLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrintJobLocalDataSource(prefs);
});

// ==================== Repositories ====================

/// Provider for FilamentRepository
final filamentRepositoryProvider = Provider<FilamentRepository>((ref) {
  final dataSource = ref.watch(filamentLocalDataSourceProvider);
  return FilamentRepositoryImpl(dataSource);
});

/// Provider for PrinterRepository
final printerRepositoryProvider = Provider<PrinterRepository>((ref) {
  final dataSource = ref.watch(printerLocalDataSourceProvider);
  return PrinterRepositoryImpl(dataSource);
});

/// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
});

/// Provider for PrintJobRepository
final printJobRepositoryProvider = Provider<PrintJobRepository>((ref) {
  final dataSource = ref.watch(printJobLocalDataSourceProvider);
  return PrintJobRepositoryImpl(dataSource);
});
