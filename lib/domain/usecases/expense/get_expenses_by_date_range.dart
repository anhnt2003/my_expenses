import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Get expenses within a specific date range */

class GetExpensesByDateRange {
  final ExpenseRepository _repository;

  const GetExpensesByDateRange(this._repository);

  Future<Either<Failure, List<Expense>>> call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _repository.getExpensesByDateRange(startDate, endDate);
  }
}
