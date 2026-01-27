import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failures.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/* Use case: Get all categories */

class GetCategories {
  final CategoryRepository _repository;

  const GetCategories(this._repository);

  Future<Either<Failure, List<Category>>> call() {
    return _repository.getCategories();
  }
}
