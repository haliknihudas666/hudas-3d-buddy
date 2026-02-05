import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/print_job_entity.dart';
import '../../domain/entities/filament_entity.dart';
import '../../domain/entities/printer_entity.dart';
import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/pre_processing_entity.dart';
import '../../domain/entities/post_processing_entity.dart';
import 'settings_provider.dart';
import 'filament_provider.dart';
import 'printer_provider.dart';
import 'di_providers.dart';
import 'print_job_history_provider.dart';

/// Calculator state for the current print job being calculated
class CalculatorState {
  final String? name;
  final String? description;
  final PrinterEntity? printer;
  final FilamentEntity? filament;
  final double printTimeHours;
  final double filamentWeightGrams;
  final int infillPercent;
  final double layerHeight;
  final int quantity;

  // Pre-processing
  final double modelingHours;
  final double slicingHours;
  final bool isCustomDesign;
  final bool isRushOrder;

  // Post-processing
  final bool needsSupportRemoval;
  final double supportRemovalHours;
  final bool needsSanding;
  final double sandingHours;
  final bool needsPainting;
  final double paintingHours;
  final bool needsCoating;
  final double coatingHours;
  final bool needsAssembly;
  final double assemblyHours;

  // Loading state
  final bool isCalculating;
  final String? errorMessage;

  const CalculatorState({
    this.name,
    this.description,
    this.printer,
    this.filament,
    this.printTimeHours = 0,
    this.filamentWeightGrams = 0,
    this.infillPercent = 20,
    this.layerHeight = 0.2,
    this.quantity = 1,
    this.modelingHours = 0,
    this.slicingHours = 0,
    this.isCustomDesign = false,
    this.isRushOrder = false,
    this.needsSupportRemoval = false,
    this.supportRemovalHours = 0,
    this.needsSanding = false,
    this.sandingHours = 0,
    this.needsPainting = false,
    this.paintingHours = 0,
    this.needsCoating = false,
    this.coatingHours = 0,
    this.needsAssembly = false,
    this.assemblyHours = 0,
    this.isCalculating = false,
    this.errorMessage,
  });

  CalculatorState copyWith({
    String? name,
    String? description,
    PrinterEntity? printer,
    FilamentEntity? filament,
    double? printTimeHours,
    double? filamentWeightGrams,
    int? infillPercent,
    double? layerHeight,
    int? quantity,
    double? modelingHours,
    double? slicingHours,
    bool? isCustomDesign,
    bool? isRushOrder,
    bool? needsSupportRemoval,
    double? supportRemovalHours,
    bool? needsSanding,
    double? sandingHours,
    bool? needsPainting,
    double? paintingHours,
    bool? needsCoating,
    double? coatingHours,
    bool? needsAssembly,
    double? assemblyHours,
    bool? isCalculating,
    String? errorMessage,
  }) {
    return CalculatorState(
      name: name ?? this.name,
      description: description ?? this.description,
      printer: printer ?? this.printer,
      filament: filament ?? this.filament,
      printTimeHours: printTimeHours ?? this.printTimeHours,
      filamentWeightGrams: filamentWeightGrams ?? this.filamentWeightGrams,
      infillPercent: infillPercent ?? this.infillPercent,
      layerHeight: layerHeight ?? this.layerHeight,
      quantity: quantity ?? this.quantity,
      modelingHours: modelingHours ?? this.modelingHours,
      slicingHours: slicingHours ?? this.slicingHours,
      isCustomDesign: isCustomDesign ?? this.isCustomDesign,
      isRushOrder: isRushOrder ?? this.isRushOrder,
      needsSupportRemoval: needsSupportRemoval ?? this.needsSupportRemoval,
      supportRemovalHours: supportRemovalHours ?? this.supportRemovalHours,
      needsSanding: needsSanding ?? this.needsSanding,
      sandingHours: sandingHours ?? this.sandingHours,
      needsPainting: needsPainting ?? this.needsPainting,
      paintingHours: paintingHours ?? this.paintingHours,
      needsCoating: needsCoating ?? this.needsCoating,
      coatingHours: coatingHours ?? this.coatingHours,
      needsAssembly: needsAssembly ?? this.needsAssembly,
      assemblyHours: assemblyHours ?? this.assemblyHours,
      isCalculating: isCalculating ?? this.isCalculating,
      errorMessage: errorMessage,
    );
  }

