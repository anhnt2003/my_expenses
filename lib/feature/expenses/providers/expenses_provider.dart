import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/entities/expense.dart';
import '../../home/providers/home_provider.dart';
import '../../statistics/providers/statistics_provider.dart';

/* Expenses list provider with filtering and sorting support */

enum ExpenseFilter { all, today, thisWeek, thisMonth }

enum ExpenseSort { dateDesc, dateAsc, amountDesc, amountAsc, titleAsc }

/* Current filter state */
final expenseFilterProvider =
    StateProvider<ExpenseFilter>((ref) => ExpenseFilter.all);

/* Current sort state */
final expenseSortProvider =
    StateProvider<ExpenseSort>((ref) => ExpenseSort.dateDesc);

/* Filtered and sorted expenses list */
final expensesListProvider =
    FutureProvider<Either<Failure, List<Expense>>>((ref) async {
  final filter = ref.watch(expenseFilterProvider);
  final sort = ref.watch(expenseSortProvider);
  final getExpenses = ref.watch(getExpensesUseCaseProvider);
  final getByDateRange = ref.watch(getExpensesByDateRangeUseCaseProvider);

  final now = DateTime.now();
  Either<Failure, List<Expense>> result;

  switch (filter) {
    case ExpenseFilter.all:
      result = await getExpenses();
      break;

    case ExpenseFilter.today:
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      result = await getByDateRange(startOfDay, endOfDay);
      break;

    case ExpenseFilter.thisWeek:
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      result = await getByDateRange(
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
        DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
      );
      break;

    case ExpenseFilter.thisMonth:
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      result = await getByDateRange(startOfMonth, endOfMonth);
      break;
  }

  /* Apply sorting */
  return result.map((expenses) {
    final sorted = List<Expense>.from(expenses);
    switch (sort) {
      case ExpenseSort.dateDesc:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case ExpenseSort.dateAsc:
        sorted.sort((a, b) => a.date.compareTo(b.date));
        break;
      case ExpenseSort.amountDesc:
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case ExpenseSort.amountAsc:
        sorted.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case ExpenseSort.titleAsc:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    return sorted;
  });
});

/* Notifier for managing expense operations (add, update, delete) */
class ExpensesNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ExpensesNotifier(this._ref) : super(const AsyncValue.data(null));

  void _invalidateAllProviders() {
    /* Invalidate expense list providers */
    _ref.invalidate(expensesListProvider);
    _ref.invalidate(recentExpensesProvider);
    _ref.invalidate(monthlyTotalProvider);
    _ref.invalidate(weeklyTotalProvider);
    _ref.invalidate(todayTotalProvider);
    /* Invalidate statistics providers */
    _ref.invalidate(statsExpensesProvider);
    _ref.invalidate(pieChartDataProvider);
    _ref.invalidate(barChartDataProvider);
    _ref.invalidate(summaryStatsProvider);
    _ref.invalidate(categoryBreakdownProvider);
  }

  Future<Either<Failure, Expense>> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required String categoryId,
    String? note,
  }) async {
    state = const AsyncValue.loading();

    final now = DateTime.now();
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      categoryId: categoryId,
      note: note,
      createdAt: now,
      updatedAt: now,
    );

    final addExpenseUseCase = _ref.read(addExpenseUseCaseProvider);
    final result = await addExpenseUseCase(expense);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateAllProviders();
      },
    );

    return result;
  }

  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    state = const AsyncValue.loading();

    final updateExpenseUseCase = _ref.read(updateExpenseUseCaseProvider);
    final result =
        await updateExpenseUseCase(expense.copyWith(updatedAt: DateTime.now()));

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateAllProviders();
      },
    );

    return result;
  }

  Future<Either<Failure, void>> deleteExpense(String id) async {
    state = const AsyncValue.loading();

    final deleteExpenseUseCase = _ref.read(deleteExpenseUseCaseProvider);
    final result = await deleteExpenseUseCase(id);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateAllProviders();
      },
    );

    return result;
  }
}

/* Provider for expenses notifier */
final expensesNotifierProvider =
    StateNotifierProvider<ExpensesNotifier, AsyncValue<void>>((ref) {
  return ExpensesNotifier(ref);
});
