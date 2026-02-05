import 'package:equatable/equatable.dart';

/// Pre-processing entity for work done before printing
class PreProcessingEntity extends Equatable {
  final double modelingRatePerHour;
  final double modelingFlatFee;
  final double slicingRatePerHour;
  final double slicingFlatFee;
  final double consultationRatePerHour;
  final double fileRepairFee;
  final double customDesignSurcharge;
  final double rushOrderPercent;

  const PreProcessingEntity({
    this.modelingRatePerHour = 200.0,
    this.modelingFlatFee = 0.0,
    this.slicingRatePerHour = 100.0,
    this.slicingFlatFee = 0.0,
    this.consultationRatePerHour = 150.0,
    this.fileRepairFee = 0.0,
    this.customDesignSurcharge = 0.0,
    this.rushOrderPercent = 25.0,
  });

  /// Calculate total pre-processing cost
  double calculateCost({
    double modelingHours = 0,
    double slicingHours = 0,
    double consultationHours = 0,
    bool needsFileRepair = false,
    bool isCustomDesign = false,
    bool isRushOrder = false,
  }) {
    double cost = 0;

    // Modeling costs
    cost += modelingRatePerHour * modelingHours + modelingFlatFee;

    // Slicing costs
    cost += slicingRatePerHour * slicingHours + slicingFlatFee;

    // Consultation costs
    cost += consultationRatePerHour * consultationHours;

    // File repair fee
    if (needsFileRepair) {
      cost += fileRepairFee;
    }

    // Custom design surcharge
    if (isCustomDesign) {
      cost += customDesignSurcharge;
    }

    // Rush order premium
    if (isRushOrder) {
      cost *= (1 + rushOrderPercent / 100);
    }

    return cost;
  }

  PreProcessingEntity copyWith({
    double? modelingRatePerHour,
    double? modelingFlatFee,
    double? slicingRatePerHour,
    double? slicingFlatFee,
    double? consultationRatePerHour,
    double? fileRepairFee,
    double? customDesignSurcharge,
    double? rushOrderPercent,
  }) {
    return PreProcessingEntity(
      modelingRatePerHour: modelingRatePerHour ?? this.modelingRatePerHour,
      modelingFlatFee: modelingFlatFee ?? this.modelingFlatFee,
      slicingRatePerHour: slicingRatePerHour ?? this.slicingRatePerHour,
      slicingFlatFee: slicingFlatFee ?? this.slicingFlatFee,
      consultationRatePerHour: consultationRatePerHour ?? this.consultationRatePerHour,
      fileRepairFee: fileRepairFee ?? this.fileRepairFee,
      customDesignSurcharge: customDesignSurcharge ?? this.customDesignSurcharge,
      rushOrderPercent: rushOrderPercent ?? this.rushOrderPercent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelingRatePerHour': modelingRatePerHour,
      'modelingFlatFee': modelingFlatFee,
      'slicingRatePerHour': slicingRatePerHour,
      'slicingFlatFee': slicingFlatFee,
      'consultationRatePerHour': consultationRatePerHour,
      'fileRepairFee': fileRepairFee,
      'customDesignSurcharge': customDesignSurcharge,
      'rushOrderPercent': rushOrderPercent,
    };
  }

  factory PreProcessingEntity.fromJson(Map<String, dynamic> json) {
    return PreProcessingEntity(
      modelingRatePerHour:
          (json['modelingRatePerHour'] as num?)?.toDouble() ?? 200.0,
      modelingFlatFee: (json['modelingFlatFee'] as num?)?.toDouble() ?? 0.0,
      slicingRatePerHour:
          (json['slicingRatePerHour'] as num?)?.toDouble() ?? 100.0,
      slicingFlatFee: (json['slicingFlatFee'] as num?)?.toDouble() ?? 0.0,
      consultationRatePerHour:
          (json['consultationRatePerHour'] as num?)?.toDouble() ?? 150.0,
      fileRepairFee: (json['fileRepairFee'] as num?)?.toDouble() ?? 0.0,
      customDesignSurcharge:
          (json['customDesignSurcharge'] as num?)?.toDouble() ?? 0.0,
      rushOrderPercent: (json['rushOrderPercent'] as num?)?.toDouble() ?? 25.0,
    );
  }

  @override
  List<Object?> get props => [
        modelingRatePerHour,
        modelingFlatFee,
        slicingRatePerHour,
        slicingFlatFee,
        consultationRatePerHour,
        fileRepairFee,
        customDesignSurcharge,
        rushOrderPercent,
      ];
}
