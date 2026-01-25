import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/expenses/widgets/expense_tile.dart';
import 'package:my_expenses/router/route_names.dart';
import 'package:my_expenses/shared/widgets/empty_state_widget.dart';

/// The main expenses list screen.
///
/// Features:
/// - AppBar with search and filter icons
/// - Date filter chips (Today, This Week, This Month, All)
/// - Grouped expense list by date
/// - Empty state when no expenses
class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  String _selectedFilter = 'all';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                setState(() => _searchController.clear());
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

    final filters = [
      ('today', AppStrings.expensesFilterToday),
      ('week', AppStrings.expensesFilterWeek),
      ('month', AppStrings.expensesFilterMonth),
      ('all', AppStrings.expensesFilterAll),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter.$1;
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: FilterChip(
                label: Text(filter.$2),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedFilter = filter.$1);
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
    final expenses = _getFilteredExpenses();

    if (expenses.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_rounded,
        message: AppStrings.expensesNoExpenses,
        description: AppStrings.expensesNoExpensesDesc,
        actionLabel: AppStrings.expensesAddNew,
        onAction: () => context.push(RouteNames.addExpense),
      );
    }

    // Group expenses by date
    final groupedExpenses = _groupExpensesByDate(expenses);

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        bottom: AppSizes.xxl + AppSizes.xl, // Extra padding for FAB
      ),
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final entry = groupedExpenses.entries.elementAt(index);
        return _buildDateGroup(context, entry.key, entry.value);
      },
    );
  }

  Widget _buildDateGroup(
    BuildContext context,
    String dateLabel,
    List<MockExpense> expenses,
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
                '${AppStrings.currencySymbol}${_calculateTotal(expenses).toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map((expense) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: ExpenseTile(
                key: ValueKey(expense.id),
                expense: expense,
                onTap: () => context.push('${RouteNames.expenses}/edit'),
                onDelete: () {
                  _showDeleteConfirmation(context, expense);
                },
              ),
            )),
      ],
    );
  }

  double _calculateTotal(List<MockExpense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  List<MockExpense> _getFilteredExpenses() {
    var expenses = MockData.expenses;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Apply date filter
    switch (_selectedFilter) {
      case 'today':
        expenses = expenses.where((e) {
          final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
          return expenseDate == today;
        }).toList();
        break;
      case 'week':
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        expenses = expenses.where((e) {
          final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
          return expenseDate
              .isAfter(startOfWeek.subtract(const Duration(days: 1)));
        }).toList();
        break;
      case 'month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        expenses = expenses.where((e) {
          return e.date.isAfter(startOfMonth.subtract(const Duration(days: 1)));
        }).toList();
        break;
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      expenses = expenses.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.category.name.toLowerCase().contains(query) ||
            (e.note?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return expenses;
  }

  Map<String, List<MockExpense>> _groupExpensesByDate(
    List<MockExpense> expenses,
  ) {
    final Map<String, List<MockExpense>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final expense in expenses) {
      final expenseDate =
          DateTime(expense.date.year, expense.date.month, expense.date.day);

      String label;
      if (expenseDate == today) {
        label = 'Today';
      } else if (expenseDate == yesterday) {
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.md),
            ListTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('By Category'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money_rounded),
              title: const Text('By Amount'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort_rounded),
              title: const Text('Sort Order'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MockExpense expense) {
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Expense deleted successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
