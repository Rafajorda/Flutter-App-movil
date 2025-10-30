import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/core/widgets/3d/3dcard.dart';
import 'package:proyecto_1/features/login/login_page.dart';
import 'package:proyecto_1/l10n/app_localizations.dart';
import 'package:proyecto_1/providers/theme_and_locale_provider.dart';
import 'features/settings/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThemeState = ref.watch(themeAndLocaleProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: asyncThemeState.value?.themeMode ?? ThemeMode.light,
      locale: asyncThemeState.value?.locale ?? const Locale('es'),
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc!.appTitle),
        backgroundColor: const Color.fromARGB(255, 26, 0, 226),
        actions: [
          // Botón de login
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          // Botón de configuración
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
          Product3DCard(
            title: "Radiorreceptor Antiguo",
            description: "Radiorreceptor de los años 80 metalico ruso.",
            modelUrl: "assets/3d/radio.glb",
          ),
        ],
      ),
    );
  }
}

class ThemeAndLocaleProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('es');

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;
  Locale get currentLocale => _locale;

  ThemeAndLocaleProvider() {
    _loadPreferences();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _savePreferences();
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    String? localeCode = prefs.getString('localeCode');
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('localeCode', _locale.languageCode);
  }
}
