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
  String get colorLabel => 'Color';

  @override
  String get dimensionsLabel => 'Dimensiones';

  @override
  String get favoritesLabel => 'Favoritos';

  @override
  String get addToCartButton => 'Añadir al carrito';

  @override
  String get addedToCartMessage => 'Producto añadido al carrito 🛒';
}
