// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HomeNest';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Enable or disable dark mode';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get cancel => 'Cancel';

  @override
  String get completeAllFields => 'Please complete all fields';

  @override
  String get incorrectCredentials => 'Incorrect credentials';

  @override
  String get registrationError => 'Error registering user. Check the data.';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String logoutConfirmMessage(String userName) {
    return 'Are you sure you want to logout, $userName?';
  }

  @override
  String hello(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get user => 'User';

  @override
  String get colorLabel => 'Color';

  @override
  String get dimensionsLabel => 'Dimensions';

  @override
  String get favoritesLabel => 'Favorites';

  @override
  String get addToCartButton => 'Add to cart';

  @override
  String get addedToCartMessage => 'Product added to cart 🛒';
}
