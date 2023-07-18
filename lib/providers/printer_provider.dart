import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hudas_3d_buddy/models/printer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final printerProvider = ChangeNotifierProvider<PrinterProvider>((ref) {
  return PrinterProvider(ref);
});

class PrinterProvider extends ChangeNotifier {
  final Ref _ref;
  PrinterProvider(this._ref) {
    getPrinters();
  }

  PrinterModel? _selectedPrinter;
  PrinterModel? get selectedPrinter => _selectedPrinter;

  void setSelectedPrinter(PrinterModel? printer) {
    _selectedPrinter = printer;
    notifyListeners();
  }

  PrinterModel inputPrinter = PrinterModel();

  Future<void> savePrinter() async {
    _printers.add(inputPrinter);
    inputPrinter = PrinterModel();

    writeToDevice();
    notifyListeners();
  }

  setEditPrinter(int index) {
    inputPrinter = _printers[index];

    notifyListeners();
  }

  clearEditPrinter() {
    inputPrinter = PrinterModel();

    notifyListeners();
  }

  editPrinter(int index) {
    //done this to remove refencing of inputFilament model because if not it will change all the data in the list
    var data = inputPrinter.toJson();
    _printers[index] = PrinterModel.fromJson(data);

    inputPrinter = PrinterModel();

    writeToDevice();
    notifyListeners();
  }

  removePrinter(int index) {
    _printers.removeAt(index);
    writeToDevice();
    notifyListeners();
  }

  writeToDevice() async {
    var prefs = await SharedPreferences.getInstance();

    if (_printers.isEmpty) {
      prefs.remove('printers');
    } else {
      await prefs.setString('printers', jsonEncode(_printers));
    }
  }

  List<PrinterModel> _printers = [];
  List<PrinterModel> get printers => _printers;

  Future<void> getPrinters() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('printers');

    if (data != null) {
      var decode = jsonDecode(data);

      var printerData = SavedPrinterData.fromJson(decode);
      _printers = printerData.printers ?? [];
      notifyListeners();
    }
  }
}
