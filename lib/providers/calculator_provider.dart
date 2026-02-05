import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final calculatorProvider = ChangeNotifierProvider<CalculatorProvider>((ref) {
  return CalculatorProvider();
});

class CalculatorProvider extends ChangeNotifier {
  double _electricityCostPerHour = 0;
  double get electricityCostPerHour => _electricityCostPerHour;

  double _laborCostPerHour = 0;
  double get laborCostPerHour => _laborCostPerHour;

  double _failureRatePercent = 0;
  double get failureRatePercent => _failureRatePercent;

  double _markupPercent = 100;
  double get markupPercent => _markupPercent;

  final double _subtotal = 0;
  double get subtotal => _subtotal;

  final double _subtotalWithFailures = 0;
  double get subtotalWithFailures => _subtotalWithFailures;

  Future<void> getValues() async {
    var prefs = await SharedPreferences.getInstance();
    _electricityCostPerHour = prefs.getDouble('electricityCostPerHour')!;
    _laborCostPerHour = prefs.getDouble('laborCostPerHour')!;
    _failureRatePercent = prefs.getDouble('failureRatePercent')!;
    _markupPercent = prefs.getDouble('markupPercent')!;

    notifyListeners();
  }

  Future<void> setElectricityCostPerHour(double value) async {
    _electricityCostPerHour = value;
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('electricityCostPerHour', value);
    notifyListeners();
  }

  Future<void> setLaborCostPerHour(double value) async {
    _laborCostPerHour = value;
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('laborCostPerHour', value);
    notifyListeners();
  }

  Future<void> setFailureRatePercent(double value) async {
    _failureRatePercent = value;
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('failureRatePercent', value);
    notifyListeners();
  }

  Future<void> setMarkupPercent(double value) async {
    _markupPercent = value;
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('markupPercent', value);
    notifyListeners();
  }

  double calculateFilamentCost(double grams) {
    return 0;
  }

  double calculateElectricityCost(double hours) {
    return hours * _electricityCostPerHour;
  }

  double calculateLaborCost(double hours) {
    return hours * _laborCostPerHour;
  }

  double calculateFailureCost(double hours) {
    return _subtotal * (_failureRatePercent / 100 + 1);
  }

  double calculateMarkupCost(double hours) {
    return _subtotalWithFailures * (_markupPercent / 100 + 1);
  }
}
