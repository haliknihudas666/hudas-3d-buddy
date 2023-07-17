class FilamentModel {
  String? name;
  String? brand;
  String? material;
  String? color;
  double? diameter;
  double? price;
  double? weight;
  int? nozzleTemp;
  int? bedTemp;

  FilamentModel({
    this.name,
    this.brand,
    this.material,
    this.color,
    this.diameter,
    this.price,
    this.weight,
    this.nozzleTemp,
    this.bedTemp,
  });

  factory FilamentModel.fromJson(Map<String, dynamic> json) {
    return FilamentModel(
      name: json['name'],
      brand: json['brand'],
      material: json['material'],
      color: json['color'],
      diameter: json['diameter'],
      price: json['price'],
      weight: json['weight'],
      nozzleTemp: json['nozzleTemp'],
      bedTemp: json['bedTemp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand': brand,
        'material': material,
        'color': color,
        'diameter': diameter,
        'price': price,
        'weight': weight,
        'nozzleTemp': nozzleTemp,
        'bedTemp': bedTemp,
      };
}
