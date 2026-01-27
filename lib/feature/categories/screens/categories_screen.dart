import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/category.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../expenses/providers/expenses_provider.dart';
import '../../../domain/entities/expense.dart';
import '../providers/categories_provider.dart';
import '../widgets/category_form_dialog.dart';
import '../widgets/category_tile.dart';

/* Categories screen with real provider data and CRUD operations */

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final expensesAsync = ref.watch(expensesListProvider);

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
        child: categoriesAsync.when(
          loading: () => const Center(child: AppLoadingWidget()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (result) => result.fold(
            (failure) => Center(child: Text('Error: ${failure.message}')),
            (categories) => categories.isEmpty
                ? _buildEmptyState(context)
                : expensesAsync.maybeWhen(
                    data: (expResult) {
                      final expenses = expResult.getOrElse((_) => []);
                      return _buildCategoryList(
                          context, ref, categories, expenses);
                    },
                    orElse: () => const Center(child: AppLoadingWidget()),
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CategoryFormDialog.show(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.categoriesAddNew),
        heroTag: 'categories_fab',
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.category_rounded,
      message: AppStrings.categoriesNoCategories,
      description: AppStrings.categoriesNoCategoriesDesc,
      actionLabel: AppStrings.categoriesAddNew,
      onAction: () => CategoryFormDialog.show(context),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
    List<Expense> expenses,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
        bottom: AppSizes.xxl + AppSizes.xl,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final expenseCount =
            expenses.where((e) => e.categoryId == category.id).length;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: CategoryTile(
            key: ValueKey(category.id),
            category: category,
            expenseCount: expenseCount,
            onTap: () => CategoryFormDialog.show(context, category: category),
            onEdit: () => CategoryFormDialog.show(context, category: category),
            onDelete: category.isDefault
                ? null
                : () => _showDeleteConfirmation(context, ref, category),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.formDelete),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.commonNo),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final result = await ref
                  .read(categoriesNotifierProvider.notifier)
                  .deleteCategory(category.id);
              if (context.mounted) {
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.error,
                    ),
                  ),
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${category.name}" deleted successfully!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                );
              }
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
}
