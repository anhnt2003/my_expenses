import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

/// A tile widget for displaying a single category item.
///
/// Features:
/// - Category icon and color display
/// - Name and expense count
/// - Edit/delete action buttons
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.expenseCount = 0,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final MockCategory category;
  final int expenseCount;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.borderRadiusMd,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isDark
                  ? AppColors.darkOutline.withValues(alpha: 0.3)
                  : AppColors.lightOutline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              _buildCategoryIcon(),
              const SizedBox(width: AppSizes.md),
              Expanded(child: _buildContent(context)),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: AppSizes.categoryIconSizeLg,
      height: AppSizes.categoryIconSizeLg,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.15),
        borderRadius: AppSizes.borderRadiusMd,
      ),
      child: Icon(
        category.icon,
        color: category.color,
        size: AppSizes.iconLg,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          category.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          '$expenseCount expenses',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: AppSizes.iconMd,
          ),
          onPressed: onEdit,
          tooltip: AppStrings.categoriesEdit,
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.error,
            size: AppSizes.iconMd,
          ),
          onPressed: onDelete,
          tooltip: AppStrings.formDelete,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
