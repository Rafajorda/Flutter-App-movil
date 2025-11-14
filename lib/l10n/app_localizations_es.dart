// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'HomeNest';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeSubtitle => 'Activa o desactiva el modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registro';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get name => 'Nombre';

  @override
  String get noAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get cancel => 'Cancelar';

  @override
  String get completeAllFields => 'Por favor completa todos los campos';

  @override
  String get incorrectCredentials => 'Credenciales incorrectas';

  @override
  String get registrationError => 'Error al registrar usuario. Verifica los datos.';

  @override
  String get invalidCredentials => 'Credenciales inválidas';

  @override
  String get emailAlreadyRegistered => 'El email ya está registrado';

  @override
  String get usernameAlreadyInUse => 'El nombre de usuario ya está en uso';

  @override
  String get sessionExpired => 'Sesión expirada. Por favor, inicia sesión nuevamente';

  @override
  String get connectionError => 'Error de conexión. Verifica tu conexión a internet';

  @override
  String get serverError => 'Error del servidor. Inténtalo más tarde';

  @override
  String get invalidEmail => 'Formato de email inválido';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginSuccessful => 'Inicio de sesión exitoso';

  @override
  String get registerSuccessful => 'Registro exitoso';

  @override
  String get logoutSuccessful => 'Sesión cerrada exitosamente';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmTitle => 'Cerrar sesión';

  @override
  String logoutConfirmMessage(String userName) {
    return '¿Estás seguro de que quieres cerrar sesión, $userName?';
  }

  @override
  String hello(String userName) {
    return '¡Hola, $userName!';
  }

  @override
  String get user => 'Usuario';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get myOrders => 'Mis Pedidos';

  @override
  String get favorites => 'Favoritos';

  @override
  String get addresses => 'Direcciones';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get loginToSeeProfile => 'Inicia sesión para ver tu perfil y pedidos';

  @override
  String get colorLabel => 'Color';

  @override
  String get dimensionsLabel => 'Dimensiones';

  @override
  String get favoritesLabel => 'Favoritos';

  @override
  String get addToCartButton => 'Añadir al carrito';

  @override
  String get addedToCartMessage => 'Producto añadido al carrito 🛒';

  @override
  String get errorLoadingProducts => 'Error al cargar productos';

  @override
  String get retry => 'Reintentar';

  @override
  String get loading => 'Cargando...';

  @override
  String get noProductsFound => 'No se encontraron productos';

  @override
  String get allCategories => 'Todos';

  @override
  String get productDetails => 'Detalles del Producto';

  @override
  String get specifications => 'Especificaciones';

  @override
  String get addedToFavorites => 'Añadido a favoritos ❤️';

  @override
  String get removedFromFavorites => 'Eliminado de favoritos';

  @override
  String get color => 'Color';

  @override
  String get dimensions => 'Dimensiones';

  @override
  String get profileTooltip => 'Perfil';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get cartTooltip => 'Carrito';

  @override
  String get searchTooltip => 'Buscar';

  @override
  String get homeTooltip => 'Inicio';

  @override
  String get catalogTooltip => 'Catálogo';

  @override
  String get accountSettings => 'Configuración de cuenta';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get privacy => 'Privacidad';

  @override
  String get help => 'Ayuda y soporte';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirm => '¿Estás seguro de que quieres eliminar tu cuenta?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get cart => 'Carrito';

  @override
  String get emptyCart => 'Tu carrito está vacío';

  @override
  String get cartTotal => 'Total';

  @override
  String get checkout => 'Finalizar compra';

  @override
  String get removeFromCart => 'Eliminar del carrito';

  @override
  String get clearCart => 'Vaciar carrito';

  @override
  String get clearCartConfirm => '¿Estás seguro de que quieres vaciar tu carrito?';

  @override
  String get quantity => 'Cantidad';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get proceedToCheckout => 'Proceder al pago';

  @override
  String get itemRemoved => 'Artículo eliminado del carrito';

  @override
  String get cartCleared => 'Carrito vaciado';

  @override
  String get orders => 'Pedidos';

  @override
  String get orderHistory => 'Historial de pedidos';

  @override
  String get orderNumber => 'Pedido #';

  @override
  String get orderDate => 'Fecha';

  @override
  String get orderStatus => 'Estado';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderDetails => 'Detalles del pedido';

  @override
  String get trackOrder => 'Rastrear pedido';

  @override
  String get cancelOrder => 'Cancelar pedido';

  @override
  String get reorder => 'Volver a pedir';

  @override
  String get noOrders => 'No tienes pedidos aún';

  @override
  String get orderPlaced => 'Pedido realizado con éxito';

  @override
  String get orderCancelled => 'Pedido cancelado';

  @override
  String get pending => 'Pendiente';

  @override
  String get processing => 'Procesando';

  @override
  String get shipped => 'Enviado';

  @override
  String get delivered => 'Entregado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get search => 'Buscar';

  @override
  String get searchProducts => 'Buscar productos...';

  @override
  String get searchResults => 'Resultados de búsqueda';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get filters => 'Filtros';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get priceRange => 'Rango de precio';

  @override
  String get category => 'Categoría';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String resultsFound(int count) {
    return '$count resultados encontrados';
  }

  @override
  String get sortByNewest => 'Más recientes';

  @override
  String get sortByPriceAsc => 'Precio: Menor a Mayor';

  @override
  String get sortByPriceDesc => 'Precio: Mayor a Menor';

  @override
  String get sortByPopularity => 'Popularidad';

  @override
  String get required => 'Este campo es obligatorio';

  @override
  String get invalidEmailFormat => 'Formato de email inválido';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String minLength(int count) {
    return 'Se requieren mínimo $count caracteres';
  }

  @override
  String maxLength(int count) {
    return 'Máximo $count caracteres permitidos';
  }

  @override
  String get invalidPhoneNumber => 'Número de teléfono inválido';

  @override
  String get invalidPostalCode => 'Código postal inválido';

  @override
  String get close => 'Cerrar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Listo';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpiar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get share => 'Compartir';

  @override
  String get more => 'Más';

  @override
  String get less => 'Menos';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get viewLess => 'Ver Menos';
}
