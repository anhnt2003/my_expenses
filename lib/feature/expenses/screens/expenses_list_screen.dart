import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/expense.dart';
import '../../../router/route_names.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../categories/providers/categories_provider.dart';
import '../providers/expenses_provider.dart';
import '../widgets/expense_tile.dart';

/* Expenses list screen with search, filter, and CRUD operations */

class ExpensesListScreen extends ConsumerStatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  ConsumerState<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends ConsumerState<ExpensesListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterChips(context),
            Expanded(child: _buildExpensesList(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addExpense),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.expensesAddNew),
        heroTag: 'expenses_fab',
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _searchQuery = '';
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.placeholderSearch,
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          onChanged: (value) => setState(() => _searchQuery = value),
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      );
    }

    return AppBar(
      title: const Text(AppStrings.expensesTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            setState(() => _isSearching = true);
          },
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () => _showFilterBottomSheet(context),
          tooltip: 'Filter',
        ),
        const SizedBox(width: AppSizes.sm),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentFilter = ref.watch(expenseFilterProvider);

    final filters = [
      (ExpenseFilter.today, AppStrings.expensesFilterToday),
      (ExpenseFilter.thisWeek, AppStrings.expensesFilterWeek),
      (ExpenseFilter.thisMonth, AppStrings.expensesFilterMonth),
      (ExpenseFilter.all, AppStrings.expensesFilterAll),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Row(
          children: filters.map((filter) {
            final isSelected = currentFilter == filter.$1;
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: FilterChip(
                label: Text(filter.$2),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(expenseFilterProvider.notifier).state = filter.$1;
                },
                showCheckmark: false,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context) {
    final expensesAsync = ref.watch(expensesListProvider);
    final categoriesAsync = ref.watch(categoriesListProvider);

    return expensesAsync.when(
      loading: () => const Center(child: AppLoadingWidget()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (result) => result.fold(
        (failure) => Center(child: Text('Error: ${failure.message}')),
        (expenses) {
          /* Apply local search filter */
          var filteredExpenses = expenses;
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            filteredExpenses = expenses.where((e) {
              return e.title.toLowerCase().contains(query) ||
                  (e.note?.toLowerCase().contains(query) ?? false);
            }).toList();
          }

          if (filteredExpenses.isEmpty) {
            return const EmptyStateWidget(
                icon: Icons.receipt_long_rounded,
                message: AppStrings.expensesNoExpenses,
                description: AppStrings.expensesNoExpensesDesc,
                actionLabel: AppStrings.expensesAddNew);
          }

          /* Get categories for display */
          final categories = categoriesAsync.when(
            loading: () => <dynamic>[],
            error: (_, __) => <dynamic>[],
            data: (catResult) => catResult.fold(
              (_) => <dynamic>[],
              (cats) => cats,
            ),
          );

          /* Check sort type to decide on display mode */
          final currentSort = ref.watch(expenseSortProvider);
          final useDateGrouping = currentSort == ExpenseSort.dateDesc ||
              currentSort == ExpenseSort.dateAsc;

          if (useDateGrouping) {
            /* Group expenses by date for date-based sorting */
            final groupedExpenses = _groupExpensesByDate(filteredExpenses);

            return ListView.builder(
              padding: const EdgeInsets.only(
                left: AppSizes.md,
                right: AppSizes.md,
                bottom: AppSizes.xxl + AppSizes.xl,
              ),
              itemCount: groupedExpenses.length,
              itemBuilder: (context, index) {
                final entry = groupedExpenses.entries.elementAt(index);
                return _buildDateGroup(
                    context, entry.key, entry.value, categories);
              },
            );
          } else {
            /* Flat list for amount/title sorting */
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: AppSizes.md,
                right: AppSizes.md,
                bottom: AppSizes.xxl + AppSizes.xl,
              ),
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];
                return _buildExpenseItem(context, expense, categories);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDateGroup(
    BuildContext context,
    String dateLabel,
    List<Expense> expenses,
    List<dynamic> categories,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.md,
            bottom: AppSizes.sm,
          ),
          child: Row(
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                CurrencyFormatter.format(_calculateTotal(expenses)),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map((expense) {
          /* Find category for this expense */
          IconData categoryIcon = Icons.category;
          Color categoryColor = AppColors.primary;
          String categoryName = 'Unknown';

          try {
            final category = categories.firstWhere(
              (c) => c.id == expense.categoryId,
              orElse: () => null,
            );
            if (category != null) {
              categoryIcon = category.icon;
              categoryColor = category.color;
              categoryName = category.name;
            }
          } catch (_) {}

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: ExpenseTile(
              key: ValueKey(expense.id),
              expense: expense,
              categoryIcon: categoryIcon,
              categoryColor: categoryColor,
              categoryName: categoryName,
              onTap: () => context.push('${RouteNames.expenses}/${expense.id}'),
              onDelete: () => _showDeleteConfirmation(context, expense),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExpenseItem(
      BuildContext context, Expense expense, List<dynamic> categories) {
    IconData categoryIcon = Icons.category;
    Color categoryColor = AppColors.primary;
    String categoryName = 'Unknown';

    try {
      final category = categories.firstWhere(
        (c) => c.id == expense.categoryId,
        orElse: () => null,
      );
      if (category != null) {
        categoryIcon = category.icon;
        categoryColor = category.color;
        categoryName = category.name;
      }
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: ExpenseTile(
        key: ValueKey(expense.id),
        expense: expense,
        categoryIcon: categoryIcon,
        categoryColor: categoryColor,
        categoryName: categoryName,
        onTap: () => context.push('${RouteNames.expenses}/${expense.id}'),
        onDelete: () => _showDeleteConfirmation(context, expense),
      ),
    );
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final expense in expenses) {
      final expenseDate =
          DateTime(expense.date.year, expense.date.month, expense.date.day);

      String label;
      if (expenseDate.isAtSameMomentAs(today)) {
        label = 'Today';
      } else if (expenseDate.isAtSameMomentAs(yesterday)) {
        label = 'Yesterday';
      } else {
        label = DateFormat('EEEE, MMM d').format(expense.date);
      }

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(expense);
    }

    return grouped;
  }

  void _showFilterBottomSheet(BuildContext context) {
    final currentSort = ref.read(expenseSortProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.md),
            _buildSortOption(
                ctx, 'Date (Newest First)', ExpenseSort.dateDesc, currentSort),
            _buildSortOption(
                ctx, 'Date (Oldest First)', ExpenseSort.dateAsc, currentSort),
            _buildSortOption(ctx, 'Amount (Highest First)',
                ExpenseSort.amountDesc, currentSort),
            _buildSortOption(ctx, 'Amount (Lowest First)',
                ExpenseSort.amountAsc, currentSort),
            _buildSortOption(
                ctx, 'Title (A-Z)', ExpenseSort.titleAsc, currentSort),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext context, String title, ExpenseSort sort,
      ExpenseSort currentSort) {
    final isSelected = sort == currentSort;
    return ListTile(
      leading: Icon(
        isSelected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_off_rounded,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
      ),
      onTap: () {
        ref.read(expenseSortProvider.notifier).state = sort;
        Navigator.pop(context);
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.formDelete),
        content: Text('Are you sure you want to delete "${expense.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.commonNo),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await ref
                  .read(expensesNotifierProvider.notifier)
                  .deleteExpense(expense.id);
              if (context.mounted) {
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.error,
                    ),
                  ),
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Expense deleted successfully!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.commonYes),
          ),
        ],
      ),
    );
  }
}
