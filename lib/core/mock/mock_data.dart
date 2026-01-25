import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_strings.dart';

class MockCategory {
  const MockCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
}

class MockExpense {
  const MockExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final MockCategory category;
  final DateTime date;
  final String? note;
}

class MockData {
  MockData._();

  static final List<MockCategory> categories = [
    const MockCategory(
      id: '1',
      name: AppStrings.categoryFood,
      icon: Icons.restaurant_rounded,
      color: AppColors.categoryFood,
    ),
    const MockCategory(
      id: '2',
      name: AppStrings.categoryTransport,
      icon: Icons.directions_car_rounded,
      color: AppColors.categoryTransport,
    ),
    const MockCategory(
      id: '3',
      name: AppStrings.categoryShopping,
      icon: Icons.shopping_bag_rounded,
      color: AppColors.categoryShopping,
    ),
    const MockCategory(
      id: '4',
      name: AppStrings.categoryEntertainment,
      icon: Icons.movie_rounded,
      color: AppColors.categoryEntertainment,
    ),
    const MockCategory(
      id: '5',
      name: AppStrings.categoryBills,
      icon: Icons.receipt_rounded,
      color: AppColors.categoryBills,
    ),
    const MockCategory(
      id: '6',
      name: AppStrings.categoryHealth,
      icon: Icons.medical_services_rounded,
      color: AppColors.categoryHealth,
    ),
    const MockCategory(
      id: '7',
      name: AppStrings.categoryEducation,
      icon: Icons.school_rounded,
      color: AppColors.categoryEducation,
    ),
    const MockCategory(
      id: '8',
      name: AppStrings.categoryOther,
      icon: Icons.category_rounded,
      color: AppColors.categoryOther,
    ),
  ];

  static List<MockExpense> get expenses {
    final now = DateTime.now();
    return [
      MockExpense(
        id: '1',
        title: 'Grocery Shopping',
        amount: 85.50,
        category: categories[0],
        date: now.subtract(const Duration(hours: 2)),
        note: 'Weekly groceries from supermarket',
      ),
      MockExpense(
        id: '2',
        title: 'Uber Ride',
        amount: 24.00,
        category: categories[1],
        date: now.subtract(const Duration(hours: 5)),
      ),
      MockExpense(
        id: '3',
        title: 'Netflix Subscription',
        amount: 15.99,
        category: categories[3],
        date: now.subtract(const Duration(days: 1)),
        note: 'Monthly subscription',
      ),
      MockExpense(
        id: '4',
        title: 'New Shoes',
        amount: 129.99,
        category: categories[2],
        date: now.subtract(const Duration(days: 2)),
      ),
      MockExpense(
        id: '5',
        title: 'Electricity Bill',
        amount: 78.50,
        category: categories[4],
        date: now.subtract(const Duration(days: 3)),
      ),
      MockExpense(
        id: '6',
        title: 'Doctor Visit',
        amount: 50.00,
        category: categories[5],
        date: now.subtract(const Duration(days: 4)),
        note: 'Regular checkup',
      ),
      MockExpense(
        id: '7',
        title: 'Online Course',
        amount: 49.99,
        category: categories[6],
        date: now.subtract(const Duration(days: 5)),
        note: 'Flutter development course',
      ),
      MockExpense(
        id: '8',
        title: 'Coffee with friends',
        amount: 18.75,
        category: categories[0],
        date: now.subtract(const Duration(days: 6)),
      ),
      MockExpense(
        id: '9',
        title: 'Gas Station',
        amount: 45.00,
        category: categories[1],
        date: now.subtract(const Duration(days: 7)),
      ),
      MockExpense(
        id: '10',
        title: 'Cinema Tickets',
        amount: 32.00,
        category: categories[3],
        date: now.subtract(const Duration(days: 8)),
        note: '2 tickets for weekend movie',
      ),
    ];
  }

  static List<MockExpense> get recentExpenses => expenses.take(5).toList();

  static double get totalSpending =>
      expenses.fold(0.0, (sum, expense) => sum + expense.amount);

  static double get thisMonthSpending {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return expenses
        .where((e) => e.date.isAfter(startOfMonth))
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  static double get thisWeekSpending {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return expenses
        .where((e) => e.date.isAfter(startOfWeekDate))
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /* Statistics mock data */
  static Map<String, double> get categorySpending {
    final Map<String, double> result = {};
    for (final expense in expenses) {
      final categoryName = expense.category.name;
      result[categoryName] = (result[categoryName] ?? 0) + expense.amount;
    }
    return result;
  }

  static List<double> get monthlySpending => [
        320.50,
        285.00,
        410.25,
        380.00,
        295.75,
        450.00,
        thisMonthSpending,
      ];

  static List<String> get monthLabels => [
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
        'Jan',
      ];
}
