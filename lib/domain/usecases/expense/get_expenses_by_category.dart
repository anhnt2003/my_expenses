import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Get expenses filtered by category */

class GetExpensesByCategory {
  final ExpenseRepository _repository;

  const GetExpensesByCategory(this._repository);

  Future<Either<Failure, List<Expense>>> call(String categoryId) {
    return _repository.getExpensesByCategory(categoryId);
  }
}
