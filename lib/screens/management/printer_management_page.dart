import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hudas_3d_buddy/providers/printer_provider.dart';

import '../../widgets/widgets.dart';

class PrinterManagementPage extends ConsumerStatefulWidget {
  const PrinterManagementPage({super.key});

  @override
  ConsumerState<PrinterManagementPage> createState() =>
      _PrinterManagementPageState();
}

class _PrinterManagementPageState extends ConsumerState<PrinterManagementPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(printerProvider);
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Printers'),
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
          if (provider.printers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.print),
                  SizedBox(
                    height: 10,
                  ),
                  Text('No printers added yet'),
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
                          provider.removePrinter(index);
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
                        provider.setEditPrinter(index);
                        dialog(provider, 'Edit', index);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    title: Text(provider.printers[index].name ?? ''),
                    subtitle: Text(
                      '''Brand: ${provider.printers[index].brand}
Model: ${provider.printers[index].model}
Watts: ${provider.printers[index].watts}
Printer Value: ${provider.printers[index].price}
Service Cost: ${provider.printers[index].serviceCost}
Printer Life: ${provider.printers[index].depreciationHours} hours
                ''',
                    ),
                  ),
                );
              },
              itemCount: provider.printers.length,
            );
          }
        },
      ),
    );
  }

  void dialog(PrinterProvider provider, String type, [int? index]) {
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
                      '$type Printer',
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
                            provider.editPrinter(index);
                          } else {
                            provider.savePrinter();
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
                        '$type Printer',
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
                              labelText: 'Printer Name',
                            ),
                            initialValue: provider.inputPrinter.name,
                            onChanged: (value) =>
                                provider.inputPrinter.name = value,
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
                              labelText: 'Printer Brand',
                            ),
                            initialValue: provider.inputPrinter.brand,
                            onChanged: (value) =>
                                provider.inputPrinter.brand = value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'model',
                            decoration: const InputDecoration(
                              labelText: 'Printer Model',
                            ),
                            initialValue: provider.inputPrinter.model,
                            onChanged: (value) =>
                                provider.inputPrinter.model = value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerWidget.vertical8(),
                          FormBuilderTextField(
                            name: 'watts',
                            decoration: const InputDecoration(
                              labelText: 'Power Consumption',
                            ),
                            initialValue:
                                provider.inputPrinter.watts?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputPrinter.watts = null;
                              } else {
                                provider.inputPrinter.watts =
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
                              labelText: 'Printer Value',
                            ),
                            initialValue:
                                provider.inputPrinter.price?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputPrinter.price = null;
                              } else {
                                provider.inputPrinter.price =
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
                            name: 'serviceCost',
                            decoration: const InputDecoration(
                              labelText: 'Service Cost',
                            ),
                            initialValue:
                                provider.inputPrinter.serviceCost?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputPrinter.serviceCost = null;
                              } else {
                                provider.inputPrinter.serviceCost =
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
                            name: 'depreciationHours',
                            decoration: const InputDecoration(
                              labelText: 'Total Depreciation Rate in Hours',
                            ),
                            initialValue: provider
                                .inputPrinter.depreciationHours
                                ?.toString(),
                            onChanged: (value) {
                              if (value == null) {
                                provider.inputPrinter.depreciationHours = null;
                              } else {
                                provider.inputPrinter.depreciationHours =
                                    int.parse(value);
                              }
                            },
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            textInputAction: TextInputAction.done,
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
        provider.clearEditPrinter();
      }
    });
  }
}
