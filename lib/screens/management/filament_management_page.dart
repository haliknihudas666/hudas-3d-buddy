import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hudas_3d_buddy/providers/filament_provider.dart';

import '../../widgets/widgets.dart';

class FilamentManagementPage extends ConsumerStatefulWidget {
  const FilamentManagementPage({Key? key}) : super(key: key);

  @override
  _FilamentManagementPageState createState() => _FilamentManagementPageState();
}

class _FilamentManagementPageState
    extends ConsumerState<FilamentManagementPage> {
  GlobalKey scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(filamentProvider);
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Filaments'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Scaffold(
                      key: scaffoldKey,
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: const Text(
                          'Add New Filament',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: FilledButton(
                        onPressed: () {
                          if (provider.inputFilament.brand == null ||
                              provider.inputFilament.brand!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter filament brand'),
                              ),
                            );
                          } else if (provider.inputFilament.material == null ||
                              provider.inputFilament.material!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter filament material type'),
                              ),
                            );
                          } else if (provider.inputFilament.color == null ||
                              provider.inputFilament.color!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter filament color'),
                              ),
                            );
                          } else if (provider.inputFilament.diameter == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter filament diameter'),
                              ),
                            );
                          } else if (provider.inputFilament.price == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter filament price per spool'),
                              ),
                            );
                          } else if (provider.inputFilament.weight == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter filament weight kg per spool'),
                              ),
                            );
                          } else if (provider.inputFilament.nozzleTemp ==
                              null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter filament nozzle temp'),
                              ),
                            );
                          } else if (provider.inputFilament.bedTemp == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter filament bed temp'),
                              ),
                            );
                          } else {
                            provider.saveFilament();
                            context.pop();
                          }
                        },
                        child: const Text(
                          'Add Filament',
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Name',
                              ),
                              initialValue: provider.inputFilament.name,
                              onChanged: (value) =>
                                  provider.inputFilament.name = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Brand',
                              ),
                              initialValue: provider.inputFilament.brand,
                              onChanged: (value) =>
                                  provider.inputFilament.brand = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Material',
                              ),
                              initialValue: provider.inputFilament.material,
                              onChanged: (value) =>
                                  provider.inputFilament.material = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Color',
                              ),
                              initialValue: provider.inputFilament.color,
                              onChanged: (value) =>
                                  provider.inputFilament.color = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Diameter',
                              ),
                              initialValue:
                                  provider.inputFilament.diameter?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputFilament.diameter = null;
                                } else {
                                  provider.inputFilament.diameter =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Price per Spool',
                              ),
                              initialValue:
                                  provider.inputFilament.price?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputFilament.price = null;
                                } else {
                                  provider.inputFilament.price =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Weight kg per Spool',
                              ),
                              initialValue:
                                  provider.inputFilament.weight?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputFilament.weight = null;
                                } else {
                                  provider.inputFilament.weight =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Nozzle Temp',
                              ),
                              initialValue:
                                  provider.inputFilament.nozzleTemp?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputFilament.nozzleTemp = null;
                                } else {
                                  provider.inputFilament.nozzleTemp =
                                      int.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Filament Bed Temp',
                              ),
                              initialValue:
                                  provider.inputFilament.bedTemp?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputFilament.bedTemp = null;
                                } else {
                                  provider.inputFilament.bedTemp =
                                      int.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical16(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (provider.filaments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build_circle),
                  SizedBox(
                    height: 10,
                  ),
                  Text('No filaments added yet'),
                ],
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.filaments[index].name ?? ''),
                  subtitle: Text(
                    '''Brand: ${provider.filaments[index].brand}
Material: ${provider.filaments[index].material}
Color: ${provider.filaments[index].color}
Diameter: ${provider.filaments[index].diameter}
Price: PHP ${provider.filaments[index].price}
Weight: ${provider.filaments[index].weight} kg
Nozzle Temp: ${provider.filaments[index].nozzleTemp}c
Bed Temp: ${provider.filaments[index].bedTemp}c
''',
                  ),
                );
              },
              itemCount: provider.filaments.length,
            );
          }
        },
      ),
    );
  }
}
