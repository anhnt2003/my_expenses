import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/expense.dart';
import '../providers/expenses_provider.dart';
import '../widgets/expense_form.dart';

/* Screen for adding a new expense */

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expensesAddNew),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: AppStrings.formCancel,
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: const SafeArea(
        child: ExpenseForm(),
      ),
    );
  }
}

/* Screen for editing an existing expense */

class EditExpenseScreen extends ConsumerWidget {
  const EditExpenseScreen({
    super.key,
    this.expenseId,
  });

  final String? expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenseId == null) {
      return const Scaffold(
        body: Center(child: Text('Expense not found')),
      );
    }

    final expensesAsync = ref.watch(expensesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expensesEdit),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: AppStrings.formCancel,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _showDeleteConfirmation(context, ref),
            tooltip: AppStrings.formDelete,
          ),
          const SizedBox(width: AppSizes.sm),
        ],
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: expensesAsync.when(
          loading: () => const Center(child: AppLoadingWidget()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (result) => result.fold(
            (failure) => Center(child: Text('Error: ${failure.message}')),
            (expenses) {
              Expense? expense;
              try {
                expense = expenses.firstWhere((e) => e.id == expenseId);
              } catch (_) {}

              if (expense == null) {
                return const Center(child: Text('Expense not found'));
              }

              return ExpenseForm(
                initialTitle: expense.title,
                initialAmount: expense.amount,
                initialCategoryId: expense.categoryId,
                initialDate: expense.date,
                initialNote: expense.note,
                isEditing: true,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.formDelete),
        content: const Text(AppStrings.commonConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.commonNo),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final result = await ref
                  .read(expensesNotifierProvider.notifier)
                  .deleteExpense(expenseId!);
              if (context.mounted) {
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.error,
                    ),
                  ),
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Expense deleted successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
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
