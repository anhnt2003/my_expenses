import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/feature/settings/widgets/settings_tile.dart';
import 'package:my_expenses/feature/settings/providers/settings_provider.dart';

/// The main settings screen.
///
/// Features:
/// - Theme toggle (Light/Dark/System)
/// - Currency selector
/// - Export data option (visual only)
/// - About section
/// - App version display
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppearanceSection(context, settings, notifier),
              const SizedBox(height: AppSizes.lg),
              _buildPreferencesSection(context, settings, notifier),
              const SizedBox(height: AppSizes.lg),
              _buildDataSection(context),
              const SizedBox(height: AppSizes.lg),
              _buildAboutSection(context),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
  ) {
    return SettingsSection(
      title: 'Appearance',
      children: [
        SettingsTile.withValue(
          leading: const Icon(Icons.palette_outlined),
          title: AppStrings.settingsTheme,
          subtitle: 'Change app theme',
          value: _getThemeLabel(settings.themeMode),
          onTap: () => _showThemeSelector(context, settings, notifier),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
  ) {
    return SettingsSection(
      title: 'Preferences',
      children: [
        SettingsTile.withValue(
          leading: const Icon(Icons.attach_money_rounded),
          title: AppStrings.settingsCurrency,
          subtitle: 'Default currency for expenses',
          value: settings.currency,
          onTap: () => _showCurrencySelector(context, settings, notifier),
        ),
        SettingsTile.withSwitch(
          leading: const Icon(Icons.notifications_outlined),
          title: 'Notifications',
          subtitle: 'Receive expense reminders',
          value: settings.notificationsEnabled,
          onChanged: (value) {
            notifier.setNotificationsEnabled(value);
            _showSnackBar(
                context, 'Notifications ${value ? 'enabled' : 'disabled'}');
          },
        ),
        SettingsTile.withSwitch(
          leading: const Icon(Icons.fingerprint_rounded),
          title: 'Biometric Lock',
          subtitle: 'Require Face ID or Touch ID',
          value: settings.biometricEnabled,
          onChanged: (value) {
            notifier.setBiometricEnabled(value);
            _showSnackBar(
                context, 'Biometric lock ${value ? 'enabled' : 'disabled'}');
          },
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return SettingsSection(
      title: 'Data',
      children: [
        SettingsTile.navigation(
          leading: const Icon(Icons.upload_rounded),
          title: AppStrings.settingsExportData,
          subtitle: 'Export expenses to CSV',
          onTap: () => _showExportOptions(context),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.download_rounded),
          title: 'Import Data',
          subtitle: 'Import expenses from CSV',
          onTap: () => _showSnackBar(context, 'Import feature coming soon!'),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.delete_outline_rounded),
          title: 'Clear All Data',
          subtitle: 'Delete all expenses and categories',
          onTap: () => _showClearDataConfirmation(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsTile.navigation(
          leading: const Icon(Icons.info_outline_rounded),
          title: AppStrings.settingsAbout,
          subtitle: AppStrings.appName,
          onTap: () => _showAboutDialog(context),
        ),
        const SettingsTile(
          leading: Icon(Icons.verified_outlined),
          title: AppStrings.settingsVersion,
          subtitle: 'Current app version',
          trailing: Text(
            AppStrings.appVersion,
            style: TextStyle(
              color: AppColors.lightOnSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.description_outlined),
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          onTap: () => _showSnackBar(context, 'Opening Privacy Policy...'),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.gavel_outlined),
          title: 'Terms of Service',
          subtitle: 'View terms and conditions',
          onTap: () => _showSnackBar(context, 'Opening Terms of Service...'),
        ),
      ],
    );
  }

  String _getThemeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppStrings.settingsThemeLight;
      case ThemeMode.dark:
        return AppStrings.settingsThemeDark;
      case ThemeMode.system:
        return AppStrings.settingsThemeSystem;
    }
  }

  void _showThemeSelector(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Select Theme',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
            ),
            _buildThemeOption(
                ctx,
                notifier,
                settings.themeMode,
                ThemeMode.light,
                AppStrings.settingsThemeLight,
                Icons.light_mode_rounded),
            _buildThemeOption(ctx, notifier, settings.themeMode, ThemeMode.dark,
                AppStrings.settingsThemeDark, Icons.dark_mode_rounded),
            _buildThemeOption(
                ctx,
                notifier,
                settings.themeMode,
                ThemeMode.system,
                AppStrings.settingsThemeSystem,
                Icons.settings_suggest_rounded),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    SettingsNotifier notifier,
    ThemeMode currentMode,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    final isSelected = currentMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        notifier.setThemeMode(mode);
        Navigator.pop(context);
        _showSnackBar(context, 'Theme changed to $label');
      },
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
  ) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'VND', 'CNY', 'AUD', 'CAD'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Text(
                  'Select Currency',
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: currencies
                        .map((currency) => ListTile(
                              title: Text(currency),
                              trailing: settings.currency == currency
                                  ? const Icon(Icons.check_rounded,
                                      color: AppColors.primary)
                                  : null,
                              onTap: () {
                                notifier.setCurrency(currency);
                                Navigator.pop(ctx);
                                _showSnackBar(
                                    context, 'Currency changed to $currency');
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Export Data',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet format'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackBar(context, 'Exporting to CSV...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_rounded),
              title: const Text('Export as JSON'),
              subtitle: const Text('Data backup format'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackBar(context, 'Exporting to JSON...');
              },
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  void _showClearDataConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your expenses, categories, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar(context, 'All data cleared successfully!');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppSizes.borderRadiusMd,
        ),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const SizedBox(height: AppSizes.md),
        const Text(
          'My Expenses helps you track and manage your daily expenses with beautiful charts and insights.',
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
