import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/categories/widgets/category_form_dialog.dart';
import 'package:my_expenses/feature/categories/widgets/category_tile.dart';
import 'package:my_expenses/shared/widgets/empty_state_widget.dart';

/// The main categories screen.
///
/// Features:
/// - List of all categories
/// - Add category FAB
/// - Edit/delete actions (visual only)
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<MockCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = List.from(MockData.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categoriesTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _categories.isEmpty ? _buildEmptyState() : _buildCategoryList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.categoriesAddNew),
        heroTag: 'categories_fab',
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.category_rounded,
      message: AppStrings.categoriesNoCategories,
      description: AppStrings.categoriesNoCategoriesDesc,
      actionLabel: AppStrings.categoriesAddNew,
      onAction: () => _showAddDialog(),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
        bottom: AppSizes.xxl + AppSizes.xl, // Extra padding for FAB
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final expenseCount = _getExpenseCount(category);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: CategoryTile(
            key: ValueKey(category.id),
            category: category,
            expenseCount: expenseCount,
            onTap: () => _showEditDialog(category),
            onEdit: () => _showEditDialog(category),
            onDelete: () => _showDeleteConfirmation(category),
          ),
        );
      },
    );
  }

  int _getExpenseCount(MockCategory category) {
    return MockData.expenses.where((e) => e.category.id == category.id).length;
  }

  void _showAddDialog() {
    CategoryFormDialog.show(context);
  }

  void _showEditDialog(MockCategory category) {
    CategoryFormDialog.show(context, category: category);
  }

  void _showDeleteConfirmation(MockCategory category) {
    final expenseCount = _getExpenseCount(category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.formDelete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${category.name}"?'),
            if (expenseCount > 0) ...[
              const SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppSizes.borderRadiusSm,
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: AppSizes.iconMd,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        'This category has $expenseCount expense${expenseCount > 1 ? 's' : ''} associated with it.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.commonNo),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(category);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text(AppStrings.commonYes),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(MockCategory category) {
    // Visual only - just show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${category.name}" deleted successfully!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Visual only - would restore category
          },
        ),
      ),
    );
  }
}
