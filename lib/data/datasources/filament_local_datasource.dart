import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/filament_entity.dart';

/// Local data source for filament data using SharedPreferences
class FilamentLocalDataSource {
  final SharedPreferences _prefs;

  FilamentLocalDataSource(this._prefs);

  /// Get all filaments from local storage
  Future<List<FilamentEntity>> getFilaments() async {
    final data = _prefs.getString(AppConstants.filamentsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => FilamentEntity.fromJson(json)).toList();
  }

  /// Get a single filament by ID
  Future<FilamentEntity?> getFilamentById(String id) async {
    final filaments = await getFilaments();
    try {
      return filaments.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Save a new filament
  Future<void> saveFilament(FilamentEntity filament) async {
    final filaments = await getFilaments();
    filaments.add(filament);
    await _saveFilaments(filaments);
  }

  /// Update an existing filament
  Future<void> updateFilament(FilamentEntity filament) async {
    final filaments = await getFilaments();
    final index = filaments.indexWhere((f) => f.id == filament.id);
    if (index != -1) {
      filaments[index] = filament;
      await _saveFilaments(filaments);
    }
  }

  /// Delete a filament by ID
  Future<void> deleteFilament(String id) async {
    final filaments = await getFilaments();
    filaments.removeWhere((f) => f.id == id);
    await _saveFilaments(filaments);
  }

  /// Delete all filaments
  Future<void> deleteAllFilaments() async {
    await _prefs.remove(AppConstants.filamentsKey);
  }

  /// Save filaments list to storage
  Future<void> _saveFilaments(List<FilamentEntity> filaments) async {
    final jsonList = filaments.map((f) => f.toJson()).toList();
    await _prefs.setString(AppConstants.filamentsKey, jsonEncode(jsonList));
  }
}
