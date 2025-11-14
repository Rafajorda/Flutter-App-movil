import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product.dart';
import '../models/product_filters.dart';

/// Excepciones para el servicio de productos
class ProductException implements Exception {
  final String message;
  final int? statusCode;

  ProductException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Servicio de productos - maneja todas las peticiones relacionadas con productos
class ProductService {
  final http.Client _client;
  final String? _authToken;

  ProductService({http.Client? client, String? authToken})
    : _client = client ?? http.Client(),
      _authToken = authToken;

  /// Obtiene todos los productos (opcionalmente con filtros)
  Future<List<Product>> getAllProducts([ProductFilters? filters]) async {
    try {
      // Construir URL con filtros si existen
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productsEndpoint}')
          .replace(
            queryParameters:
                filters?.toQueryParameters() ?? {'status': 'active'},
          );

      final response = await _client
          .get(
            uri,
            headers: _authToken != null
                ? ApiConfig.authHeaders(_authToken)
                : ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // El backend puede devolver un array directamente o un objeto con un campo "data" o "products"
        List<dynamic> data;

        if (decoded is List) {
          // Si es un array directamente
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          // Si es un objeto, buscar el array dentro
          if (decoded.containsKey('data')) {
            data = decoded['data'] as List<dynamic>;
          } else if (decoded.containsKey('products')) {
            data = decoded['products'] as List<dynamic>;
          } else if (decoded.containsKey('items')) {
            data = decoded['items'] as List<dynamic>;
          } else {
            // Si el objeto tiene solo un producto, convertirlo en array

            data = [decoded];
          }
        } else {
          throw ProductException('Formato de respuesta inesperado');
        }

        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ProductException(
          'Error al obtener productos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ProductException) rethrow;

      throw ProductException('Error de conexión: ${e.toString()}');
    }
  }

  /// Obtiene un producto por ID
  Future<Product> getProductById(String id) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.productByIdEndpoint(id)}',
      );

      final response = await _client
          .get(
            url,
            headers: _authToken != null
                ? ApiConfig.authHeaders(_authToken)
                : ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw ProductException('Producto no encontrado', statusCode: 404);
      } else {
        throw ProductException(
          'Error al obtener producto',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ProductException) rethrow;
      throw ProductException('Error de conexión: ${e.toString()}');
    }
  }

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.productsByCategoryEndpoint}/$category',
      );

      final response = await _client
          .get(
            url,
            headers: _authToken != null
                ? ApiConfig.authHeaders(_authToken)
                : ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ProductException(
          'Error al obtener productos por categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ProductException) rethrow;
      throw ProductException('Error de conexión: ${e.toString()}');
    }
  }

  /// Busca productos por nombre o descripción
  Future<List<Product>> searchProducts(String query) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.productsEndpoint}/search',
      ).replace(queryParameters: {'q': query});

      final response = await _client
          .get(
            url,
            headers: _authToken != null
                ? ApiConfig.authHeaders(_authToken)
                : ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ProductException(
          'Error al buscar productos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ProductException) rethrow;
      throw ProductException('Error de conexión: ${e.toString()}');
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
