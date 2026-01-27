import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/hive_constants.dart';
import '../data/datasources/local/category_local_datasource.dart';
import '../data/datasources/local/expense_local_datasource.dart';
import '../data/models/category_model.dart';
import '../data/models/expense_model.dart';

/* Service locator instance */
final getIt = GetIt.instance;

/* Configure all dependencies - call this before runApp */
Future<void> configureDependencies() async {
  /* Initialize Hive */
  await Hive.initFlutter();

  /* Register Hive type adapters */
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  /* Open Hive boxes */
  final expenseBox =
      await Hive.openBox<ExpenseModel>(HiveConstants.expensesBox);
  final categoryBox =
      await Hive.openBox<CategoryModel>(HiveConstants.categoriesBox);

  /* Register boxes as singletons */
  getIt.registerSingleton<Box<ExpenseModel>>(expenseBox);
  getIt.registerSingleton<Box<CategoryModel>>(categoryBox);

  /* Register data sources */
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(getIt<Box<ExpenseModel>>()),
  );

  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(getIt<Box<CategoryModel>>()),
  );
}

/* Seed default categories if database is empty */
Future<void> seedDefaultCategoriesIfNeeded() async {
  final categoryDataSource = getIt<CategoryLocalDataSource>();
  await categoryDataSource.seedDefaultCategories();
}
