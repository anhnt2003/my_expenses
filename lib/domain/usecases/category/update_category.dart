import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/* Use case: Update an existing category */

class UpdateCategory {
  final CategoryRepository _repository;

  const UpdateCategory(this._repository);

  Future<Either<Failure, Category>> call(Category category) {
    return _repository.updateCategory(category);
  }
}
