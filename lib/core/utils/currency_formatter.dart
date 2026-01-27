import 'package:intl/intl.dart';

/* Currency formatting utilities with locale support */

class CurrencyFormatter {
  CurrencyFormatter._();

  /* Currency configuration */
  static String _currencyCode = 'USD';
  static String _currencySymbol = '\$';
  static String _locale = 'en_US';
  static int _decimalDigits = 2;

  /* Currency-specific formatting configuration */
  static const Map<String, _CurrencyConfig> _currencyConfigs = {
    'USD': _CurrencyConfig(symbol: '\$', locale: 'en_US', decimals: 2),
    'EUR': _CurrencyConfig(symbol: '€', locale: 'de_DE', decimals: 2),
    'GBP': _CurrencyConfig(symbol: '£', locale: 'en_GB', decimals: 2),
    'JPY': _CurrencyConfig(symbol: '¥', locale: 'ja_JP', decimals: 0),
    'VND': _CurrencyConfig(symbol: '₫', locale: 'vi_VN', decimals: 0),
    'CNY': _CurrencyConfig(symbol: '¥', locale: 'zh_CN', decimals: 2),
    'AUD': _CurrencyConfig(symbol: 'A\$', locale: 'en_AU', decimals: 2),
    'CAD': _CurrencyConfig(symbol: 'C\$', locale: 'en_CA', decimals: 2),
  };

  /* Set currency by code - automatically configures symbol, locale, and decimals */
  static void setCurrency(String currencyCode) {
    _currencyCode = currencyCode;
    final config = _currencyConfigs[currencyCode] ??
        const _CurrencyConfig(symbol: '\$', locale: 'en_US', decimals: 2);
    _currencySymbol = config.symbol;
    _locale = config.locale;
    _decimalDigits = config.decimals;
  }

  /* Format amount with currency symbol using locale-specific formatting */
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: _locale,
      symbol: _currencySymbol,
      decimalDigits: _decimalDigits,
    );
    return formatter.format(amount);
  }

  /* Format amount without symbol */
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat.decimalPattern(_locale);
    return formatter.format(amount);
  }

  /* Format compact amount */
  static String formatCompact(double amount) {
    final formatter = NumberFormat.compactCurrency(
      locale: _locale,
      symbol: _currencySymbol,
      decimalDigits: _decimalDigits > 0 ? 1 : 0,
    );
    return formatter.format(amount);
  }

  /* Parse currency string to double */
  static double? parse(String value) {
    try {
      final cleaned = value.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }

  /* Get current currency code */
  static String get currentCurrencyCode => _currencyCode;
}

/* Currency configuration class */
class _CurrencyConfig {
  final String symbol;
  final String locale;
  final int decimals;

  const _CurrencyConfig({
    required this.symbol,
    required this.locale,
    required this.decimals,
  });
}

/* Extension for double to format as currency */
extension CurrencyExtension on double {
  String toCurrency() => CurrencyFormatter.format(this);
  String toCurrencyCompact() => CurrencyFormatter.formatCompact(this);
}
