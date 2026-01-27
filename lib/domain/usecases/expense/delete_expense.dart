import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/expense_repository.dart';

/* Use case: Delete an expense by ID */

class DeleteExpense {
  final ExpenseRepository _repository;

  const DeleteExpense(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteExpense(id);
  }
}
