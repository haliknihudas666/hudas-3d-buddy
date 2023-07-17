import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hudas_3d_buddy/providers/printer_provider.dart';

import '../../widgets/widgets.dart';

class PrinterManagementPage extends ConsumerStatefulWidget {
  const PrinterManagementPage({Key? key}) : super(key: key);

  @override
  _PrinterManagementPageState createState() => _PrinterManagementPageState();
}

class _PrinterManagementPageState extends ConsumerState<PrinterManagementPage> {
  GlobalKey scaffoldKey = GlobalKey();
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
                          'Add New Printer',
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
                          if (provider.inputPrinter.name == null ||
                              provider.inputPrinter.name!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a printer name'),
                              ),
                            );
                          } else if (provider.inputPrinter.brand == null ||
                              provider.inputPrinter.brand!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a brand name'),
                              ),
                            );
                          } else if (provider.inputPrinter.model == null ||
                              provider.inputPrinter.model!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a model name'),
                              ),
                            );
                          } else if (provider.inputPrinter.watts == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter a power consumption'),
                              ),
                            );
                          } else if (provider.inputPrinter.price == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a printer value'),
                              ),
                            );
                          } else if (provider.inputPrinter.serviceCost ==
                              null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter a printer service cost'),
                              ),
                            );
                          } else if (provider.inputPrinter.depreciationHours ==
                              null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter a total depreciation hours'),
                              ),
                            );
                          } else {
                            provider.savePrinter();
                            context.pop();
                          }
                        },
                        child: const Text(
                          'Add Printer',
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Printer Name',
                              ),
                              initialValue: provider.inputPrinter.name,
                              onChanged: (value) =>
                                  provider.inputPrinter.name = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Printer Brand',
                              ),
                              initialValue: provider.inputPrinter.brand,
                              onChanged: (value) =>
                                  provider.inputPrinter.brand = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Printer Model',
                              ),
                              initialValue: provider.inputPrinter.model,
                              onChanged: (value) =>
                                  provider.inputPrinter.model = value,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Power Consumption',
                              ),
                              initialValue:
                                  provider.inputPrinter.watts?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputPrinter.watts = null;
                                } else {
                                  provider.inputPrinter.watts =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Printer Value',
                              ),
                              initialValue:
                                  provider.inputPrinter.price?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputPrinter.price = null;
                                } else {
                                  provider.inputPrinter.price =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Service Cost',
                              ),
                              initialValue:
                                  provider.inputPrinter.serviceCost?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputPrinter.serviceCost = null;
                                } else {
                                  provider.inputPrinter.serviceCost =
                                      double.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SpacerWidget.vertical8(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Total Depreciation Rate in Hours',
                              ),
                              initialValue: provider
                                  .inputPrinter.depreciationHours
                                  ?.toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.inputPrinter.depreciationHours =
                                      null;
                                } else {
                                  provider.inputPrinter.depreciationHours =
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
                return ListTile(
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
                );
              },
              itemCount: provider.printers.length,
            );
          }
        },
      ),
    );
  }
}
