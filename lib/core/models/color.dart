class ColorModel {
  final String id; // UUID del color
  final String name;
  final String? hexCode; // Código hexadecimal opcional

  const ColorModel({required this.id, required this.name, this.hexCode});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      hexCode: json['hexCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (hexCode != null) 'hexCode': hexCode,
  };

  @override
  String toString() => name;
}
