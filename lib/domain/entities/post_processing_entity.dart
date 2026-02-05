import 'package:equatable/equatable.dart';

/// Post-processing entity for work done after printing
class PostProcessingEntity extends Equatable {
  final double supportRemovalRatePerHour;
  final double supportRemovalFlatFee;
  final double sandingRatePerHour;
  final double sandingFlatFee;
  final double paintingRatePerHour;
  final double paintingMaterialCost;
  final double paintingFlatFee;
  final double coatingRatePerHour;
  final double coatingMaterialCost;
  final double assemblyRatePerHour;
  final double assemblyFlatFee;
  final double heatTreatmentFee;
  final double vaporSmoothingFee;
  final double inspectionFee;

  const PostProcessingEntity({
    this.supportRemovalRatePerHour = 100.0,
    this.supportRemovalFlatFee = 0.0,
    this.sandingRatePerHour = 100.0,
    this.sandingFlatFee = 0.0,
    this.paintingRatePerHour = 150.0,
    this.paintingMaterialCost = 0.0,
    this.paintingFlatFee = 0.0,
    this.coatingRatePerHour = 100.0,
    this.coatingMaterialCost = 0.0,
    this.assemblyRatePerHour = 100.0,
    this.assemblyFlatFee = 0.0,
    this.heatTreatmentFee = 0.0,
    this.vaporSmoothingFee = 0.0,
    this.inspectionFee = 0.0,
  });

  /// Calculate total post-processing cost
  double calculateCost({
    double supportRemovalHours = 0,
    double sandingHours = 0,
    double paintingHours = 0,
    double coatingHours = 0,
    double assemblyHours = 0,
    bool needsSupportRemoval = false,
    bool needsSanding = false,
    bool needsPainting = false,
    bool needsCoating = false,
    bool needsAssembly = false,
    bool needsHeatTreatment = false,
    bool needsVaporSmoothing = false,
    bool needsInspection = false,
  }) {
    double cost = 0;

    // Support removal
    if (needsSupportRemoval) {
      cost += supportRemovalRatePerHour * supportRemovalHours +
          supportRemovalFlatFee;
    }

    // Sanding
    if (needsSanding) {
      cost += sandingRatePerHour * sandingHours + sandingFlatFee;
    }

    // Painting
    if (needsPainting) {
      cost += paintingRatePerHour * paintingHours +
          paintingMaterialCost +
          paintingFlatFee;
    }

    // Coating
    if (needsCoating) {
      cost += coatingRatePerHour * coatingHours + coatingMaterialCost;
    }

    // Assembly
    if (needsAssembly) {
      cost += assemblyRatePerHour * assemblyHours + assemblyFlatFee;
    }

    // Special treatments
    if (needsHeatTreatment) {
      cost += heatTreatmentFee;
    }

    if (needsVaporSmoothing) {
      cost += vaporSmoothingFee;
    }

    if (needsInspection) {
      cost += inspectionFee;
    }

    return cost;
  }

