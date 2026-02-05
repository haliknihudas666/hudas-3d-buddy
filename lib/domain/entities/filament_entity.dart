import 'package:equatable/equatable.dart';

/// Filament entity representing a 3D printer filament spool
class FilamentEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String material;
  final double diameter;
  final double pricePerSpool;
  final double weightPerSpool;
  final double density;
  final int nozzleTemp;
  final int bedTemp;
  final double wastagePercent;
  final String? color;

  const FilamentEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.material,
    this.diameter = 1.75,
    required this.pricePerSpool,
    required this.weightPerSpool,
    this.density = 1.24,
    this.nozzleTemp = 200,
    this.bedTemp = 60,
    this.wastagePercent = 5.0,
    this.color,
  });

  /// Price per gram of filament
  double get pricePerGram => pricePerSpool / weightPerSpool;

  /// Effective price per gram including wastage
  double get effectivePricePerGram =>
      pricePerGram * (1 + wastagePercent / 100);

  /// Calculate cost for a given weight
  double calculateCost(double weightGrams) {
    return effectivePricePerGram * weightGrams;
  }

  FilamentEntity copyWith({
    String? id,
    String? name,
    String? brand,
    String? material,
    double? diameter,
    double? pricePerSpool,
    double? weightPerSpool,
    double? density,
    int? nozzleTemp,
    int? bedTemp,
    double? wastagePercent,
    String? color,
  }) {
    return FilamentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      diameter: diameter ?? this.diameter,
      pricePerSpool: pricePerSpool ?? this.pricePerSpool,
      weightPerSpool: weightPerSpool ?? this.weightPerSpool,
      density: density ?? this.density,
      nozzleTemp: nozzleTemp ?? this.nozzleTemp,
      bedTemp: bedTemp ?? this.bedTemp,
      wastagePercent: wastagePercent ?? this.wastagePercent,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'material': material,
      'diameter': diameter,
      'pricePerSpool': pricePerSpool,
      'weightPerSpool': weightPerSpool,
      'density': density,
      'nozzleTemp': nozzleTemp,
      'bedTemp': bedTemp,
      'wastagePercent': wastagePercent,
      'color': color,
    };
  }

  factory FilamentEntity.fromJson(Map<String, dynamic> json) {
    return FilamentEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      material: json['material'] as String,
      diameter: (json['diameter'] as num?)?.toDouble() ?? 1.75,
      pricePerSpool: (json['pricePerSpool'] as num).toDouble(),
      weightPerSpool: (json['weightPerSpool'] as num).toDouble(),
      density: (json['density'] as num?)?.toDouble() ?? 1.24,
      nozzleTemp: (json['nozzleTemp'] as int?) ?? 200,
      bedTemp: (json['bedTemp'] as int?) ?? 60,
      wastagePercent: (json['wastagePercent'] as num?)?.toDouble() ?? 5.0,
      color: json['color'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        material,
        diameter,
        pricePerSpool,
        weightPerSpool,
        density,
        nozzleTemp,
        bedTemp,
        wastagePercent,
        color,
      ];
}
