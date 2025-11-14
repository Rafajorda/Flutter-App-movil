import 'color.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<ColorModel> colors; // Ahora es una lista de objetos Color
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
    required this.colors,
    required this.dimensions,
    required this.favoritesCount,
    required this.status,
    required this.categories,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parsear price - puede venir como String o num
    double parsePrice(dynamic priceValue) {
      if (priceValue == null) return 0.0;
      if (priceValue is num) return priceValue.toDouble();
      if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    // Parsear categories - puede venir como array de IDs o array de objetos
    List<int> parseCategories(dynamic categoriesValue) {
      if (categoriesValue == null) return [];
      if (categoriesValue is! List) return [];

      List<int> result = [];
      for (var item in categoriesValue) {
        if (item is int) {
          // Caso 1: Array de números [1, 2, 3]
          result.add(item);
        } else if (item is String) {
          // Caso 2: Array de strings ["1", "2", "3"]
          final parsed = int.tryParse(item);
          if (parsed != null) result.add(parsed);
        } else if (item is Map<String, dynamic>) {
          // Caso 3: Array de objetos [{"id": "uuid", "name": "..."}]
          // Por ahora, usar hashCode del id como int
          final id = item['id']?.toString() ?? '';
          if (id.isNotEmpty) {
            result.add(id.hashCode);
          }
        }
      }
      return result;
    }

    // Parsear images - puede venir como array de strings o array de objetos
    List<String> parseImages(dynamic imagesValue) {
      if (imagesValue == null) return [];
      if (imagesValue is! List) return [];

      List<String> result = [];
      for (var item in imagesValue) {
        if (item is String) {
          // Caso 1: URL directa como string
          result.add(item);
        } else if (item is Map<String, dynamic>) {
          // Caso 2: Objeto con campo de URL
          // Intentar diferentes nombres de campo comunes
          final url =
              item['src'] ?? // Backend actual: { "src": "..." }
              item['url'] ?? // Alternativa: { "url": "..." }
              item['path'] ?? // Alternativa: { "path": "..." }
              item['imageUrl'] ?? // Alternativa: { "imageUrl": "..." }
              '';
          if (url is String && url.isNotEmpty) {
            result.add(url);
          }
        }
      }
      return result;
    }

    // Parsear colors - array de objetos Color
    List<ColorModel> parseColors(dynamic colorsValue) {
      if (colorsValue == null) return [];
      if (colorsValue is! List) return [];

      List<ColorModel> result = [];
      for (var item in colorsValue) {
        if (item is Map<String, dynamic>) {
          try {
            result.add(ColorModel.fromJson(item));
          } catch (e) {
            // Si falla el parsing, continuar con el siguiente
            continue;
          }
        }
      }
      return result;
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parsePrice(json['price']),
      colors: parseColors(json['colors']),
      dimensions: json['dimensions']?.toString() ?? '',
      favoritesCount: json['favoritesCount'] is int
          ? json['favoritesCount']
          : (int.tryParse(json['favoritesCount']?.toString() ?? '0') ?? 0),
      status: json['status']?.toString() ?? 'active',
      categories: parseCategories(json['categories']),
      images: parseImages(json['images']),
    );
  }
}
