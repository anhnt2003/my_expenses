import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/category.dart';
import '../../categories/providers/categories_provider.dart';

/* Statistics providers for charts and summaries */

enum StatsPeriod { week, month, year }

/* Current period state */
final statsPeriodProvider =
    StateProvider<StatsPeriod>((ref) => StatsPeriod.month);

/* Expenses for the selected period */
final statsExpensesProvider =
    FutureProvider<Either<Failure, List<Expense>>>((ref) async {
  final period = ref.watch(statsPeriodProvider);
  final getByDateRange = ref.watch(getExpensesByDateRangeUseCaseProvider);

  final now = DateTime.now();
  late DateTime start;
  late DateTime end;

  switch (period) {
    case StatsPeriod.week:
      start = now.subtract(Duration(days: now.weekday - 1));
      end = start.add(const Duration(days: 6));
      break;
    case StatsPeriod.month:
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0);
      break;
    case StatsPeriod.year:
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year, 12, 31);
      break;
  }

  return getByDateRange(
    DateTime(start.year, start.month, start.day),
    DateTime(end.year, end.month, end.day, 23, 59, 59),
  );
});

/* Data item for pie chart */
class PieChartDataItem {
  final String label;
  final double value;
  final Color color;

  const PieChartDataItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

/* Pie chart data provider */
final pieChartDataProvider =
    FutureProvider<Either<Failure, List<PieChartDataItem>>>((ref) async {
  final expensesResult = await ref.watch(statsExpensesProvider.future);
  final categoriesResult = await ref.watch(categoriesListProvider.future);

  return expensesResult.fold(
    (failure) => Left(failure),
    (expenses) {
      return categoriesResult.fold(
        (failure) => Left(failure),
        (categories) {
          if (expenses.isEmpty) {
            return const Right([]);
          }

          /* Group expenses by category */
          final categoryAmounts = <String, double>{};
          for (final expense in expenses) {
            categoryAmounts[expense.categoryId] =
                (categoryAmounts[expense.categoryId] ?? 0) + expense.amount;
          }

          /* Create pie chart data items */
          final items = <PieChartDataItem>[];
          for (final entry in categoryAmounts.entries) {
            Category? category;
            try {
              category = categories.firstWhere((c) => c.id == entry.key);
            } catch (_) {
              category = categories.isNotEmpty ? categories.last : null;
            }

            if (category != null) {
              items.add(PieChartDataItem(
                label: category.name,
                value: entry.value,
                color: category.color,
              ));
            }
          }

          /* Sort by value descending */
          items.sort((a, b) => b.value.compareTo(a.value));

          return Right(items);
        },
      );
    },
  );
});

/* Data item for bar chart */
class BarChartDataItem {
  final String label;
  final double value;

  const BarChartDataItem({
    required this.label,
    required this.value,
  });
}

/* Bar chart data provider (last 6 months) */
final barChartDataProvider =
    FutureProvider<Either<Failure, List<BarChartDataItem>>>((ref) async {
  final now = DateTime.now();
  final getExpenses = ref.read(getExpensesUseCaseProvider);

  final result = await getExpenses();

  return result.map((expenses) {
    final items = <BarChartDataItem>[];
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    /* Get last 6 months */
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthExpenses = expenses.where(
          (e) => e.date.year == month.year && e.date.month == month.month);
      final total = monthExpenses.fold<double>(0, (sum, e) => sum + e.amount);
      items.add(BarChartDataItem(
        label: monthNames[month.month - 1],
        value: total,
      ));
    }

    return items;
  });
});

/* Summary statistics data class  */
class SummaryStats {
  final double total;
  final double average;
  final double highest;
  final int count;

  const SummaryStats({
    required this.total,
    required this.average,
    required this.highest,
    required this.count,
  });
}

/* Summary stats provider */
final summaryStatsProvider =
    FutureProvider<Either<Failure, SummaryStats>>((ref) async {
  final expensesResult = await ref.watch(statsExpensesProvider.future);

  return expensesResult.map((expenses) {
    if (expenses.isEmpty) {
      return const SummaryStats(
        total: 0,
        average: 0,
        highest: 0,
        count: 0,
      );
    }

    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final highest =
        expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return SummaryStats(
      total: total,
      average: total / expenses.length,
      highest: highest,
      count: expenses.length,
    );
  });
});

/* Category breakdown (for detailed stats) */
class CategoryStats {
  final Category category;
  final double amount;
  final double percentage;

  const CategoryStats({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

final categoryBreakdownProvider =
    FutureProvider<Either<Failure, List<CategoryStats>>>((ref) async {
  final expensesResult = await ref.watch(statsExpensesProvider.future);
  final categoriesResult = await ref.watch(categoriesListProvider.future);

  return expensesResult.fold(
    (failure) => Left(failure),
    (expenses) {
      return categoriesResult.fold(
        (failure) => Left(failure),
        (categories) {
          if (expenses.isEmpty) {
            return const Right([]);
          }

          final totalAmount =
              expenses.fold<double>(0, (sum, e) => sum + e.amount);

          /* Group expenses by category */
          final categoryAmounts = <String, double>{};
          for (final expense in expenses) {
            categoryAmounts[expense.categoryId] =
                (categoryAmounts[expense.categoryId] ?? 0) + expense.amount;
          }

          /* Create category stats */
          final stats = <CategoryStats>[];
          for (final entry in categoryAmounts.entries) {
            Category? category;
            try {
              category = categories.firstWhere((c) => c.id == entry.key);
            } catch (_) {
              category = categories.isNotEmpty ? categories.last : null;
            }

            if (category != null) {
              stats.add(CategoryStats(
                category: category,
                amount: entry.value,
                percentage: (entry.value / totalAmount) * 100,
              ));
            }
          }

          /* Sort by amount descending */
          stats.sort((a, b) => b.amount.compareTo(a.amount));

          return Right(stats);
        },
      );
    },
  );
});