  /// Clear the form to start a new calculation
  CalculatorState clear() {
    return const CalculatorState();
  }

  /// Clear only the printer selection
  CalculatorState clearPrinter() {
    return copyWith()..copyWith(printer: null);
  }

  /// Clear only the filament selection
  CalculatorState clearFilament() {
    return copyWith()..copyWith(filament: null);
  }
}

/// Calculator notifier for managing print job calculations
class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    return const CalculatorState();
  }

  /// Update the state
  void updateState(CalculatorState newState) {
    state = newState;
  }

  /// Set the printer
  void setPrinter(PrinterEntity? printer) {
    state = state.copyWith(printer: printer);
  }

  /// Set the filament
  void setFilament(FilamentEntity? filament) {
    state = state.copyWith(filament: filament);
  }

  /// Update print parameters
  void updatePrintParams({
    String? name,
    String? description,
    double? printTimeHours,
    double? filamentWeightGrams,
    int? infillPercent,
    double? layerHeight,
    int? quantity,
  }) {
    state = state.copyWith(
      name: name,
      description: description,
      printTimeHours: printTimeHours,
      filamentWeightGrams: filamentWeightGrams,
      infillPercent: infillPercent,
      layerHeight: layerHeight,
      quantity: quantity,
    );
  }

  /// Update pre-processing options
  void updatePreProcessing({
    double? modelingHours,
    double? slicingHours,
    bool? isCustomDesign,
    bool? isRushOrder,
  }) {
    state = state.copyWith(
      modelingHours: modelingHours,
      slicingHours: slicingHours,
      isCustomDesign: isCustomDesign,
      isRushOrder: isRushOrder,
    );
  }

  /// Update post-processing options
  void updatePostProcessing({
    bool? needsSupportRemoval,
    double? supportRemovalHours,
    bool? needsSanding,
    double? sandingHours,
    bool? needsPainting,
    double? paintingHours,
    bool? needsCoating,
    double? coatingHours,
    bool? needsAssembly,
    double? assemblyHours,
  }) {
    state = state.copyWith(
      needsSupportRemoval: needsSupportRemoval,
      supportRemovalHours: supportRemovalHours,
      needsSanding: needsSanding,
      sandingHours: sandingHours,
      needsPainting: needsPainting,
      paintingHours: paintingHours,
      needsCoating: needsCoating,
      coatingHours: coatingHours,
      needsAssembly: needsAssembly,
      assemblyHours: assemblyHours,
    );
  }

  /// Clear the calculator state
  void clear() {
    state = const CalculatorState();
  }

  /// Calculate the total cost and return a PrintJobEntity
  Future<PrintJobEntity?> calculateCost() async {
    if (state.printer == null || state.filament == null) {
      state = state.copyWith(
        errorMessage: 'Please select a printer and filament',
      );
      return null;
    }

    state = state.copyWith(isCalculating: true, errorMessage: null);

    try {
      final generalSettings = await ref.read(generalSettingsProvider.future);
      final preProcessingSettings =
          await ref.read(preProcessingSettingsProvider.future);
      final postProcessingSettings =
          await ref.read(postProcessingSettingsProvider.future);

      // Calculate individual costs
      final filamentCost =
          state.filament!.calculateCost(state.filamentWeightGrams) *
              state.quantity;

      final electricityCost = state.printer!.calculateElectricityCost(
            state.printTimeHours,
            generalSettings.electricityRatePerKwh,
          ) *
          state.quantity;

      final printerCost = state.printer!.printerCostPerHour *
          state.printTimeHours *
          state.quantity;

      final laborCost = generalSettings.laborRatePerHour *
          state.printTimeHours *
          state.quantity;

      final preProcessingCost = preProcessingSettings.calculateCost(
        modelingHours: state.modelingHours,
        slicingHours: state.slicingHours,
        isCustomDesign: state.isCustomDesign,
        isRushOrder: state.isRushOrder,
      );

      final postProcessingCost = postProcessingSettings.calculateCost(
        supportRemovalHours: state.supportRemovalHours,
        sandingHours: state.sandingHours,
        paintingHours: state.paintingHours,
        coatingHours: state.coatingHours,
        assemblyHours: state.assemblyHours,
        needsSupportRemoval: state.needsSupportRemoval,
        needsSanding: state.needsSanding,
        needsPainting: state.needsPainting,
        needsCoating: state.needsCoating,
        needsAssembly: state.needsAssembly,
      );

      // Calculate subtotal
      final subtotal = filamentCost +
          electricityCost +
          printerCost +
          laborCost +
          preProcessingCost +
          postProcessingCost;

      // Apply failure buffer
      final failureBuffer =
          subtotal * (generalSettings.failureRatePercent / 100);

      // Calculate with failure buffer
      final subtotalWithFailure = subtotal + failureBuffer;

      // Apply markup
      final markup =
          subtotalWithFailure * (generalSettings.markupPercent / 100);

      // Calculate total before tax
      final totalBeforeTax =
          subtotalWithFailure + markup + generalSettings.packagingCostPerItem;

      // Apply tax if enabled
      final tax = generalSettings.includeTax
          ? totalBeforeTax * (generalSettings.taxPercent / 100)
          : 0.0;

      final totalCost =
          totalBeforeTax + tax + generalSettings.shippingBasePrice;

      // Suggested price (total cost is the suggested price with markup)
      final suggestedPrice = totalCost;

      final printJob = PrintJobEntity(
        id: const Uuid().v4(),
        name: state.name,
        description: state.description,
        printerId: state.printer!.id,
        filamentId: state.filament!.id,
        printTimeHours: state.printTimeHours,
        filamentWeightGrams: state.filamentWeightGrams,
        infillPercent: state.infillPercent,
        layerHeight: state.layerHeight,
        quantity: state.quantity,
        filamentCost: filamentCost,
        electricityCost: electricityCost,
        printerCost: printerCost,
        laborCost: laborCost,
        preProcessingCost: preProcessingCost,
        postProcessingCost: postProcessingCost,
        subtotal: subtotal,
        failureBuffer: failureBuffer,
        markup: markup,
        tax: tax,
        packagingCost: generalSettings.packagingCostPerItem,
        shippingCost: generalSettings.shippingBasePrice,
        totalCost: totalCost,
        suggestedPrice: suggestedPrice,
        modelingHours: state.modelingHours,
        slicingHours: state.slicingHours,
        isCustomDesign: state.isCustomDesign,
        isRushOrder: state.isRushOrder,
        needsSupportRemoval: state.needsSupportRemoval,
        supportRemovalHours: state.supportRemovalHours,
        needsSanding: state.needsSanding,
        sandingHours: state.sandingHours,
        needsPainting: state.needsPainting,
        paintingHours: state.paintingHours,
        needsCoating: state.needsCoating,
        coatingHours: state.coatingHours,
        needsAssembly: state.needsAssembly,
        assemblyHours: state.assemblyHours,
      );

      state = state.copyWith(isCalculating: false);
      return printJob;
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        errorMessage: 'Calculation error: $e',
      );
      return null;
    }
  }

  /// Save the current calculation to history
  Future<bool> saveToHistory(PrintJobEntity job) async {
    try {
      // Use the history provider to save, which will automatically update the history list
      await ref.read(printJobHistoryProvider.notifier).addPrintJob(job);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save: $e');
      return false;
    }
  }
}

/// Provider for calculator state
final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(
  CalculatorNotifier.new,
);

/// Provider for the last calculated print job
final lastCalculatedJobProvider = StateProvider<PrintJobEntity?>((ref) => null);
