import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/hive_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/category.dart';
import '../../models/category_model.dart';

/* Local data source interface for category operations */

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel?> getCategoryById(String id);
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> seedDefaultCategories();
  Future<bool> hasCategories();
}

/* Implementation using Hive for local storage */

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Box<CategoryModel> _box;

  CategoryLocalDataSourceImpl(this._box);

  /* Factory constructor to get the box from GetIt */
  static Future<CategoryLocalDataSourceImpl> create() async {
    final box = await Hive.openBox<CategoryModel>(HiveConstants.categoriesBox);
    return CategoryLocalDataSourceImpl(box);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = _box.values.toList();
      /* Sort: default categories first, then by name */
      categories.sort((a, b) {
        if (a.isDefault != b.isDefault) {
          return a.isDefault ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
      return categories;
    } catch (e) {
      throw DatabaseException('Failed to fetch categories', originalError: e);
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw DatabaseException('Failed to fetch category by ID',
          originalError: e);
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      await _box.put(category.id, category);
      return category;
    } catch (e) {
      throw DatabaseException('Failed to add category', originalError: e);
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      if (!_box.containsKey(category.id)) {
        throw const DatabaseException('Category not found');
      }
      await _box.put(category.id, category);
      return category;
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Failed to update category', originalError: e);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      final category = _box.get(id);
      if (category == null) {
        throw const DatabaseException('Category not found');
      }
      if (category.isDefault) {
        throw const DatabaseException('Cannot delete default category');
      }
      await _box.delete(id);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Failed to delete category', originalError: e);
    }
  }

  @override
  Future<bool> hasCategories() async {
    return _box.isNotEmpty;
  }

  @override
  Future<void> seedDefaultCategories() async {
    if (await hasCategories()) return;

    const uuid = Uuid();
    final now = DateTime.now();

    final defaultCategories = [
      Category(
        id: uuid.v4(),
        name: 'Food & Dining',
        icon: Icons.restaurant,
        color: Colors.orange,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Transportation',
        icon: Icons.directions_car,
        color: Colors.blue,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Shopping',
        icon: Icons.shopping_bag,
        color: Colors.pink,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Entertainment',
        icon: Icons.movie,
        color: Colors.purple,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Bills & Utilities',
        icon: Icons.receipt,
        color: Colors.grey,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Health',
        icon: Icons.medical_services,
        color: Colors.green,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Education',
        icon: Icons.school,
        color: Colors.indigo,
        isDefault: true,
        createdAt: now,
      ),
      Category(
        id: uuid.v4(),
        name: 'Other',
        icon: Icons.category,
        color: Colors.teal,
        isDefault: true,
        createdAt: now,
      ),
    ];

    try {
      for (final category in defaultCategories) {
        final model = CategoryModel.fromEntity(category);
        await _box.put(model.id, model);
      }
    } catch (e) {
      throw DatabaseException('Failed to seed default categories',
          originalError: e);
    }
  }
}
