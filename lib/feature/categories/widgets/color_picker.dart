import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';

/// A preset color palette picker widget.
///
/// Features:
/// - Grid of preset colors for category customization
/// - Selected state indicator with checkmark
/// - Smooth selection animation
class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.colors,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color>? colors;

  /// Default preset colors for categories
  static const List<Color> defaultColors = [
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Purple
    Color(0xFF6366F1), // Indigo
    Color(0xFF3B82F6), // Blue
    Color(0xFF0EA5E9), // Sky
    Color(0xFF14B8A6), // Teal
    Color(0xFF10B981), // Emerald
    Color(0xFF22C55E), // Green
    Color(0xFF84CC16), // Lime
    Color(0xFFF59E0B), // Amber
    Color(0xFF78716C), // Stone
    Color(0xFF6B7280), // Gray
    Color(0xFF64748B), // Slate
    Color(0xFF0F172A), // Dark
  ];

  @override
  Widget build(BuildContext context) {
    final colorList = colors ?? defaultColors;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: colorList.length,
      itemBuilder: (context, index) {
        final color = colorList[index];
        final isSelected = _colorsAreEqual(color, selectedColor);
        return _ColorItem(
          key: ValueKey(color.toARGB32()),
          color: color,
          isSelected: isSelected,
          onTap: () => onColorSelected(color),
        );
      },
    );
  }

  bool _colorsAreEqual(Color a, Color b) {
    return a.toARGB32() == b.toARGB32();
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppSizes.animFast),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 3,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: AppSizes.iconSm,
                )
              : null,
        ),
      ),
    );
  }
}
