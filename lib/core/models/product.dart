class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String color;
  final String dimensions;
  final int favoritesCount;
  final String status;
  final List<int> categories;
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.color,
    required this.dimensions,
    required this.favoritesCount,
    required this.status,
    required this.categories,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] as num).toDouble(),
        color: json['color'] ?? '',
        dimensions: json['dimensions'] ?? '',
        favoritesCount: json['favoritesCount'] ?? 0,
        status: json['status'] ?? 'active',
        categories: List<int>.from(json['categories'] ?? []),
        images: List<String>.from(json['images'] ?? []),
      );
}
