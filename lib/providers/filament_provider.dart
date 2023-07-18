import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hudas_3d_buddy/models/filament_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filamentProvider = ChangeNotifierProvider<FilamentProvider>((ref) {
  return FilamentProvider(ref);
});

class FilamentProvider extends ChangeNotifier {
  final Ref? _ref;
  FilamentProvider(this._ref) {
    getFilaments();
  }

  FilamentModel? _selectedFilament;
  get selectedFilament => _selectedFilament;

  void setSelectedFilament(FilamentModel? filament) {
    _selectedFilament = filament;
    notifyListeners();
  }

  FilamentModel inputFilament = FilamentModel();

  Future<void> saveFilament() async {
    _filaments.add(inputFilament);
    inputFilament = FilamentModel();

    writeToDevice();
    notifyListeners();
  }

  void editFilament(int index) {
    //done this to remove refencing of inputFilament model because if not it will change all the data in the list
    var data = inputFilament.toJson();
    _filaments[index] = FilamentModel.fromJson(data);

    inputFilament = FilamentModel();

    writeToDevice();
    notifyListeners();
  }

  void setEditFilament(int index) {
    inputFilament = _filaments[index];

    notifyListeners();
  }

  void clearEditFilament() {
    inputFilament = FilamentModel();

    notifyListeners();
  }

  void removeFilament(int index) {
    _filaments.removeAt(index);
    writeToDevice();
    notifyListeners();
  }

  void writeToDevice() async {
    var prefs = await SharedPreferences.getInstance();

    if (_filaments.isEmpty) {
      prefs.remove('filaments');
    } else {
      await prefs.setString('filaments', jsonEncode(_filaments));
    }
  }

  List<FilamentModel> _filaments = [];
  List<FilamentModel> get filaments => _filaments;

  Future<void> getFilaments() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('filaments');

    if (data != null) {
      var decode = jsonDecode(data);

      var filamentData = SavedFilamentData.fromJson(decode);
      _filaments = filamentData.filaments ?? [];
      notifyListeners();
    }
  }
}
