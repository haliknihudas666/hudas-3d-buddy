import 'package:equatable/equatable.dart';

/// Printer entity representing a 3D printer
class PrinterEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String model;
  final double wattage;
  final double purchasePrice;
  final int expectedLifetimeHours;
  final double maintenanceCostPerYear;
  final double consumablesCostPerHour;
  final String? buildVolume;
  final String? notes;

  const PrinterEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    this.wattage = 200,
    required this.purchasePrice,
    this.expectedLifetimeHours = 2000,
    this.maintenanceCostPerYear = 0,
    this.consumablesCostPerHour = 0,
    this.buildVolume,
    this.notes,
  });

  /// Depreciation cost per hour based on purchase price and expected lifetime
  double get depreciationCostPerHour =>
      purchasePrice / expectedLifetimeHours;

  /// Maintenance cost per hour (assuming 2000 hours of use per year)
  double get maintenanceCostPerHour => maintenanceCostPerYear / 2000;

  /// Total printer operation cost per hour (excluding electricity)
  double get printerCostPerHour =>
      depreciationCostPerHour + maintenanceCostPerHour + consumablesCostPerHour;

  /// Calculate electricity cost for a given print time
  double calculateElectricityCost(double hours, double electricityRatePerKwh) {
    return (wattage / 1000) * hours * electricityRatePerKwh;
  }

  /// Calculate total printer cost for a given print time
  double calculateTotalPrinterCost(double hours, double electricityRatePerKwh) {
    return (printerCostPerHour * hours) +
        calculateElectricityCost(hours, electricityRatePerKwh);
  }

  PrinterEntity copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    double? wattage,
    double? purchasePrice,
    int? expectedLifetimeHours,
    double? maintenanceCostPerYear,
    double? consumablesCostPerHour,
    String? buildVolume,
    String? notes,
  }) {
    return PrinterEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      wattage: wattage ?? this.wattage,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      expectedLifetimeHours: expectedLifetimeHours ?? this.expectedLifetimeHours,
      maintenanceCostPerYear: maintenanceCostPerYear ?? this.maintenanceCostPerYear,
      consumablesCostPerHour: consumablesCostPerHour ?? this.consumablesCostPerHour,
      buildVolume: buildVolume ?? this.buildVolume,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'wattage': wattage,
      'purchasePrice': purchasePrice,
      'expectedLifetimeHours': expectedLifetimeHours,
      'maintenanceCostPerYear': maintenanceCostPerYear,
      'consumablesCostPerHour': consumablesCostPerHour,
      'buildVolume': buildVolume,
      'notes': notes,
    };
  }

  factory PrinterEntity.fromJson(Map<String, dynamic> json) {
    return PrinterEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      wattage: (json['wattage'] as num?)?.toDouble() ?? 200,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      expectedLifetimeHours: (json['expectedLifetimeHours'] as int?) ?? 2000,
      maintenanceCostPerYear:
          (json['maintenanceCostPerYear'] as num?)?.toDouble() ?? 0,
      consumablesCostPerHour:
          (json['consumablesCostPerHour'] as num?)?.toDouble() ?? 0,
      buildVolume: json['buildVolume'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        model,
        wattage,
        purchasePrice,
        expectedLifetimeHours,
        maintenanceCostPerYear,
        consumablesCostPerHour,
        buildVolume,
        notes,
      ];
}
