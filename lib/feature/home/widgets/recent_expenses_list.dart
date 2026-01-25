import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

class RecentExpensesList extends StatelessWidget {
  const RecentExpensesList({
    super.key,
    this.onSeeAllPressed,
  });

  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expenses = MockData.recentExpenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeRecentExpenses,
                style: theme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: onSeeAllPressed,
                child: const Text(AppStrings.homeSeeAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: expenses.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) => _ExpenseItem(
            key: ValueKey(expenses[index].id),
            expense: expenses[index],
          ),
        ),
      ],
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  const _ExpenseItem({
    super.key,
    required this.expense,
  });

  final MockExpense expense;

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
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.categoryIconSize,
            height: AppSizes.categoryIconSize,
            decoration: BoxDecoration(
              color: expense.category.color.withValues(alpha: 0.15),
              borderRadius: AppSizes.borderRadiusSm,
            ),
            child: Icon(
              expense.category.icon,
              size: AppSizes.iconSm,
              color: expense.category.color,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  _formatDate(expense.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.lightOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${AppStrings.currencySymbol}${expense.amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
