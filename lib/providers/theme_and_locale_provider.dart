import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeAndLocaleNotifier extends AsyncNotifier<ThemeAndLocaleState> {
  @override
  Future<ThemeAndLocaleState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final localeCode = prefs.getString('localeCode') ?? 'es';

    return ThemeAndLocaleState(isDarkMode: isDark, locale: Locale(localeCode));
  }

  Future<ThemeAndLocaleState> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final localeCode = prefs.getString('localeCode') ?? 'es';

    return ThemeAndLocaleState(isDarkMode: isDark, locale: Locale(localeCode));
  }

  Future<void> toggleTheme() async {
    state = AsyncValue.data(
      state.value!.copyWith(isDarkMode: !state.value!.isDarkMode),
    );
    await _savePreferences();
  }

  Future<void> setLocale(Locale locale) async {
    state = AsyncValue.data(state.value!.copyWith(locale: locale));
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state.value!.isDarkMode);
    await prefs.setString('localeCode', state.value!.locale.languageCode);
  }
}

// Definimos un estado inmutable para contener tema y locale
class ThemeAndLocaleState {
  final bool isDarkMode;
  final Locale locale;

  const ThemeAndLocaleState({required this.isDarkMode, required this.locale});

  ThemeAndLocaleState copyWith({bool? isDarkMode, Locale? locale}) {
    return ThemeAndLocaleState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
    );
  }

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

final themeAndLocaleProvider =
    AsyncNotifierProvider<ThemeAndLocaleNotifier, ThemeAndLocaleState>(() {
      return ThemeAndLocaleNotifier();
    });
