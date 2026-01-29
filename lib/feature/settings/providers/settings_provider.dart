import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../injection/injection.dart';

/* SharedPreferences keys for settings */
class _SettingsKeys {
  static const themeMode = 'settings_theme_mode';
  static const currency = 'settings_currency';
  static const notificationsEnabled = 'settings_notifications_enabled';
  static const biometricEnabled = 'settings_biometric_enabled';
}

/* Settings state class */
class SettingsState {
  final ThemeMode themeMode;
  final String currency;
  final bool notificationsEnabled;
  final bool biometricEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.currency = 'USD',
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? currency,
    bool? notificationsEnabled,
    bool? biometricEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

/* Settings notifier for managing app settings with persistence */
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  /* Load saved settings from SharedPreferences */
  void _loadSettings() {
    final themeModeIndex = _prefs.getInt(_SettingsKeys.themeMode) ?? 0;
    final currency = _prefs.getString(_SettingsKeys.currency) ?? 'USD';
    final notificationsEnabled =
        _prefs.getBool(_SettingsKeys.notificationsEnabled) ?? true;
    final biometricEnabled =
        _prefs.getBool(_SettingsKeys.biometricEnabled) ?? false;

    state = SettingsState(
      themeMode: ThemeMode.values[themeModeIndex],
      currency: currency,
      notificationsEnabled: notificationsEnabled,
      biometricEnabled: biometricEnabled,
    );

    CurrencyFormatter.setCurrency(currency);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs.setInt(_SettingsKeys.themeMode, mode.index);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
    _prefs.setString(_SettingsKeys.currency, currency);
    CurrencyFormatter.setCurrency(currency);
  }

  void setNotificationsEnabled(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
    _prefs.setBool(_SettingsKeys.notificationsEnabled, enabled);
  }

  void setBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
    _prefs.setBool(_SettingsKeys.biometricEnabled, enabled);
  }
}

/* Main settings provider */
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(getIt<SharedPreferences>());
});

/* Convenience providers for specific settings */
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

final currencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).currency;
});
