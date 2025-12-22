import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'storage/models/user_settings.dart';
import 'storage/settings_repository.dart';
import 'theme/app_theme_bw.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final themeMode = settings?.theme == AppThemePreference.light
        ? ThemeMode.light
        : ThemeMode.dark;
    return MaterialApp.router(
      title: '60x60.live',
      debugShowCheckedModeBanner: false,
      theme: AppThemeBW.dark(),
      darkTheme: AppThemeBW.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
