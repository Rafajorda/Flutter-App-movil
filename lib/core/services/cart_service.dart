import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Excepciones para el servicio de carrito
class CartException implements Exception {
  final String message;
  final int? statusCode;

  CartException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Modelo de item del carrito
class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId:
          json['productId']?.toString() ?? json['product_id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };

  double get total => price * quantity;
}

/// Modelo de respuesta del carrito
class CartResponse {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;

  CartResponse({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return CartResponse(
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Servicio de carrito - maneja todas las peticiones relacionadas con el carrito
class CartService {
  final http.Client _client;
  final String _authToken;

  CartService({required String authToken, http.Client? client})
    : _authToken = authToken,
      _client = client ?? http.Client();

  /// Obtiene el carrito del usuario
  Future<CartResponse> getCart() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cartEndpoint}');

      final response = await _client
          .get(url, headers: ApiConfig.authHeaders(_authToken))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CartResponse.fromJson(data);
      } else {
        throw CartException(
          'Error al obtener carrito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CartException) rethrow;
      throw CartException('Error de conexión: ${e.toString()}');
    }
  }

  /// Añade un producto al carrito
  Future<CartResponse> addToCart({
    required String productId,
    int quantity = 1,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.addToCartEndpoint}',
      );

      final response = await _client
          .post(
            url,
            headers: ApiConfig.authHeaders(_authToken),
            body: jsonEncode({'productId': productId, 'quantity': quantity}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return CartResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw CartException('Producto no encontrado', statusCode: 404);
      } else {
        throw CartException(
          'Error al añadir al carrito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CartException) rethrow;
      throw CartException('Error de conexión: ${e.toString()}');
    }
  }

  /// Actualiza la cantidad de un producto en el carrito
  Future<CartResponse> updateCartItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.updateCartEndpoint}',
      );

      final response = await _client
          .put(
            url,
            headers: ApiConfig.authHeaders(_authToken),
            body: jsonEncode({'productId': productId, 'quantity': quantity}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CartResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw CartException(
          'Item no encontrado en el carrito',
          statusCode: 404,
        );
      } else {
        throw CartException(
          'Error al actualizar carrito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CartException) rethrow;
      throw CartException('Error de conexión: ${e.toString()}');
    }
  }

  /// Elimina un producto del carrito
  Future<CartResponse> removeFromCart(String productId) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.removeFromCartEndpoint}/$productId',
      );

      final response = await _client
          .delete(url, headers: ApiConfig.authHeaders(_authToken))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CartResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw CartException(
          'Item no encontrado en el carrito',
          statusCode: 404,
        );
      } else {
        throw CartException(
          'Error al eliminar del carrito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CartException) rethrow;
      throw CartException('Error de conexión: ${e.toString()}');
    }
  }

  /// Vacía el carrito completamente
  Future<void> clearCart() async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.clearCartEndpoint}',
      );

      final response = await _client
          .delete(url, headers: ApiConfig.authHeaders(_authToken))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw CartException(
          'Error al vaciar carrito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CartException) rethrow;
      throw CartException('Error de conexión: ${e.toString()}');
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
