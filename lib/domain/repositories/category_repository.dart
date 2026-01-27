import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../entities/category.dart';

/* Abstract repository interface for category operations
   Implementations in data layer will use Hive for storage */

abstract class CategoryRepository {
  /* Get all categories */
  Future<Either<Failure, List<Category>>> getCategories();

  /* Get a single category by ID */
  Future<Either<Failure, Category>> getCategoryById(String id);

  /* Add a new category */
  Future<Either<Failure, Category>> addCategory(Category category);

  /* Update an existing category */
  Future<Either<Failure, Category>> updateCategory(Category category);

  /* Delete a category by ID - only non-default categories can be deleted */
  Future<Either<Failure, void>> deleteCategory(String id);

  /* Seed default categories if none exist */
  Future<Either<Failure, void>> seedDefaultCategories();
}
