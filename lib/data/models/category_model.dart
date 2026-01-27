import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_expenses/core/constants/hive_constants.dart';

import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/* Hive model for storing categories in local database
   IconData and Color are stored as int (codePoint/value) for Hive compatibility */

@HiveType(typeId: HiveConstants.categoryTypeId)
class CategoryModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int iconCodePoint;

  @HiveField(3)
  late String iconFontFamily;

  @HiveField(4)
  late int colorValue;

  @HiveField(5)
  late bool isDefault;

  @HiveField(6)
  late DateTime createdAt;

  CategoryModel();

  /* Convert Hive model to domain entity */
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      icon: IconData(iconCodePoint, fontFamily: iconFontFamily),
      color: Color(colorValue),
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }

  /* Create Hive model from domain entity */
  static CategoryModel fromEntity(Category entity) {
    return CategoryModel()
      ..id = entity.id
      ..name = entity.name
      ..iconCodePoint = entity.icon.codePoint
      ..iconFontFamily = entity.icon.fontFamily ?? 'MaterialIcons'
      ..colorValue = entity.color.toARGB32()
      ..isDefault = entity.isDefault
      ..createdAt = entity.createdAt;
  }
}
