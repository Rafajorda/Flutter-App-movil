import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/l10n/app_localizations.dart';
import 'core/widgets/flutter3dViewer.dart';
import 'features/settings/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeAndLocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeAndLocaleProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: provider.currentTheme,
      locale: provider.currentLocale,
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
      body: Center(
        child: Column(
          children: [
            Card(
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Custom3DViewer(src: 'assets/3d/radio.glb'),
              ),
            ),
          ],
        ),
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
