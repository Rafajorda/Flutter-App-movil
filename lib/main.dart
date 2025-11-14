import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_1/features/home/home_page.dart';
import 'package:proyecto_1/l10n/app_localizations.dart';
import 'package:proyecto_1/providers/theme_and_locale_provider.dart';
import 'package:proyecto_1/core/theme/app_theme.dart';
import 'package:proyecto_1/core/utils/snackbar.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThemeState = ref.watch(themeAndLocaleProvider);

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'HomeNest',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: asyncThemeState.value?.themeMode ?? ThemeMode.light,
      locale: asyncThemeState.value?.locale ?? const Locale('es'),
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Login es opcional - siempre iniciamos en home
      home: const MyHomePage(),
    );
  }
}
