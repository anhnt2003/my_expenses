import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/feature/settings/widgets/settings_tile.dart';

/// The main settings screen.
///
/// Features:
/// - Theme toggle (Light/Dark/System)
/// - Currency selector
/// - Export data option (visual only)
/// - About section
/// - App version display
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Visual-only state
  ThemeMode _themeMode = ThemeMode.system;
  String _currency = 'USD';
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
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
              _buildAppearanceSection(),
              const SizedBox(height: AppSizes.lg),
              _buildPreferencesSection(),
              const SizedBox(height: AppSizes.lg),
              _buildDataSection(),
              const SizedBox(height: AppSizes.lg),
              _buildAboutSection(),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return SettingsSection(
      title: 'Appearance',
      children: [
        SettingsTile.withValue(
          leading: const Icon(Icons.palette_outlined),
          title: AppStrings.settingsTheme,
          subtitle: 'Change app theme',
          value: _getThemeLabel(),
          onTap: () => _showThemeSelector(),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return SettingsSection(
      title: 'Preferences',
      children: [
        SettingsTile.withValue(
          leading: const Icon(Icons.attach_money_rounded),
          title: AppStrings.settingsCurrency,
          subtitle: 'Default currency for expenses',
          value: _currency,
          onTap: () => _showCurrencySelector(),
        ),
        SettingsTile.withSwitch(
          leading: const Icon(Icons.notifications_outlined),
          title: 'Notifications',
          subtitle: 'Receive expense reminders',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _notificationsEnabled = value);
            _showSnackBar('Notifications ${value ? 'enabled' : 'disabled'}');
          },
        ),
        SettingsTile.withSwitch(
          leading: const Icon(Icons.fingerprint_rounded),
          title: 'Biometric Lock',
          subtitle: 'Require Face ID or Touch ID',
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() => _biometricEnabled = value);
            _showSnackBar('Biometric lock ${value ? 'enabled' : 'disabled'}');
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return SettingsSection(
      title: 'Data',
      children: [
        SettingsTile.navigation(
          leading: const Icon(Icons.upload_rounded),
          title: AppStrings.settingsExportData,
          subtitle: 'Export expenses to CSV',
          onTap: () => _showExportOptions(),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.download_rounded),
          title: 'Import Data',
          subtitle: 'Import expenses from CSV',
          onTap: () => _showImportDialog(),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.delete_outline_rounded),
          title: 'Clear All Data',
          subtitle: 'Delete all expenses and categories',
          onTap: () => _showClearDataConfirmation(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsTile.navigation(
          leading: const Icon(Icons.info_outline_rounded),
          title: AppStrings.settingsAbout,
          subtitle: AppStrings.appName,
          onTap: () => _showAboutDialog(),
        ),
        SettingsTile(
          leading: const Icon(Icons.verified_outlined),
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
          onTap: () => _showSnackBar('Opening Privacy Policy...'),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.gavel_outlined),
          title: 'Terms of Service',
          subtitle: 'View terms and conditions',
          onTap: () => _showSnackBar('Opening Terms of Service...'),
        ),
      ],
    );
  }

  String _getThemeLabel() {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppStrings.settingsThemeLight;
      case ThemeMode.dark:
        return AppStrings.settingsThemeDark;
      case ThemeMode.system:
        return AppStrings.settingsThemeSystem;
    }
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Select Theme',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _buildThemeOption(ThemeMode.light, AppStrings.settingsThemeLight,
                Icons.light_mode_rounded),
            _buildThemeOption(ThemeMode.dark, AppStrings.settingsThemeDark,
                Icons.dark_mode_rounded),
            _buildThemeOption(ThemeMode.system, AppStrings.settingsThemeSystem,
                Icons.settings_suggest_rounded),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode mode, String label, IconData icon) {
    final isSelected = _themeMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() => _themeMode = mode);
        Navigator.pop(context);
        _showSnackBar('Theme changed to $label');
      },
    );
  }

  void _showCurrencySelector() {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'VND', 'CNY', 'AUD', 'CAD'];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Select Currency',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...currencies.map((currency) => ListTile(
                  title: Text(currency),
                  trailing: _currency == currency
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _currency = currency);
                    Navigator.pop(context);
                    _showSnackBar('Currency changed to $currency');
                  },
                )),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Export Data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet format'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Exporting to CSV...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_rounded),
              title: const Text('Export as JSON'),
              subtitle: const Text('Data backup format'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Exporting to JSON...');
              },
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  void _showImportDialog() {
    _showSnackBar('Import feature coming soon!');
  }

  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your expenses, categories, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('All data cleared successfully!');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
