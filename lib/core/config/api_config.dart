/// Configuración de la API del backend
class ApiConfig {
  // URL base del servidor NestJS
  // Para desarrollo local en Android Emulator usa: 10.0.2.2:3000
  // Para desarrollo local en iOS Simulator usa: localhost:3000
  // Para dispositivo físico usa la IP de tu ordenador (ej: 192.168.1.100:3000)
  static const String baseUrl = 'http://10.0.2.2:3000';

  // También puedes configurarlo según el entorno
  // static String get baseUrl {
  //   if (Platform.isAndroid) {
  //     return 'http://10.0.2.2:3000'; // Android emulator
  //   } else if (Platform.isIOS) {
  //     return 'http://localhost:3000'; // iOS simulator
  //   }
  //   return 'http://192.168.1.100:3000'; // Dispositivo físico - ajusta la IP
  // }

  // Endpoints de autenticación
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String logoutAllEndpoint = '/auth/logout-all';
  static const String verifyTokenEndpoint = '/auth/verify';
  static const String profileEndpoint = '/auth/profile';

  // Endpoints de productos
  static const String productsEndpoint = '/product';
  static String productByIdEndpoint(String id) => '/product/$id';
  static const String productsByCategoryEndpoint = '/product/category';

  // Endpoints de categorías
  static const String categoriesEndpoint = '/category';

  // Endpoints de carrito
  static const String cartEndpoint = '/cart';
  static String addToCartEndpoint = '/cart/add';
  static String removeFromCartEndpoint = '/cart/remove';
  static String updateCartEndpoint = '/cart/update';
  static String clearCartEndpoint = '/cart/clear';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers comunes
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
