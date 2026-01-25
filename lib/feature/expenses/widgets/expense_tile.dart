import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

/// A tile widget for displaying a single expense item.
///
/// Features:
/// - Category icon with colored background
/// - Title and amount display
/// - Date and optional note preview
/// - Swipe to delete gesture (visual only)
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  final MockExpense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        // Visual only - always return false to prevent actual dismiss
        onDelete?.call();
        return false;
      },
      background: _buildDismissBackground(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSizes.borderRadiusMd,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppSizes.borderRadiusMd,
              border: Border.all(
                color: isDark
                    ? AppColors.darkOutline.withValues(alpha: 0.3)
                    : AppColors.lightOutline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                _buildCategoryIcon(context),
                const SizedBox(width: AppSizes.md),
                Expanded(child: _buildContent(context)),
                _buildAmount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.error,
        borderRadius: AppSizes.borderRadiusMd,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline_rounded,
            color: AppColors.onError,
            size: AppSizes.iconLg,
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.formDelete,
            style: TextStyle(
              color: AppColors.onError,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context) {
    return Container(
      width: AppSizes.categoryIconSizeLg,
      height: AppSizes.categoryIconSizeLg,
      decoration: BoxDecoration(
        color: expense.category.color.withValues(alpha: 0.15),
        borderRadius: AppSizes.borderRadiusMd,
      ),
      child: Icon(
        expense.category.icon,
        color: expense.category.color,
        size: AppSizes.iconLg,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          expense.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.xs),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: AppSizes.iconXs,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              _formatDate(expense.date),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (expense.note != null && expense.note!.isNotEmpty) ...[
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  '• ${expense.note}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAmount(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppSizes.borderRadiusSm,
      ),
      child: Text(
        '-${AppStrings.currencySymbol}${expense.amount.toStringAsFixed(2)}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (expenseDate == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
