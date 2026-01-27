import 'package:hive/hive.dart';
import 'package:my_expenses/core/constants/hive_constants.dart';

import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

/* Hive model for storing expenses in local database */

@HiveType(typeId: HiveConstants.expenseTypeId)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String categoryId;

  @HiveField(5)
  String? note;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late DateTime updatedAt;

  ExpenseModel();

  /* Convert Hive model to domain entity */
  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      categoryId: categoryId,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /* Create Hive model from domain entity */
  static ExpenseModel fromEntity(Expense entity) {
    return ExpenseModel()
      ..id = entity.id
      ..title = entity.title
      ..amount = entity.amount
      ..date = entity.date
      ..categoryId = entity.categoryId
      ..note = entity.note
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }
}
