import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/expense.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../providers/home_provider.dart';
import '../../categories/providers/categories_provider.dart';

class RecentExpensesList extends ConsumerWidget {
  const RecentExpensesList({
    super.key,
    this.onSeeAllPressed,
  });

  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentExpenses = ref.watch(recentExpensesProvider);
    final categories = ref.watch(categoriesListProvider);

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
        recentExpenses.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSizes.lg),
            child: Center(child: AppLoadingWidget()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text('Error loading expenses: $error'),
          ),
          data: (result) => result.fold(
            (failure) => Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text('Error: ${failure.message}'),
            ),
            (expenses) {
              if (expenses.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSizes.lg),
                  child: EmptyStateWidget(
                    icon: Icons.receipt_long_rounded,
                    message: 'No expenses yet',
                    description: 'Tap + to add your first expense',
                  ),
                );
              }

              return categories.when(
                loading: () => const AppLoadingWidget(),
                error: (_, __) => _buildExpenseList(context, expenses, null),
                data: (catResult) => catResult.fold(
                  (_) => _buildExpenseList(context, expenses, null),
                  (cats) => _buildExpenseList(context, expenses, cats),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseList(
    BuildContext context,
    List<Expense> expenses,
    List<dynamic>? categories,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (context, index) => _ExpenseItem(
        key: ValueKey(expenses[index].id),
        expense: expenses[index],
        categories: categories,
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  const _ExpenseItem({
    super.key,
    required this.expense,
    this.categories,
  });

  final Expense expense;
  final List<dynamic>? categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    /* Find category for this expense */
    IconData categoryIcon = Icons.category;
    Color categoryColor = AppColors.primary;

    if (categories != null) {
      try {
        final category = categories!.firstWhere(
          (c) => c.id == expense.categoryId,
          orElse: () => null,
        );
        if (category != null) {
          categoryIcon = category.icon;
          categoryColor = category.color;
        }
      } catch (_) {}
    }

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
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: AppSizes.borderRadiusSm,
            ),
            child: Icon(
              categoryIcon,
              size: AppSizes.iconSm,
              color: categoryColor,
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
            '-${CurrencyFormatter.format(expense.amount)}',
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
