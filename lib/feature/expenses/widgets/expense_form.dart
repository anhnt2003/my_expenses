import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/category.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../categories/providers/categories_provider.dart';
import '../providers/expenses_provider.dart';
import 'category_selector.dart';
import 'date_picker_field.dart';

/* A reusable form widget for adding or editing expenses with real data */

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({
    super.key,
    this.initialTitle,
    this.initialAmount,
    this.initialCategoryId,
    this.initialDate,
    this.initialNote,
    this.onSave,
    this.isEditing = false,
  });

  final String? initialTitle;
  final double? initialAmount;
  final String? initialCategoryId;
  final DateTime? initialDate;
  final String? initialNote;
  final VoidCallback? onSave;
  final bool isEditing;

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  Category? _selectedCategory;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  /* Form validation state */
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
    final categoriesAsync = ref.watch(categoriesListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Title field */
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

          /* Amount field */
          CurrencyTextField(
            controller: _amountController,
            label: AppStrings.formAmount,
            hint: AppStrings.formAmountHint,
            errorText: _amountError,
            onChanged: (_) => _clearError('amount'),
          ),
          const SizedBox(height: AppSizes.lg),

          /* Category selector */
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
          categoriesAsync.when(
            loading: () => const Center(child: AppLoadingWidget()),
            error: (error, _) => Text('Error loading categories: $error'),
            data: (result) => result.fold(
              (failure) => Text('Error: ${failure.message}'),
              (categories) {
                /* Set initial category if provided */
                if (_selectedCategory == null &&
                    widget.initialCategoryId != null) {
                  try {
                    _selectedCategory = categories.firstWhere(
                      (c) => c.id == widget.initialCategoryId,
                    );
                  } catch (_) {}
                }

                return CategorySelector(
                  categories: categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _categoryError = null;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          /* Date picker */
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

          /* Note field */
          CustomTextField(
            controller: _noteController,
            label: AppStrings.formNote,
            hint: AppStrings.formNoteHint,
            prefixIcon: Icons.note_rounded,
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSizes.xl),

          /* Save button */
          SizedBox(
            width: double.infinity,
            child: _isSubmitting
                ? const Center(child: AppLoadingWidget())
                : CustomButton(
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

  Future<void> _handleSave() async {
    /* Validate form */
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

    if (!isValid) return;

    setState(() => _isSubmitting = true);

    /* Save the expense */
    final result = await ref.read(expensesNotifierProvider.notifier).addExpense(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text),
          date: _selectedDate!,
          categoryId: _selectedCategory!.id,
          note: _noteController.text.trim().isNotEmpty
              ? _noteController.text.trim()
              : null,
        );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        widget.onSave?.call();
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
        Navigator.of(context).pop();
      },
    );
  }
}
