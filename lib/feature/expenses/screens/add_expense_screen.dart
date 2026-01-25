import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/feature/expenses/widgets/expense_form.dart';

/// Screen for adding a new expense.
///
/// Features:
/// - Form layout with title, amount, category, date, note fields
/// - Category selector (grid)
/// - Date picker integration
/// - Save button
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
      body: SafeArea(
        child: ExpenseForm(
          onSave: () {
            // Visual only - form handles navigation
          },
        ),
      ),
    );
  }
}

/// Screen for editing an existing expense.
///
/// Features:
/// - Pre-filled form with expense data
/// - Delete option
/// - Save changes button
class EditExpenseScreen extends StatelessWidget {
  const EditExpenseScreen({
    super.key,
    this.expenseId,
  });

  final String? expenseId;

  @override
  Widget build(BuildContext context) {
    // For now, use mock data for editing
    // In a real app, this would fetch the expense by ID
    final mockExpense =
        expenseId != null ? _getMockExpenseById(expenseId!) : null;

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
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: AppStrings.formDelete,
          ),
          const SizedBox(width: AppSizes.sm),
        ],
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: ExpenseForm(
          initialTitle: mockExpense?['title'] as String?,
          initialAmount: mockExpense?['amount'] as double?,
          initialNote: mockExpense?['note'] as String?,
          isEditing: true,
          onSave: () {
            // Visual only - form handles navigation
          },
        ),
      ),
    );
  }

  Map<String, dynamic>? _getMockExpenseById(String id) {
    // Mock data for demo purposes
    return {
      'title': 'Grocery Shopping',
      'amount': 85.50,
      'note': 'Weekly groceries from supermarket',
    };
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.formDelete),
        content: const Text(AppStrings.commonConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.commonNo),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close edit screen
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
