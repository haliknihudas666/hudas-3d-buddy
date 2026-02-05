import 'package:equatable/equatable.dart';

/// Print job entity representing a calculated print job
class PrintJobEntity extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final String? printerId;
  final String? filamentId;
  final double printTimeHours;
  final double filamentWeightGrams;
  final int infillPercent;
  final double layerHeight;
  final int quantity;

  // Cost breakdown
  final double filamentCost;
  final double electricityCost;
  final double printerCost;
  final double laborCost;
  final double preProcessingCost;
  final double postProcessingCost;
  final double subtotal;
  final double failureBuffer;
  final double markup;
  final double tax;
  final double packagingCost;
  final double shippingCost;
  final double totalCost;
  final double suggestedPrice;

  // Pre-processing details
  final double? modelingHours;
  final double? slicingHours;
  final bool isCustomDesign;
  final bool isRushOrder;

  // Post-processing details
  final bool needsSupportRemoval;
  final double? supportRemovalHours;
  final bool needsSanding;
  final double? sandingHours;
  final bool needsPainting;
  final double? paintingHours;
  final bool needsCoating;
  final double? coatingHours;
  final bool needsAssembly;
  final double? assemblyHours;

  // Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PrintJobEntity({
    required this.id,
    this.name,
    this.description,
    this.printerId,
    this.filamentId,
    this.printTimeHours = 0,
    this.filamentWeightGrams = 0,
    this.infillPercent = 20,
    this.layerHeight = 0.2,
    this.quantity = 1,
    this.filamentCost = 0,
    this.electricityCost = 0,
    this.printerCost = 0,
    this.laborCost = 0,
    this.preProcessingCost = 0,
    this.postProcessingCost = 0,
    this.subtotal = 0,
    this.failureBuffer = 0,
    this.markup = 0,
    this.tax = 0,
    this.packagingCost = 0,
    this.shippingCost = 0,
    this.totalCost = 0,
    this.suggestedPrice = 0,
    this.modelingHours,
    this.slicingHours,
    this.isCustomDesign = false,
    this.isRushOrder = false,
    this.needsSupportRemoval = false,
    this.supportRemovalHours,
    this.needsSanding = false,
    this.sandingHours,
    this.needsPainting = false,
    this.paintingHours,
    this.needsCoating = false,
    this.coatingHours,
    this.needsAssembly = false,
    this.assemblyHours,
    this.createdAt,
    this.updatedAt,
  });

  /// Profit margin percentage (Margin = Profit / Revenue)
  double get profitMargin {
    if (totalCost <= 0) return 0;
    return (markup / totalCost) * 100;
  }

  /// Markup percentage (Markup = Profit / Cost)
  double get markupPercentage {
    final costBasis = subtotal + failureBuffer;
    if (costBasis <= 0) return 0;
    return (markup / costBasis) * 100;
  }

  /// Cost per unit
  double get costPerUnit {
    if (quantity <= 0) return totalCost;
    return totalCost / quantity;
  }

  /// Price per unit
  double get pricePerUnit {
    if (quantity <= 0) return suggestedPrice;
    return suggestedPrice / quantity;
  }

  PrintJobEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? printerId,
    String? filamentId,
    double? printTimeHours,
    double? filamentWeightGrams,
    int? infillPercent,
    double? layerHeight,
    int? quantity,
    double? filamentCost,
    double? electricityCost,
    double? printerCost,
    double? laborCost,
    double? preProcessingCost,
    double? postProcessingCost,
    double? subtotal,
    double? failureBuffer,
    double? markup,
    double? tax,
    double? packagingCost,
    double? shippingCost,
    double? totalCost,
    double? suggestedPrice,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrintJobEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      printerId: printerId ?? this.printerId,
      filamentId: filamentId ?? this.filamentId,
      printTimeHours: printTimeHours ?? this.printTimeHours,
      filamentWeightGrams: filamentWeightGrams ?? this.filamentWeightGrams,
      infillPercent: infillPercent ?? this.infillPercent,
      layerHeight: layerHeight ?? this.layerHeight,
      quantity: quantity ?? this.quantity,
      filamentCost: filamentCost ?? this.filamentCost,
      electricityCost: electricityCost ?? this.electricityCost,
      printerCost: printerCost ?? this.printerCost,
      laborCost: laborCost ?? this.laborCost,
      preProcessingCost: preProcessingCost ?? this.preProcessingCost,
      postProcessingCost: postProcessingCost ?? this.postProcessingCost,
      subtotal: subtotal ?? this.subtotal,
      failureBuffer: failureBuffer ?? this.failureBuffer,
      markup: markup ?? this.markup,
      tax: tax ?? this.tax,
      packagingCost: packagingCost ?? this.packagingCost,
      shippingCost: shippingCost ?? this.shippingCost,
      totalCost: totalCost ?? this.totalCost,
      suggestedPrice: suggestedPrice ?? this.suggestedPrice,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'printerId': printerId,
      'filamentId': filamentId,
      'printTimeHours': printTimeHours,
      'filamentWeightGrams': filamentWeightGrams,
      'infillPercent': infillPercent,
      'layerHeight': layerHeight,
      'quantity': quantity,
      'filamentCost': filamentCost,
      'electricityCost': electricityCost,
      'printerCost': printerCost,
      'laborCost': laborCost,
      'preProcessingCost': preProcessingCost,
      'postProcessingCost': postProcessingCost,
      'subtotal': subtotal,
      'failureBuffer': failureBuffer,
      'markup': markup,
      'tax': tax,
      'packagingCost': packagingCost,
      'shippingCost': shippingCost,
      'totalCost': totalCost,
      'suggestedPrice': suggestedPrice,
      'modelingHours': modelingHours,
      'slicingHours': slicingHours,
      'isCustomDesign': isCustomDesign,
      'isRushOrder': isRushOrder,
      'needsSupportRemoval': needsSupportRemoval,
      'supportRemovalHours': supportRemovalHours,
      'needsSanding': needsSanding,
      'sandingHours': sandingHours,
      'needsPainting': needsPainting,
      'paintingHours': paintingHours,
      'needsCoating': needsCoating,
      'coatingHours': coatingHours,
      'needsAssembly': needsAssembly,
      'assemblyHours': assemblyHours,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PrintJobEntity.fromJson(Map<String, dynamic> json) {
    return PrintJobEntity(
      id: json['id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      printerId: json['printerId'] as String?,
      filamentId: json['filamentId'] as String?,
      printTimeHours: (json['printTimeHours'] as num?)?.toDouble() ?? 0,
      filamentWeightGrams:
          (json['filamentWeightGrams'] as num?)?.toDouble() ?? 0,
      infillPercent: (json['infillPercent'] as int?) ?? 20,
      layerHeight: (json['layerHeight'] as num?)?.toDouble() ?? 0.2,
      quantity: (json['quantity'] as int?) ?? 1,
      filamentCost: (json['filamentCost'] as num?)?.toDouble() ?? 0,
      electricityCost: (json['electricityCost'] as num?)?.toDouble() ?? 0,
      printerCost: (json['printerCost'] as num?)?.toDouble() ?? 0,
      laborCost: (json['laborCost'] as num?)?.toDouble() ?? 0,
      preProcessingCost: (json['preProcessingCost'] as num?)?.toDouble() ?? 0,
      postProcessingCost: (json['postProcessingCost'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      failureBuffer: (json['failureBuffer'] as num?)?.toDouble() ?? 0,
      markup: (json['markup'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      packagingCost: (json['packagingCost'] as num?)?.toDouble() ?? 0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0,
      suggestedPrice: (json['suggestedPrice'] as num?)?.toDouble() ?? 0,
      modelingHours: (json['modelingHours'] as num?)?.toDouble(),
      slicingHours: (json['slicingHours'] as num?)?.toDouble(),
      isCustomDesign: (json['isCustomDesign'] as bool?) ?? false,
      isRushOrder: (json['isRushOrder'] as bool?) ?? false,
      needsSupportRemoval: (json['needsSupportRemoval'] as bool?) ?? false,
      supportRemovalHours: (json['supportRemovalHours'] as num?)?.toDouble(),
      needsSanding: (json['needsSanding'] as bool?) ?? false,
      sandingHours: (json['sandingHours'] as num?)?.toDouble(),
      needsPainting: (json['needsPainting'] as bool?) ?? false,
      paintingHours: (json['paintingHours'] as num?)?.toDouble(),
      needsCoating: (json['needsCoating'] as bool?) ?? false,
      coatingHours: (json['coatingHours'] as num?)?.toDouble(),
      needsAssembly: (json['needsAssembly'] as bool?) ?? false,
      assemblyHours: (json['assemblyHours'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        printerId,
        filamentId,
        printTimeHours,
        filamentWeightGrams,
        infillPercent,
        layerHeight,
        quantity,
        filamentCost,
        electricityCost,
        printerCost,
        laborCost,
        preProcessingCost,
        postProcessingCost,
        subtotal,
        failureBuffer,
        markup,
        tax,
        packagingCost,
        shippingCost,
        totalCost,
        suggestedPrice,
        createdAt,
      ];
}
