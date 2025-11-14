import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_1/core/services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final String? userName;
  final String? userEmail;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
    this.userName,
    this.userEmail,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    String? userName,
    String? userEmail,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = AuthService();
    // Cargar estado de autenticación al inicializar
    _loadAuthState();

    // Limpiar el servicio cuando el provider se destruya
    ref.onDispose(() {
      _authService.dispose();
    });

    return const AuthState();
  }

  // Cargar el estado guardado
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    // 🔐 SESIÓN PERMANENTE: Si hay tokens guardados, siempre intentar restaurar
    if (isAuthenticated && refreshToken != null) {
      debugPrint(
        '[AuthProvider] 🔄 Detectados tokens guardados, restaurando sesión...',
      );

      // Verificar si el access token sigue siendo válido
      final isValid = await _authService.verifyToken(accessToken ?? '');

      if (isValid && accessToken != null) {
        // ✅ Access token válido - restaurar sesión directamente
        debugPrint('[AuthProvider] ✅ Access token válido, sesión restaurada');
        state = state.copyWith(
          isAuthenticated: true,
          userName: userName,
          userEmail: userEmail,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        // 🔄 Access token expirado o inválido - intentar refresh automático
        debugPrint(
          '[AuthProvider] ⚠️ Access token expirado, intentando refresh automático...',
        );

        try {
          final response = await _authService.refreshTokens(refreshToken);

          // Guardar nuevos tokens
          await _saveAuthState(
            isAuthenticated: true,
            userName: userName,
            userEmail: userEmail,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          // Actualizar estado
          state = state.copyWith(
            isAuthenticated: true,
            userName: userName,
            userEmail: userEmail,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          debugPrint('[AuthProvider] ✅ Sesión restaurada con refresh token');
        } catch (e) {
          // ⚠️ Refresh token inválido - Mantener sesión local pero mostrar warning
          // NO hacer logout automático - el usuario debe desloguearse manualmente
          debugPrint('[AuthProvider] ⚠️ Refresh token inválido: $e');
          debugPrint(
            '[AuthProvider] ℹ️ Manteniendo sesión local - usuario debe hacer logout manual',
          );

          // Restaurar sesión con tokens antiguos (aunque inválidos)
          // Esto permite que el usuario vea la UI y decida hacer logout
          state = state.copyWith(
            isAuthenticated: true,
            userName: userName,
            userEmail: userEmail,
            accessToken: accessToken,
            refreshToken: refreshToken,
          );

          // Opcional: Mostrar mensaje al usuario
          // showSnackbar('Sesión expirada. Por favor, cierra sesión e inicia de nuevo.');
        }
      }
    } else if (isAuthenticated) {
      // Caso raro: isAuthenticated pero no hay refresh token
      debugPrint(
        '[AuthProvider] ⚠️ Estado inconsistente: autenticado pero sin refresh token',
      );
      // Limpiar solo si no hay forma de recuperar la sesión
      await _clearAuthState();
    }
  }

  // Guardar el estado
  Future<void> _saveAuthState({
    required bool isAuthenticated,
    String? userName,
    String? userEmail,
    String? accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', isAuthenticated);
    if (userName != null) await prefs.setString('userName', userName);
    if (userEmail != null) await prefs.setString('userEmail', userEmail);
    if (accessToken != null) await prefs.setString('accessToken', accessToken);
    if (refreshToken != null) {
      await prefs.setString('refreshToken', refreshToken);
    }
  }

  // Limpiar el estado guardado
  Future<void> _clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  /// Login con el backend real
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      await _saveAuthState(
        isAuthenticated: true,
        userName: response.user.name,
        userEmail: response.user.email,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userName: response.user.name,
        userEmail: response.user.email,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
    }
  }

  /// Registro con el backend real
  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      await _saveAuthState(
        isAuthenticated: true,
        userName: response.user.name,
        userEmail: response.user.email,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userName: response.user.name,
        userEmail: response.user.email,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
    }
  }

  /// Logout con el backend real
  Future<void> logout() async {
    // Intentar hacer logout en el servidor
    await _authService.logout(state.accessToken, state.refreshToken);

    await _clearAuthState();
    state = const AuthState();
  }

  /// Refrescar tokens cuando el access token expira
  /// 🔐 SESIÓN PERMANENTE: No hace logout automático, solo notifica el error
  Future<bool> refreshTokens() async {
    if (state.refreshToken == null) {
      debugPrint(
        '[AuthProvider] ⚠️ No hay refresh token - mantener sesión local',
      );
      return false;
    }

    try {
      final response = await _authService.refreshTokens(state.refreshToken!);

      await _saveAuthState(
        isAuthenticated: true,
        userName: state.userName,
        userEmail: state.userEmail,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      state = state.copyWith(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      debugPrint('[AuthProvider] ✅ Tokens refrescados exitosamente');
      return true;
    } on AuthException catch (e) {
      debugPrint('[AuthProvider] ❌ Error al refrescar tokens: $e');
      // 🔐 NO hacer logout automático - mantener sesión local
      // El usuario debe cerrar sesión manualmente si lo desea
      return false;
    } catch (e) {
      debugPrint('[AuthProvider] ❌ Error inesperado al refrescar: $e');
      // 🔐 NO hacer logout automático
      return false;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
