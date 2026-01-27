import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Get all expenses with optional date filtering */

class GetExpenses {
  final ExpenseRepository _repository;

  const GetExpenses(this._repository);

  Future<Either<Failure, List<Expense>>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.getExpenses(startDate: startDate, endDate: endDate);
  }
}
