class SavedFilamentData {
  List<FilamentModel>? filaments;

  SavedFilamentData.fromJson(List? data) {
    if (data != null) {
      filaments = <FilamentModel>[];
      for (var v in data) {
        filaments!.add(FilamentModel.fromJson(v));
      }
    }
  }
}

class FilamentModel {
  String? name;
  String? brand;
  String? material;
  double? diameter;
  double? price;
  double? weight;
  int? nozzleTemp;
  int? bedTemp;

  FilamentModel({
    this.name,
    this.brand,
    this.material,
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
        'diameter': diameter,
        'price': price,
        'weight': weight,
        'nozzleTemp': nozzleTemp,
        'bedTemp': bedTemp,
      };
}
