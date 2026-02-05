import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hudas_3d_buddy/providers/filament_provider.dart';

import '../../widgets/widgets.dart';

class FilamentManagementPage extends ConsumerStatefulWidget {
  const FilamentManagementPage({super.key});

  @override
  ConsumerState<FilamentManagementPage> createState() =>
      _FilamentManagementPageState();
}

class _FilamentManagementPageState
    extends ConsumerState<FilamentManagementPage> {
  final _formKey = GlobalKey<FormBuilderState>();
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
              dialog(provider, 'Add');
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
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          provider.removeFilament(index);
                        },
                        flex: 1,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        label: "Remove",
                        spacing: 2,
                        autoClose: true,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        provider.setEditFilament(index);
                        dialog(provider, 'Edit', index);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    title: Text(provider.filaments[index].name ?? ''),
                    subtitle: Text(
                      '''Brand: ${provider.filaments[index].brand}
Material: ${provider.filaments[index].material}
Diameter: ${provider.filaments[index].diameter}mm
Price: PHP ${provider.filaments[index].price}
Weight: ${provider.filaments[index].weight} kg
Nozzle Temp: ${provider.filaments[index].nozzleTemp}c
Bed Temp: ${provider.filaments[index].bedTemp}c
                ''',
                    ),
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

  void dialog(FilamentProvider provider, String type, [int? index]) {
    showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Dialog(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    title: Text(
                      '$type Filament',
                      style: const TextStyle(
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
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          if (type == 'Edit' && index != null) {
                            provider.editFilament(index);
                          } else {
                            provider.saveFilament();
                          }

                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete the form'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '$type Filament',
                      ),
                    ),
                  ),
                  body: FormBuilder(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormBuilderTextField(
                            name: 'name',
                            decoration: const InputDecoration(
                              labelText: 'Filament Name',
                            ),
                            initialValue: provider.inputFilament.name,
                            onChanged: (value) =>
                                provider.inputFilament.name = value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'brand',
                            decoration: const InputDecoration(
                              labelText: 'Filament Brand',
                            ),
                            initialValue: provider.inputFilament.brand,
                            onChanged: (value) =>
                                provider.inputFilament.brand = value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'material',
                            decoration: const InputDecoration(
                              labelText: 'Filament Material',
                            ),
                            initialValue: provider.inputFilament.material,
                            onChanged: (value) =>
                                provider.inputFilament.material = value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'diameter',
                            decoration: const InputDecoration(
                              labelText: 'Filament Diameter',
                            ),
                            initialValue:
                                provider.inputFilament.diameter?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputFilament.diameter = null;
                              } else {
                                provider.inputFilament.diameter =
                                    double.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'price',
                            decoration: const InputDecoration(
                              labelText: 'Filament Price per Spool',
                            ),
                            initialValue:
                                provider.inputFilament.price?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputFilament.price = null;
                              } else {
                                provider.inputFilament.price =
                                    double.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'weight',
                            decoration: const InputDecoration(
                              labelText: 'Filament Weight kg per Spool',
                            ),
                            initialValue:
                                provider.inputFilament.weight?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputFilament.weight = null;
                              } else {
                                provider.inputFilament.weight =
                                    double.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'nozzleTemp',
                            decoration: const InputDecoration(
                              labelText: 'Filament Nozzle Temp',
                            ),
                            initialValue:
                                provider.inputFilament.nozzleTemp?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputFilament.nozzleTemp = null;
                              } else {
                                provider.inputFilament.nozzleTemp =
                                    int.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'bedTemp',
                            decoration: const InputDecoration(
                              labelText: 'Filament Bed Temp',
                            ),
                            initialValue:
                                provider.inputFilament.bedTemp?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputFilament.bedTemp = null;
                              } else {
                                provider.inputFilament.bedTemp =
                                    int.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical16(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then((value) {
      if (type == 'Edit') {
        provider.clearEditFilament();
      }
    });
  }
}
