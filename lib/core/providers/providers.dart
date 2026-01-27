import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/local/category_local_datasource.dart';
import '../../data/datasources/local/expense_local_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/category/add_category.dart';
import '../../domain/usecases/category/delete_category.dart';
import '../../domain/usecases/category/get_categories.dart';
import '../../domain/usecases/category/update_category.dart';
import '../../domain/usecases/expense/add_expense.dart';
import '../../domain/usecases/expense/delete_expense.dart';
import '../../domain/usecases/expense/get_expenses.dart';
import '../../domain/usecases/expense/get_expenses_by_category.dart';
import '../../domain/usecases/expense/get_expenses_by_date_range.dart';
import '../../domain/usecases/expense/update_expense.dart';

/* Core providers for dependency injection via Riverpod
   These providers get instances from GetIt service locator */

final getIt = GetIt.instance;

/* Data Source Providers */

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  return getIt<ExpenseLocalDataSource>();
});

final categoryLocalDataSourceProvider =
    Provider<CategoryLocalDataSource>((ref) {
  return getIt<CategoryLocalDataSource>();
});

/* Repository Providers */

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseLocalDataSourceProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(categoryLocalDataSourceProvider));
});

/* Expense Use Case Providers */

final addExpenseUseCaseProvider = Provider<AddExpense>((ref) {
  return AddExpense(ref.watch(expenseRepositoryProvider));
});

final getExpensesUseCaseProvider = Provider<GetExpenses>((ref) {
  return GetExpenses(ref.watch(expenseRepositoryProvider));
});

final updateExpenseUseCaseProvider = Provider<UpdateExpense>((ref) {
  return UpdateExpense(ref.watch(expenseRepositoryProvider));
});

final deleteExpenseUseCaseProvider = Provider<DeleteExpense>((ref) {
  return DeleteExpense(ref.watch(expenseRepositoryProvider));
});

final getExpensesByCategoryUseCaseProvider =
    Provider<GetExpensesByCategory>((ref) {
  return GetExpensesByCategory(ref.watch(expenseRepositoryProvider));
});

final getExpensesByDateRangeUseCaseProvider =
    Provider<GetExpensesByDateRange>((ref) {
  return GetExpensesByDateRange(ref.watch(expenseRepositoryProvider));
});

/* Category Use Case Providers */

final addCategoryUseCaseProvider = Provider<AddCategory>((ref) {
  return AddCategory(ref.watch(categoryRepositoryProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategories>((ref) {
  return GetCategories(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategory>((ref) {
  return UpdateCategory(ref.watch(categoryRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategory>((ref) {
  return DeleteCategory(ref.watch(categoryRepositoryProvider));
});
