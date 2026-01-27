import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../entities/expense.dart';

/* Abstract repository interface for expense operations
   Implementations in data layer will use Hive for storage */

abstract class ExpenseRepository {
  /* Get all expenses, optionally filtered by date range */
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });

  /* Get a single expense by ID */
  Future<Either<Failure, Expense>> getExpenseById(String id);

  /* Get expenses filtered by category */
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
      String categoryId);

  /* Get expenses for a specific date range */
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /* Add a new expense */
  Future<Either<Failure, Expense>> addExpense(Expense expense);

  /* Update an existing expense */
  Future<Either<Failure, Expense>> updateExpense(Expense expense);

  /* Delete an expense by ID */
  Future<Either<Failure, void>> deleteExpense(String id);

  /* Get total amount for a date range */
  Future<Either<Failure, double>> getTotalAmount({
    DateTime? startDate,
    DateTime? endDate,
  });
}
