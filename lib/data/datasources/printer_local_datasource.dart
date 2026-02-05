import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/printer_entity.dart';

/// Local data source for printer data using SharedPreferences
class PrinterLocalDataSource {
  final SharedPreferences _prefs;

  PrinterLocalDataSource(this._prefs);

  /// Get all printers from local storage
  Future<List<PrinterEntity>> getPrinters() async {
    final data = _prefs.getString(AppConstants.printersKey);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => PrinterEntity.fromJson(json)).toList();
  }

  /// Get a single printer by ID
  Future<PrinterEntity?> getPrinterById(String id) async {
    final printers = await getPrinters();
    try {
      return printers.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Save a new printer
  Future<void> savePrinter(PrinterEntity printer) async {
    final printers = await getPrinters();
    printers.add(printer);
    await _savePrinters(printers);
  }

  /// Update an existing printer
  Future<void> updatePrinter(PrinterEntity printer) async {
    final printers = await getPrinters();
    final index = printers.indexWhere((p) => p.id == printer.id);
    if (index != -1) {
      printers[index] = printer;
      await _savePrinters(printers);
    }
  }

  /// Delete a printer by ID
  Future<void> deletePrinter(String id) async {
    final printers = await getPrinters();
    printers.removeWhere((p) => p.id == id);
    await _savePrinters(printers);
  }

  /// Delete all printers
  Future<void> deleteAllPrinters() async {
    await _prefs.remove(AppConstants.printersKey);
  }

  /// Save printers list to storage
  Future<void> _savePrinters(List<PrinterEntity> printers) async {
    final jsonList = printers.map((p) => p.toJson()).toList();
    await _prefs.setString(AppConstants.printersKey, jsonEncode(jsonList));
  }
}
