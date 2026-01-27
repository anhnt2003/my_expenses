import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Add a new expense */

class AddExpense {
  final ExpenseRepository _repository;

  const AddExpense(this._repository);

  Future<Either<Failure, Expense>> call(Expense expense) {
    return _repository.addExpense(expense);
  }
}
