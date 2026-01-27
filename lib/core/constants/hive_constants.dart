/* Hive database constants for type IDs and box names */

class HiveConstants {
  HiveConstants._();

  /* Box Names */
  static const String expensesBox = 'expenses';
  static const String categoriesBox = 'categories';
  static const String settingsBox = 'settings';

  /* Type IDs - Must be unique and never change after first use */
  static const int expenseTypeId = 0;
  static const int categoryTypeId = 1;
}
