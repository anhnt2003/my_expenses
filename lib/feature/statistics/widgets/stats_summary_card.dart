import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/utils/currency_formatter.dart';

/// A card widget for displaying statistics summary.
///
/// Features:
/// - Total, average, highest expense display
/// - Comparison with previous period (visual indicator)
/// - Gradient background styling
class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.trend,
    this.trendValue,
    this.gradientColors,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final TrendDirection? trend;
  final String? trendValue;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final colors = gradientColors ??
        (isDark
            ? [AppColors.darkSurface, AppColors.darkSurfaceVariant]
            : [AppColors.lightSurface, AppColors.lightSurface]);

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSizes.borderRadiusLg,
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline.withValues(alpha: 0.3)
              : AppColors.lightOutline.withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppSizes.borderRadiusSm,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconSm,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (trend != null && trendValue != null) _buildTrendIndicator(),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    final isUp = trend == TrendDirection.up;
    final color = isUp ? AppColors.success : AppColors.error;
    final icon = isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSizes.borderRadiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconXs,
            color: color,
          ),
          const SizedBox(width: AppSizes.xs),
          Text(
            trendValue!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents the direction of a trend indicator
enum TrendDirection {
  up,
  down,
  neutral,
}

/// A row of summary stat cards
class StatsSummaryRow extends StatelessWidget {
  const StatsSummaryRow({
    super.key,
    required this.total,
    required this.average,
    required this.highest,
  });

  final double total;
  final double average;
  final double highest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatsSummaryCard(
          title: AppStrings.statsTotal,
          value: CurrencyFormatter.format(total),
          subtitle: 'All time spending',
          icon: Icons.account_balance_wallet_rounded,
          trend: TrendDirection.up,
          trendValue: '+12%',
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: StatsSummaryCard(
                title: AppStrings.statsAverage,
                value: CurrencyFormatter.format(average),
                subtitle: 'Per transaction',
                icon: Icons.analytics_rounded,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: StatsSummaryCard(
                title: AppStrings.statsHighest,
                value: CurrencyFormatter.format(highest),
                subtitle: 'Largest expense',
                icon: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
