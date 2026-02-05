import 'package:equatable/equatable.dart';

/// General settings entity for the calculator
class GeneralSettingsEntity extends Equatable {
  final String currency;
  final double electricityRatePerKwh;
  final double laborRatePerHour;
  final double failureRatePercent;
  final double markupPercent;
  final double packagingCostPerItem;
  final double shippingBasePrice;
  final bool includeTax;
  final double taxPercent;

  const GeneralSettingsEntity({
    this.currency = 'PHP',
    this.electricityRatePerKwh = 12.0,
    this.laborRatePerHour = 100.0,
    this.failureRatePercent = 5.0,
    this.markupPercent = 30.0,
    this.packagingCostPerItem = 0.0,
    this.shippingBasePrice = 0.0,
    this.includeTax = false,
    this.taxPercent = 12.0,
  });

  GeneralSettingsEntity copyWith({
    String? currency,
    double? electricityRatePerKwh,
    double? laborRatePerHour,
    double? failureRatePercent,
    double? markupPercent,
    double? packagingCostPerItem,
    double? shippingBasePrice,
    bool? includeTax,
    double? taxPercent,
  }) {
    return GeneralSettingsEntity(
      currency: currency ?? this.currency,
      electricityRatePerKwh: electricityRatePerKwh ?? this.electricityRatePerKwh,
      laborRatePerHour: laborRatePerHour ?? this.laborRatePerHour,
      failureRatePercent: failureRatePercent ?? this.failureRatePercent,
      markupPercent: markupPercent ?? this.markupPercent,
      packagingCostPerItem: packagingCostPerItem ?? this.packagingCostPerItem,
      shippingBasePrice: shippingBasePrice ?? this.shippingBasePrice,
      includeTax: includeTax ?? this.includeTax,
      taxPercent: taxPercent ?? this.taxPercent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'electricityRatePerKwh': electricityRatePerKwh,
      'laborRatePerHour': laborRatePerHour,
      'failureRatePercent': failureRatePercent,
      'markupPercent': markupPercent,
      'packagingCostPerItem': packagingCostPerItem,
      'shippingBasePrice': shippingBasePrice,
      'includeTax': includeTax,
      'taxPercent': taxPercent,
    };
  }

  factory GeneralSettingsEntity.fromJson(Map<String, dynamic> json) {
    return GeneralSettingsEntity(
      currency: json['currency'] as String? ?? 'PHP',
      electricityRatePerKwh:
          (json['electricityRatePerKwh'] as num?)?.toDouble() ?? 12.0,
      laborRatePerHour: (json['laborRatePerHour'] as num?)?.toDouble() ?? 100.0,
      failureRatePercent:
          (json['failureRatePercent'] as num?)?.toDouble() ?? 5.0,
      markupPercent: (json['markupPercent'] as num?)?.toDouble() ?? 30.0,
      packagingCostPerItem:
          (json['packagingCostPerItem'] as num?)?.toDouble() ?? 0.0,
      shippingBasePrice:
          (json['shippingBasePrice'] as num?)?.toDouble() ?? 0.0,
      includeTax: json['includeTax'] as bool? ?? false,
      taxPercent: (json['taxPercent'] as num?)?.toDouble() ?? 12.0,
    );
  }

  @override
  List<Object?> get props => [
        currency,
        electricityRatePerKwh,
        laborRatePerHour,
        failureRatePercent,
        markupPercent,
        packagingCostPerItem,
        shippingBasePrice,
        includeTax,
        taxPercent,
      ];
}
