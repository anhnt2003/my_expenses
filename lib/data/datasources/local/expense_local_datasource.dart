import 'package:hive/hive.dart';

import '../../../core/constants/hive_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/expense_model.dart';

/* Local data source interface for expense operations */

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getAllExpenses();
  Future<ExpenseModel?> getExpenseById(String id);
  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId);
  Future<List<ExpenseModel>> getExpensesByDateRange(
      DateTime start, DateTime end);
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

/* Implementation using Hive for local storage */

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> _box;

  ExpenseLocalDataSourceImpl(this._box);

  /* Factory constructor to get the box from GetIt */
  static Future<ExpenseLocalDataSourceImpl> create() async {
    final box = await Hive.openBox<ExpenseModel>(HiveConstants.expensesBox);
    return ExpenseLocalDataSourceImpl(box);
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      final expenses = _box.values.toList();
      /* Sort by date descending (newest first) */
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (e) {
      throw DatabaseException('Failed to fetch expenses', originalError: e);
    }
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw DatabaseException('Failed to fetch expense by ID',
          originalError: e);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId) async {
    try {
      final expenses = _box.values
          .where((expense) => expense.categoryId == categoryId)
          .toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (e) {
      throw DatabaseException('Failed to fetch expenses by category',
          originalError: e);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final expenses = _box.values.where((expense) {
        final d = expense.date;
        return !d.isBefore(start) && !d.isAfter(end);
      }).toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (e) {
      throw DatabaseException('Failed to fetch expenses by date range',
          originalError: e);
    }
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    try {
      await _box.put(expense.id, expense);
      return expense;
    } catch (e) {
      throw DatabaseException('Failed to add expense', originalError: e);
    }
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    try {
      if (!_box.containsKey(expense.id)) {
        throw const DatabaseException('Expense not found');
      }
      await _box.put(expense.id, expense);
      return expense;
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Failed to update expense', originalError: e);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      if (!_box.containsKey(id)) {
        throw const DatabaseException('Expense not found');
      }
      await _box.delete(id);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Failed to delete expense', originalError: e);
    }
  }
}
