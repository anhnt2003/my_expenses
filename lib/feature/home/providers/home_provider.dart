import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/entities/expense.dart';

/* Home screen providers for dashboard data */

/* Provider for recent expenses (last 5) */
final recentExpensesProvider =
    FutureProvider<Either<Failure, List<Expense>>>((ref) async {
  final getExpenses = ref.watch(getExpensesUseCaseProvider);
  final result = await getExpenses();
  return result.map((expenses) => expenses.take(5).toList());
});

/* Provider for total spending this month */
final monthlyTotalProvider =
    FutureProvider<Either<Failure, double>>((ref) async {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  final expenseRepo = ref.watch(expenseRepositoryProvider);
  return expenseRepo.getTotalAmount(
      startDate: startOfMonth, endDate: endOfMonth);
});

/* Provider for total spending this week */
final weeklyTotalProvider =
    FutureProvider<Either<Failure, double>>((ref) async {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  final expenseRepo = ref.watch(expenseRepositoryProvider);
  return expenseRepo.getTotalAmount(
    startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
    endDate:
        DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
  );
});

/* Provider for today's total */
final todayTotalProvider = FutureProvider<Either<Failure, double>>((ref) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  final expenseRepo = ref.watch(expenseRepositoryProvider);
  return expenseRepo.getTotalAmount(startDate: startOfDay, endDate: endOfDay);
});
