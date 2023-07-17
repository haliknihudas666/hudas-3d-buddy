import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hudas_3d_buddy/models/filament_model.dart';

final filamentProvider = ChangeNotifierProvider<FilamentProvider>((ref) {
  return FilamentProvider();
});

class FilamentProvider extends ChangeNotifier {
  FilamentModel? _selectedFilament;
  get selectedFilament => _selectedFilament;

  void setSelectedFilament(FilamentModel? filament) {
    _selectedFilament = filament;
    notifyListeners();
  }

  FilamentModel inputFilament = FilamentModel();

  void saveFilament() {
    _filaments.add(inputFilament);
    inputFilament = FilamentModel();
    notifyListeners();
  }

  final List<FilamentModel> _filaments = [];
  List<FilamentModel> get filaments => _filaments;

  void getFilaments() {
    //TODO FETCH DATA FROM HIVE
  }
}
