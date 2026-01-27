import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/entities/category.dart';

/* Categories list provider */

final categoriesListProvider =
    FutureProvider<Either<Failure, List<Category>>>((ref) async {
  final getCategories = ref.watch(getCategoriesUseCaseProvider);
  return getCategories();
});

/* Notifier for managing category operations (add, update, delete) */
class CategoriesNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CategoriesNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<Either<Failure, Category>> addCategory({
    required String name,
    required IconData icon,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final category = Category(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      color: color,
      isDefault: false,
      createdAt: DateTime.now(),
    );

    final addCategoryUseCase = _ref.read(addCategoryUseCaseProvider);
    final result = await addCategoryUseCase(category);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(categoriesListProvider);
      },
    );

    return result;
  }

  Future<Either<Failure, Category>> updateCategory(
    String id, {
    required String name,
    required IconData icon,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    /* Get existing category to preserve createdAt and isDefault */
    final getCategories = _ref.read(getCategoriesUseCaseProvider);
    final categoriesResult = await getCategories();

    return categoriesResult.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return Left(failure);
      },
      (categories) async {
        Category? existingCategory;
        try {
          existingCategory = categories.firstWhere((c) => c.id == id);
        } catch (_) {
          const failure = CacheFailure('Category not found');
          state = AsyncValue.error(failure, StackTrace.current);
          return const Left(failure);
        }

        final updatedCategory = Category(
          id: id,
          name: name,
          icon: icon,
          color: color,
          isDefault: existingCategory.isDefault,
          createdAt: existingCategory.createdAt,
        );

        final updateCategoryUseCase = _ref.read(updateCategoryUseCaseProvider);
        final result = await updateCategoryUseCase(updatedCategory);

        result.fold(
          (failure) => state = AsyncValue.error(failure, StackTrace.current),
          (_) {
            state = const AsyncValue.data(null);
            _ref.invalidate(categoriesListProvider);
          },
        );

        return result;
      },
    );
  }

  Future<Either<Failure, void>> deleteCategory(String id) async {
    state = const AsyncValue.loading();

    final deleteCategoryUseCase = _ref.read(deleteCategoryUseCaseProvider);
    final result = await deleteCategoryUseCase(id);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(categoriesListProvider);
      },
    );

    return result;
  }
}

/* Provider for categories notifier */
final categoriesNotifierProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<void>>((ref) {
  return CategoriesNotifier(ref);
});
