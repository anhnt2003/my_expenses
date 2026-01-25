import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

/// A grid selector for choosing expense categories.
///
/// Features:
/// - Grid layout of category icons with labels
/// - Selected state styling with animation
/// - Uses mock categories for display
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.crossAxisCount = 4,
  });

  final List<MockCategory> categories;
  final MockCategory? selectedCategory;
  final ValueChanged<MockCategory> onCategorySelected;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory?.id == category.id;
        return _CategoryItem(
          key: ValueKey(category.id),
          category: category,
          isSelected: isSelected,
          onTap: () => onCategorySelected(category),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final MockCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.borderRadiusMd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppSizes.animFast),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? category.color.withValues(alpha: 0.15)
                : (isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isSelected ? category.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: AppSizes.animFast),
                width: AppSizes.categoryIconSize,
                height: AppSizes.categoryIconSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color
                      : category.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: isSelected ? Colors.white : category.color,
                  size: AppSizes.iconMd,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                category.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? category.color
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
