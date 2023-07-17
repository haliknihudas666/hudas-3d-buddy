class PrinterModel {
  String? name;
  String? brand;
  String? model;
  double? watts;
  double? price;
  double? serviceCost;
  int? depreciationHours;

  PrinterModel({
    this.name,
    this.brand,
    this.model,
    this.watts,
    this.price,
    this.serviceCost,
    this.depreciationHours,
  });

  factory PrinterModel.fromJson(Map<String, dynamic> json) {
    return PrinterModel(
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      watts: json['watts'],
      price: json['price'],
      serviceCost: json['serviceCost'],
      depreciationHours: json['depreciationHours'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand': brand,
        'model': model,
        'watts': watts,
        'price': price,
        'serviceCost': serviceCost,
        'depreciationHours': depreciationHours,
      };
}