  PostProcessingEntity copyWith({
    double? supportRemovalRatePerHour,
    double? supportRemovalFlatFee,
    double? sandingRatePerHour,
    double? sandingFlatFee,
    double? paintingRatePerHour,
    double? paintingMaterialCost,
    double? paintingFlatFee,
    double? coatingRatePerHour,
    double? coatingMaterialCost,
    double? assemblyRatePerHour,
    double? assemblyFlatFee,
    double? heatTreatmentFee,
    double? vaporSmoothingFee,
    double? inspectionFee,
  }) {
    return PostProcessingEntity(
      supportRemovalRatePerHour:
          supportRemovalRatePerHour ?? this.supportRemovalRatePerHour,
      supportRemovalFlatFee:
          supportRemovalFlatFee ?? this.supportRemovalFlatFee,
      sandingRatePerHour: sandingRatePerHour ?? this.sandingRatePerHour,
      sandingFlatFee: sandingFlatFee ?? this.sandingFlatFee,
      paintingRatePerHour: paintingRatePerHour ?? this.paintingRatePerHour,
      paintingMaterialCost: paintingMaterialCost ?? this.paintingMaterialCost,
      paintingFlatFee: paintingFlatFee ?? this.paintingFlatFee,
      coatingRatePerHour: coatingRatePerHour ?? this.coatingRatePerHour,
      coatingMaterialCost: coatingMaterialCost ?? this.coatingMaterialCost,
      assemblyRatePerHour: assemblyRatePerHour ?? this.assemblyRatePerHour,
      assemblyFlatFee: assemblyFlatFee ?? this.assemblyFlatFee,
      heatTreatmentFee: heatTreatmentFee ?? this.heatTreatmentFee,
      vaporSmoothingFee: vaporSmoothingFee ?? this.vaporSmoothingFee,
      inspectionFee: inspectionFee ?? this.inspectionFee,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supportRemovalRatePerHour': supportRemovalRatePerHour,
      'supportRemovalFlatFee': supportRemovalFlatFee,
      'sandingRatePerHour': sandingRatePerHour,
      'sandingFlatFee': sandingFlatFee,
      'paintingRatePerHour': paintingRatePerHour,
      'paintingMaterialCost': paintingMaterialCost,
      'paintingFlatFee': paintingFlatFee,
      'coatingRatePerHour': coatingRatePerHour,
      'coatingMaterialCost': coatingMaterialCost,
      'assemblyRatePerHour': assemblyRatePerHour,
      'assemblyFlatFee': assemblyFlatFee,
      'heatTreatmentFee': heatTreatmentFee,
      'vaporSmoothingFee': vaporSmoothingFee,
      'inspectionFee': inspectionFee,
    };
  }

  factory PostProcessingEntity.fromJson(Map<String, dynamic> json) {
    return PostProcessingEntity(
      supportRemovalRatePerHour:
          (json['supportRemovalRatePerHour'] as num?)?.toDouble() ?? 100.0,
      supportRemovalFlatFee:
          (json['supportRemovalFlatFee'] as num?)?.toDouble() ?? 0.0,
      sandingRatePerHour:
          (json['sandingRatePerHour'] as num?)?.toDouble() ?? 100.0,
      sandingFlatFee: (json['sandingFlatFee'] as num?)?.toDouble() ?? 0.0,
      paintingRatePerHour:
          (json['paintingRatePerHour'] as num?)?.toDouble() ?? 150.0,
      paintingMaterialCost:
          (json['paintingMaterialCost'] as num?)?.toDouble() ?? 0.0,
      paintingFlatFee: (json['paintingFlatFee'] as num?)?.toDouble() ?? 0.0,
      coatingRatePerHour:
          (json['coatingRatePerHour'] as num?)?.toDouble() ?? 100.0,
      coatingMaterialCost:
          (json['coatingMaterialCost'] as num?)?.toDouble() ?? 0.0,
      assemblyRatePerHour:
          (json['assemblyRatePerHour'] as num?)?.toDouble() ?? 100.0,
      assemblyFlatFee: (json['assemblyFlatFee'] as num?)?.toDouble() ?? 0.0,
      heatTreatmentFee:
          (json['heatTreatmentFee'] as num?)?.toDouble() ?? 0.0,
      vaporSmoothingFee:
          (json['vaporSmoothingFee'] as num?)?.toDouble() ?? 0.0,
      inspectionFee: (json['inspectionFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        supportRemovalRatePerHour,
        supportRemovalFlatFee,
        sandingRatePerHour,
        sandingFlatFee,
        paintingRatePerHour,
        paintingMaterialCost,
        paintingFlatFee,
        coatingRatePerHour,
        coatingMaterialCost,
        assemblyRatePerHour,
        assemblyFlatFee,
        heatTreatmentFee,
        vaporSmoothingFee,
        inspectionFee,
      ];
}
