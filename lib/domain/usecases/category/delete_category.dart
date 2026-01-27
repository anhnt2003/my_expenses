import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/category_repository.dart';

/* Use case: Delete a category by ID
   Note: Default categories cannot be deleted */

class DeleteCategory {
  final CategoryRepository _repository;

  const DeleteCategory(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteCategory(id);
  }
}
