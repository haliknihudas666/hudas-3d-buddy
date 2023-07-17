import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hudas_3d_buddy/models/printer_model.dart';

final printerProvider = ChangeNotifierProvider<PrinterProvider>((ref) {
  return PrinterProvider();
});

class PrinterProvider extends ChangeNotifier {
  PrinterModel? _selectedPrinter;
  PrinterModel? get selectedPrinter => _selectedPrinter;

  void setSelectedPrinter(PrinterModel? printer) {
    _selectedPrinter = printer;
    notifyListeners();
  }

  PrinterModel inputPrinter = PrinterModel();

  void savePrinter() {
    _printers.add(inputPrinter);
    inputPrinter = PrinterModel();
    notifyListeners();
  }

  final List<PrinterModel> _printers = [];
  List<PrinterModel> get printers => _printers;

  void getPrinters() {
    //TODO FETCH DATA FROM HIVE
  }
}
