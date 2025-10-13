import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import '../../core/widgets/toggle.dart';
import '../../core/widgets/dropdown.dart';
import '../../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeAndLocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc!.settings),
        backgroundColor: const Color.fromARGB(255, 26, 0, 226),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GeneralToggle(
              title: context.loc!.darkMode,
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              subtitle: context.loc!.darkModeSubtitle,
              icon: Icons.brightness_6,
            ),
            const SizedBox(height: 20),
            GeneralDropdown<Locale>(
              title: context.loc!.language,
              icon: Icons.language,
              value: themeProvider.currentLocale,
              items: [
                DropdownMenuItem(
                  value: const Locale('es'),
                  child: Text(context.loc!.spanish),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(context.loc!.english),
                ),
              ],
              onChanged: (locale) => themeProvider.setLocale(locale!),
            ),
          ],
        ),
      ),
    );
  }
}
