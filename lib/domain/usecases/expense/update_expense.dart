import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Update an existing expense */

class UpdateExpense {
  final ExpenseRepository _repository;

  const UpdateExpense(this._repository);

  Future<Either<Failure, Expense>> call(Expense expense) {
    return _repository.updateExpense(expense);
  }
}
