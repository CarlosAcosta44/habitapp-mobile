import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode_preference';

  @override
  ThemeMode build() {
    return _loadTheme();
  }

  ThemeMode _loadTheme() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex == null) return ThemeMode.system;
    
    return ThemeMode.values.firstWhere(
      (e) => e.index == themeIndex,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> updateTheme(ThemeMode newMode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeKey, newMode.index);
    state = newMode;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
