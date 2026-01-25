import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/expenses/widgets/category_selector.dart';
import 'package:my_expenses/feature/expenses/widgets/date_picker_field.dart';
import 'package:my_expenses/shared/widgets/custom_button.dart';
import 'package:my_expenses/shared/widgets/custom_text_field.dart';

/// A reusable form widget for adding or editing expenses.
///
/// Features:
/// - Title, amount, category, date, and note fields
/// - Form validation UI (visual only)
/// - Can be used in both add and edit screens
class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
    super.key,
    this.initialTitle,
    this.initialAmount,
    this.initialCategory,
    this.initialDate,
    this.initialNote,
    this.onSave,
    this.isEditing = false,
  });

  final String? initialTitle;
  final double? initialAmount;
  final MockCategory? initialCategory;
  final DateTime? initialDate;
  final String? initialNote;
  final VoidCallback? onSave;
  final bool isEditing;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  MockCategory? _selectedCategory;
  DateTime? _selectedDate;

  // Form validation state (visual only)
  String? _titleError;
  String? _amountError;
  String? _categoryError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _amountController = TextEditingController(
      text: widget.initialAmount?.toStringAsFixed(2),
    );
    _noteController = TextEditingController(text: widget.initialNote);
    _selectedCategory = widget.initialCategory;
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          CustomTextField(
            controller: _titleController,
            label: AppStrings.formTitle,
            hint: AppStrings.formTitleHint,
            errorText: _titleError,
            prefixIcon: Icons.title_rounded,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _clearError('title'),
          ),
          const SizedBox(height: AppSizes.lg),

          // Amount field
          CurrencyTextField(
            controller: _amountController,
            label: AppStrings.formAmount,
            hint: AppStrings.formAmountHint,
            errorText: _amountError,
            onChanged: (_) => _clearError('amount'),
          ),
          const SizedBox(height: AppSizes.lg),

          // Category selector
          Text(
            AppStrings.formCategory,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.sm),
          if (_categoryError != null) ...[
            Text(
              _categoryError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
          ],
          CategorySelector(
            categories: MockData.categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
                _categoryError = null;
              });
            },
          ),
          const SizedBox(height: AppSizes.lg),

          // Date picker
          if (_dateError != null) ...[
            Text(
              _dateError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
          ],
          DatePickerField(
            label: AppStrings.formDate,
            hint: AppStrings.formDateHint,
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _dateError = null;
              });
            },
            lastDate: DateTime.now(),
          ),
          const SizedBox(height: AppSizes.lg),

          // Note field
          CustomTextField(
            controller: _noteController,
            label: AppStrings.formNote,
            hint: AppStrings.formNoteHint,
            prefixIcon: Icons.note_rounded,
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSizes.xl),

          // Save button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: _handleSave,
              label: AppStrings.formSave,
              icon: Icons.check_rounded,
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'title':
          _titleError = null;
          break;
        case 'amount':
          _amountError = null;
          break;
      }
    });
  }

  void _handleSave() {
    // Validate form (visual only)
    bool isValid = true;

    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Please enter a title');
      isValid = false;
    }

    if (_amountController.text.trim().isEmpty) {
      setState(() => _amountError = 'Please enter an amount');
      isValid = false;
    } else {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        setState(() => _amountError = 'Please enter a valid amount');
        isValid = false;
      }
    }

    if (_selectedCategory == null) {
      setState(() => _categoryError = 'Please select a category');
      isValid = false;
    }

    if (_selectedDate == null) {
      setState(() => _dateError = 'Please select a date');
      isValid = false;
    }

    if (isValid) {
      // Visual only - just call the callback
      widget.onSave?.call();

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Expense updated successfully!'
                : 'Expense added successfully!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Pop the screen
      Navigator.of(context).pop();
    }
  }
}
