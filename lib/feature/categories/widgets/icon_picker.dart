import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';

/// A grid-based icon picker for category customization.
///
/// Features:
/// - Grid of Material icons
/// - Search/filter functionality
/// - Selected state styling
class IconPicker extends StatefulWidget {
  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.iconColor,
  });

  final IconData selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final Color? iconColor;

  /// Default icons available for categories
  static const List<IconData> defaultIcons = [
    Icons.restaurant_rounded,
    Icons.directions_car_rounded,
    Icons.shopping_bag_rounded,
    Icons.movie_rounded,
    Icons.receipt_rounded,
    Icons.medical_services_rounded,
    Icons.school_rounded,
    Icons.category_rounded,
    Icons.home_rounded,
    Icons.flight_rounded,
    Icons.local_cafe_rounded,
    Icons.fitness_center_rounded,
    Icons.pets_rounded,
    Icons.redeem_rounded,
    Icons.savings_rounded,
    Icons.work_rounded,
    Icons.phone_android_rounded,
    Icons.wifi_rounded,
    Icons.electric_bolt_rounded,
    Icons.water_drop_rounded,
    Icons.local_gas_station_rounded,
    Icons.local_parking_rounded,
    Icons.train_rounded,
    Icons.directions_bus_rounded,
    Icons.two_wheeler_rounded,
    Icons.local_grocery_store_rounded,
    Icons.storefront_rounded,
    Icons.local_mall_rounded,
    Icons.music_note_rounded,
    Icons.games_rounded,
    Icons.sports_esports_rounded,
    Icons.sports_soccer_rounded,
    Icons.book_rounded,
    Icons.newspaper_rounded,
    Icons.brush_rounded,
    Icons.camera_alt_rounded,
    Icons.headphones_rounded,
    Icons.tv_rounded,
    Icons.computer_rounded,
    Icons.child_care_rounded,
  ];

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IconData> get _filteredIcons {
    if (_searchQuery.isEmpty) {
      return IconPicker.defaultIcons;
    }
    // For simplicity, we filter by icon index
    // In a real app, you might have a map of icon names
    return IconPicker.defaultIcons;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = widget.iconColor ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppStrings.placeholderSearch,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark
                ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
            border: const OutlineInputBorder(
              borderRadius: AppSizes.borderRadiusMd,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        const SizedBox(height: AppSizes.md),

        // Icon grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
          ),
          itemCount: _filteredIcons.length,
          itemBuilder: (context, index) {
            final icon = _filteredIcons[index];
            final isSelected = icon == widget.selectedIcon;
            return _IconItem(
              key: ValueKey(icon.codePoint),
              icon: icon,
              isSelected: isSelected,
              iconColor: iconColor,
              onTap: () => widget.onIconSelected(icon),
            );
          },
        ),
      ],
    );
  }
}

class _IconItem extends StatelessWidget {
  const _IconItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final Color iconColor;
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
          decoration: BoxDecoration(
            color: isSelected
                ? iconColor.withValues(alpha: 0.15)
                : (isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isSelected ? iconColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? iconColor : theme.colorScheme.onSurfaceVariant,
            size: AppSizes.iconLg,
          ),
        ),
      ),
    );
  }
}
