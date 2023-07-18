import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hudas_3d_buddy/models/filament_model.dart';
import 'package:hudas_3d_buddy/providers/printer_provider.dart';

import '../../models/printer_model.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? filamentValue;
  @override
  Widget build(BuildContext context) {
    final printersProvider = ref.watch(printerProvider);
    final filamentsProvider = ref.watch(filamentProvider);
    final calcuProvider = ref.watch(calculatorProvider);
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Calculate'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.print),
            trailing: printersProvider.selectedPrinter != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      printersProvider.setSelectedPrinter(null);
                    },
                  )
                : null,
            title: DropdownButtonHideUnderline(
              child: DropdownButton<PrinterModel?>(
                value: printersProvider.selectedPrinter,
                hint: const Text('Select Printer'),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Theme.of(context).primaryColor),
                // underline: Container(
                //   height: 2,
                //   color: Colors.deepPurpleAccent,
                // ),
                onChanged: (newValue) {
                  printersProvider.setSelectedPrinter(newValue);
                },
                items: printersProvider.printers
                    .map<DropdownMenuItem<PrinterModel?>>((value) {
                  return DropdownMenuItem<PrinterModel>(
                    value: value,
                    child: Text(
                      value.name ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.build_circle),
            trailing: filamentsProvider.selectedFilament != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      filamentsProvider.setSelectedFilament(null);
                    },
                  )
                : null,
            title: DropdownButtonHideUnderline(
              child: DropdownButton<FilamentModel?>(
                value: filamentsProvider.selectedFilament,
                hint: const Text('Select Filament'),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Theme.of(context).primaryColor),
                // underline: Container(
                //   height: 2,
                //   color: Colors.deepPurpleAccent,
                // ),
                onChanged: (newValue) {
                  filamentsProvider.setSelectedFilament(newValue);
                },
                items: filamentsProvider.filaments
                    .map<DropdownMenuItem<FilamentModel?>>((value) {
                  return DropdownMenuItem<FilamentModel>(
                    value: value,
                    child: Text(
                      value.name ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
