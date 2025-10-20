import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import '../../core/widgets/toggle.dart';
import '../../core/widgets/dropdown.dart';
import '../../providers/theme_and_locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThemeState = ref.watch(themeAndLocaleProvider);
    final notifier = ref.read(themeAndLocaleProvider.notifier);

    return asyncThemeState.when(
      data: (themeState) => Scaffold(
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
                value: themeState.isDarkMode,
                onChanged: (_) => notifier.toggleTheme(),
                subtitle: context.loc!.darkModeSubtitle,
                icon: Icons.brightness_6,
              ),
              const SizedBox(height: 20),
              GeneralDropdown<Locale>(
                title: context.loc!.language,
                icon: Icons.language,
                value: themeState.locale,
                items: [
                  DropdownMenuItem(
                    value: const Locale('es'),
                    child: Row(
                      children: [
                        const Text('🇪🇸', style: TextStyle(fontSize: 20)), // Emoji de bandera
                        const SizedBox(width: 8),
                        Text(context.loc!.spanish),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Row(
                      children: [
                        const Text('🇬🇧', style: TextStyle(fontSize: 20)), // Emoji de bandera
                        const SizedBox(width: 8),
                        Text(context.loc!.english),
                      ],
                    ),
                  ),
                ],
                onChanged: (locale) => notifier.setLocale(locale!),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
