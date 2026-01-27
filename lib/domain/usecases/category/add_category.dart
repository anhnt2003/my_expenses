import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/* Use case: Add a new category */

class AddCategory {
  final CategoryRepository _repository;

  const AddCategory(this._repository);

  Future<Either<Failure, Category>> call(Category category) {
    return _repository.addCategory(category);
  }
}
