import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/color.dart';

/// Excepciones para el servicio de colores
class ColorException implements Exception {
  final String message;
  final int? statusCode;

  ColorException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Servicio de colores - maneja todas las peticiones HTTP relacionadas con colores.
///
/// Endpoint base: `GET /color`
///
/// Responsabilidades:
/// - Obtener lista completa de colores disponibles
/// - Manejo de errores y timeouts
/// - Parseo de diferentes formatos de respuesta del backend
class ColorService {
  final http.Client _client;
  final String? _authToken;

  ColorService({http.Client? client, String? authToken})
    : _client = client ?? http.Client(),
      _authToken = authToken;

  /// Obtiene todos los colores disponibles desde el backend.
  ///
  /// Endpoint: `GET /color`
  ///
  /// Respuesta esperada (puede variar):
  /// - Array directo: `[{id, name, hexCode}, ...]`
  /// - Objeto wrapper: `{data: [{id, name, hexCode}, ...]}`
  /// - Objeto wrapper: `{colors: [{id, name, hexCode}, ...]}`
  ///
  /// Lanza [ColorException] si hay error de red o respuesta inválida.
  Future<List<ColorModel>> getAllColors() async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/color', // Endpoint de colores
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

        // El backend puede devolver un array directamente o un objeto con un campo "data" o "colors"
        List<dynamic> data;

        if (decoded is List) {
          // Si es un array directamente
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          // Si es un objeto, buscar el array dentro
          if (decoded.containsKey('data')) {
            data = decoded['data'] as List<dynamic>;
          } else if (decoded.containsKey('colors')) {
            data = decoded['colors'] as List<dynamic>;
          } else if (decoded.containsKey('items')) {
            data = decoded['items'] as List<dynamic>;
          } else {
            // Si el objeto tiene solo un color, convertirlo en array
            data = [decoded];
          }
        } else {
          throw ColorException('Formato de respuesta inesperado');
        }

        return data.map((json) => ColorModel.fromJson(json)).toList();
      } else {
        throw ColorException(
          'Error al obtener colores',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ColorException) rethrow;

      throw ColorException('Error de conexión: ${e.toString()}');
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
