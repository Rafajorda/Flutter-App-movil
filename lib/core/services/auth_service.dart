import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Excepciones personalizadas para el servicio de autenticación
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Modelo de respuesta de login/register
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;
  final int? expiresIn; // Segundos hasta expiración del access token
  final String? tokenType; // "Bearer"

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.expiresIn,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: UserData.fromJson(json['user'] ?? {}),
      expiresIn: json['expires_in'],
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }
}

/// Modelo de respuesta de refresh token
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] ?? 900, // Default 15 minutos
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }
}

/// Modelo de datos de usuario
class UserData {
  final String id;
  final String name;
  final String email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? role;
  final bool? isActive;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.address,
    this.role,
    this.isActive,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    final username = json['username'] ?? '';

    // Construir el nombre completo
    String displayName;
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      // Si ambos están presentes: "Juan Pérez"
      displayName = '$firstName $lastName'.trim();
    } else if (firstName.isNotEmpty) {
      // Solo firstName: "Juan"
      displayName = firstName;
    } else if (lastName.isNotEmpty) {
      // Solo lastName: "Pérez"
      displayName = lastName;
    } else if (username.isNotEmpty) {
      // Si no hay nombre, usar username: "juanperez"
      displayName = username;
    } else {
      // Último recurso: "User"
      displayName = 'User';
    }

    return UserData(
      id: json['id']?.toString() ?? '',
      name: displayName,
      email: json['email'] ?? '',
      username: username.isEmpty ? null : username,
      firstName: firstName.isEmpty ? null : firstName,
      lastName: lastName.isEmpty ? null : lastName,
      address: json['address'],
      role: json['role'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (username != null) 'username': username,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (address != null) 'address': address,
    if (role != null) 'role': role,
    if (isActive != null) 'isActive': isActive,
  };
}

/// Servicio de autenticación - maneja todas las peticiones relacionadas con auth
class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Login - retorna token y datos de usuario
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');

      final response = await _client
          .post(
            url,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        // Credenciales incorrectas
        try {
          final error = jsonDecode(response.body);
          throw AuthException(
            error['message'] ?? 'Credenciales inválidas',
            statusCode: 401,
          );
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException('Credenciales inválidas', statusCode: 401);
        }
      } else if (response.statusCode == 400) {
        try {
          final error = jsonDecode(response.body);
          throw AuthException(
            error['message'] ?? 'Email o contraseña incorrectos',
            statusCode: 400,
          );
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException(
            'Email o contraseña incorrectos',
            statusCode: 400,
          );
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw AuthException(
            error['message'] ?? 'Error al iniciar sesión',
            statusCode: response.statusCode,
          );
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException(
            'Error al iniciar sesión',
            statusCode: response.statusCode,
          );
        }
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        'Error de conexión al servidor. Verifica que el backend esté corriendo.',
      );
    }
  }

  /// Registro de nuevo usuario
  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}',
      );

      // Separar el nombre en firstName y lastName
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : name;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      // Generar username desde el email
      final username = email.split('@')[0];

      final body = {
        'firstName': firstName,
        'lastName': lastName.isEmpty ? firstName : lastName,
        'username': username,
        'email': email,
        'password': password,
        'address': '', // Campo requerido por el backend
      };

      final response = await _client
          .post(url, headers: ApiConfig.defaultHeaders, body: jsonEncode(body))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else if (response.statusCode == 409) {
        // Conflicto - email o username ya existen
        try {
          final error = jsonDecode(response.body);
          throw AuthException(
            error['message'] ?? 'El email o nombre de usuario ya está en uso',
            statusCode: 409,
          );
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException(
            'El email o nombre de usuario ya está en uso',
            statusCode: 409,
          );
        }
      } else if (response.statusCode == 400) {
        // Error de validación
        try {
          final error = jsonDecode(response.body);
          final message = error['message'];
          final errorMsg = message is List
              ? message.join(', ')
              : message ?? 'Error de validación';
          throw AuthException(errorMsg, statusCode: 400);
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException('Error de validación', statusCode: 400);
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw AuthException(
            error['message'] ?? 'Error al registrarse',
            statusCode: response.statusCode,
          );
        } catch (e) {
          if (e is AuthException) rethrow;
          throw AuthException(
            'Error al registrarse',
            statusCode: response.statusCode,
          );
        }
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        'Error de conexión al servidor. Verifica que el backend esté corriendo.',
      );
    }
  }

  /// Refresh tokens - obtiene nuevos access y refresh tokens
  Future<RefreshTokenResponse> refreshTokens(String refreshToken) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshEndpoint}');

      final response = await _client
          .post(
            url,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return RefreshTokenResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw AuthException(
          'Sesión expirada. Por favor, inicia sesión nuevamente.',
          statusCode: 401,
        );
      } else {
        throw AuthException(
          'Error al refrescar la sesión',
          statusCode: response.statusCode,
        );
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Error de conexión al refrescar la sesión');
    }
  }

  /// Logout - invalida el refresh token en el servidor
  Future<void> logout(String? accessToken, String? refreshToken) async {
    try {
      if (refreshToken == null) return;

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logoutEndpoint}');

      final headers = accessToken != null
          ? ApiConfig.authHeaders(accessToken)
          : ApiConfig.defaultHeaders;

      await _client
          .post(
            url,
            headers: headers,
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConfig.connectionTimeout);
    } catch (e) {
      // Ignoramos errores de logout en el servidor
    }
  }

  /// Logout All - revoca todos los tokens del usuario
  Future<void> logoutAll(String accessToken) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.logoutAllEndpoint}',
      );

      await _client
          .post(url, headers: ApiConfig.authHeaders(accessToken))
          .timeout(ApiConfig.connectionTimeout);
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Verifica si un token es válido
  Future<bool> verifyToken(String token) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.verifyTokenEndpoint}',
      );

      final response = await _client
          .get(url, headers: ApiConfig.authHeaders(token))
          .timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
