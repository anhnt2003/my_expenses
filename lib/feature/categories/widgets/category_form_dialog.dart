import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/categories/widgets/color_picker.dart';
import 'package:my_expenses/feature/categories/widgets/icon_picker.dart';
import 'package:my_expenses/shared/widgets/custom_button.dart';
import 'package:my_expenses/shared/widgets/custom_text_field.dart';

/// A modal dialog for adding or editing a category.
///
/// Features:
/// - Name input field
/// - Icon picker integration
/// - Color picker integration
/// - Save and cancel actions
class CategoryFormDialog extends StatefulWidget {
  const CategoryFormDialog({
    super.key,
    this.category,
  });

  /// If provided, the dialog is in edit mode with pre-filled values
  final MockCategory? category;

  /// Shows the category form dialog
  static Future<void> show(
    BuildContext context, {
    MockCategory? category,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) => CategoryFormDialog(category: category),
    );
  }

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  late final TextEditingController _nameController;
  late IconData _selectedIcon;
  late Color _selectedColor;
  String? _nameError;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _selectedIcon = widget.category?.icon ?? Icons.category_rounded;
    _selectedColor = widget.category?.color ?? AppColors.primary;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: AppSizes.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: AppStrings.formCancel,
                  ),
                  Expanded(
                    child: Text(
                      _isEditing
                          ? AppStrings.categoriesEdit
                          : AppStrings.categoriesAddNew,
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for close button
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(AppSizes.md),
                children: [
                  // Preview
                  _buildPreview(context),
                  const SizedBox(height: AppSizes.lg),

                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    label: AppStrings.categoriesName,
                    hint: AppStrings.categoriesNameHint,
                    errorText: _nameError,
                    prefixIcon: Icons.label_outline_rounded,
                    onChanged: (_) {
                      if (_nameError != null) {
                        setState(() => _nameError = null);
                      }
                    },
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Icon picker section
                  Text(
                    AppStrings.categoriesSelectIcon,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  IconPicker(
                    selectedIcon: _selectedIcon,
                    iconColor: _selectedColor,
                    onIconSelected: (icon) {
                      setState(() => _selectedIcon = icon);
                    },
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Color picker section
                  Text(
                    AppStrings.categoriesSelectColor,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ColorPicker(
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() => _selectedColor = color);
                    },
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Save button
                  CustomButton(
                    onPressed: _handleSave,
                    label: AppStrings.formSave,
                    icon: Icons.check_rounded,
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreview(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayName = _nameController.text.isNotEmpty
        ? _nameController.text
        : 'Category Name';

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
        borderRadius: AppSizes.borderRadiusLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.categoryIconSizeLg,
            height: AppSizes.categoryIconSizeLg,
            decoration: BoxDecoration(
              color: _selectedColor.withValues(alpha: 0.15),
              borderRadius: AppSizes.borderRadiusMd,
            ),
            child: Icon(
              _selectedIcon,
              color: _selectedColor,
              size: AppSizes.iconLg,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Text(
            displayName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    // Validate
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Please enter a category name');
      return;
    }

    // Visual only - show success and close
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Category updated successfully!'
              : 'Category added successfully!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }
}
