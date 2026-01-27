import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/category.dart';

/* Form state for expense creation/editing */

class ExpenseFormState {
  final String title;
  final String amount;
  final DateTime date;
  final Category? category;
  final String note;
  final bool isSubmitting;
  final String? errorMessage;

  const ExpenseFormState({
    this.title = '',
    this.amount = '',
    DateTime? date,
    this.category,
    this.note = '',
    this.isSubmitting = false,
    this.errorMessage,
  }) : date = date ?? const _DefaultDate();

  ExpenseFormState copyWith({
    String? title,
    String? amount,
    DateTime? date,
    Category? category,
    String? note,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ExpenseFormState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  /* Validation */
  bool get isValid =>
      title.isNotEmpty &&
      amount.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0 &&
      category != null;

  double? get amountValue => double.tryParse(amount);
}

/* Helper class for default date */
class _DefaultDate implements DateTime {
  const _DefaultDate();

  @override
  dynamic noSuchMethod(Invocation invocation) => DateTime.now();
}

/* Notifier for expense form state */
class ExpenseFormNotifier extends StateNotifier<ExpenseFormState> {
  ExpenseFormNotifier() : super(ExpenseFormState(date: DateTime.now()));

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setAmount(String value) {
    state = state.copyWith(amount: value);
  }

  void setDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void setCategory(Category? value) {
    state = state.copyWith(category: value);
  }

  void setNote(String value) {
    state = state.copyWith(note: value);
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }

  void reset() {
    state = ExpenseFormState(date: DateTime.now());
  }
}

/* Provider for expense form state */
final expenseFormProvider =
    StateNotifierProvider.autoDispose<ExpenseFormNotifier, ExpenseFormState>(
        (ref) {
  return ExpenseFormNotifier();
});
