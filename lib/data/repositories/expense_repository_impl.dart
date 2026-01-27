import 'package:fpdart/fpdart.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local/expense_local_datasource.dart';
import '../models/expense_model.dart';

/* Repository implementation that wraps data source calls with Either for error handling */

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource _localDataSource;

  const ExpenseRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<ExpenseModel> models;
      if (startDate != null && endDate != null) {
        models =
            await _localDataSource.getExpensesByDateRange(startDate, endDate);
      } else {
        models = await _localDataSource.getAllExpenses();
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    try {
      final model = await _localDataSource.getExpenseById(id);
      if (model == null) {
        return const Left(DatabaseFailure('Expense not found'));
      }
      return Right(model.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
      String categoryId) async {
    try {
      final models = await _localDataSource.getExpensesByCategory(categoryId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final models =
          await _localDataSource.getExpensesByDateRange(startDate, endDate);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> addExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final result = await _localDataSource.addExpense(model);
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final result = await _localDataSource.updateExpense(model);
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await _localDataSource.deleteExpense(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalAmount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<ExpenseModel> models;
      if (startDate != null && endDate != null) {
        models =
            await _localDataSource.getExpensesByDateRange(startDate, endDate);
      } else {
        models = await _localDataSource.getAllExpenses();
      }
      final total = models.fold<double>(0, (sum, e) => sum + e.amount);
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
