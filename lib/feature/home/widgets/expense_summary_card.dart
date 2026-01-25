import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/theme/text_styles.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.totalAmount,
    required this.periodLabel,
    this.previousAmount,
    this.gradient,
  });

  final double totalAmount;
  final String periodLabel;
  final double? previousAmount;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentChange = _calculatePercentChange();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.cardGradient,
        borderRadius: AppSizes.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                periodLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppSizes.borderRadiusSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: AppSizes.iconSm,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      AppStrings.homeTotalSpending,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            '${AppStrings.currencySymbol}${totalAmount.toStringAsFixed(2)}',
            style: AppTextStyles.amountLarge.copyWith(
              color: Colors.white,
            ),
          ),
          if (percentChange != null) ...[
            const SizedBox(height: AppSizes.sm),
            _buildPercentChange(percentChange, theme),
          ],
        ],
      ),
    );
  }

  double? _calculatePercentChange() {
    if (previousAmount == null || previousAmount == 0) return null;
    return ((totalAmount - previousAmount!) / previousAmount!) * 100;
  }

  Widget _buildPercentChange(double percent, ThemeData theme) {
    final isPositive = percent >= 0;
    return Row(
      children: [
        Icon(
          isPositive
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          size: AppSizes.iconXs,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        const SizedBox(width: AppSizes.xs),
        Text(
          '${percent.abs().toStringAsFixed(1)}% vs last period',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class SmallSummaryCard extends StatelessWidget {
  const SmallSummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    this.iconColor,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppSizes.borderRadiusMd,
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
              borderRadius: AppSizes.borderRadiusSm,
            ),
            child: Icon(
              icon,
              size: AppSizes.iconSm,
              color: iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            '${AppStrings.currencySymbol}${amount.toStringAsFixed(2)}',
            style: AppTextStyles.amountSmall.copyWith(
              color:
                  isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            ),
          ),
        ],
      ),
    );
  }
}
