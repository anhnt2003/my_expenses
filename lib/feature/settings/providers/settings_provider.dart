import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_formatter.dart';

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

/* Settings notifier for managing app settings */
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    /* Initialize formatter with default currency */
    CurrencyFormatter.setCurrency(state.currency);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
    CurrencyFormatter.setCurrency(currency);
  }

  void setNotificationsEnabled(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void setBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }
}

/* Main settings provider */
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/* Convenience providers for specific settings */
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

final currencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).currency;
});
