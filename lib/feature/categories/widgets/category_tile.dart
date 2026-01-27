import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/category.dart';

/* A tile widget for displaying a single category item */

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.expenseCount = 0,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Category category;
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
        Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (category.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: AppSizes.borderRadiusSm,
                ),
                child: Text(
                  'Default',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
          ],
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
        if (onDelete != null)
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
