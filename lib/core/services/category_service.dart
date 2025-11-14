import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/category.dart';

/// Excepciones para el servicio de categorías
class CategoryException implements Exception {
  final String message;
  final int? statusCode;

  CategoryException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Servicio de categorías - maneja todas las peticiones relacionadas con categorías
class CategoryService {
  final http.Client _client;
  final String? _authToken;

  CategoryService({http.Client? client, String? authToken})
    : _client = client ?? http.Client(),
      _authToken = authToken;

  /// Obtiene todas las categorías
  Future<List<Category>> getAllCategories() async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.categoriesEndpoint}',
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
        final decoded = jsonDecode(response.body);

        // El backend puede devolver un array directamente o un objeto con un campo "data" o "categories"
        List<dynamic> data;

        if (decoded is List) {
          // Si es un array directamente
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          // Si es un objeto, buscar el array dentro
          if (decoded.containsKey('data')) {
            data = decoded['data'] as List<dynamic>;
          } else if (decoded.containsKey('categories')) {
            data = decoded['categories'] as List<dynamic>;
          } else if (decoded.containsKey('items')) {
            data = decoded['items'] as List<dynamic>;
          } else {
            // Si el objeto tiene solo una categoría, convertirlo en array

            data = [decoded];
          }
        } else {
          throw CategoryException('Formato de respuesta inesperado');
        }

        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw CategoryException(
          'Error al obtener categorías',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CategoryException) rethrow;

      throw CategoryException('Error de conexión: ${e.toString()}');
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
